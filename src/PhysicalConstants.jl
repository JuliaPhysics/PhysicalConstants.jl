module PhysicalConstants

using Measurements, Unitful

import Measurements: value, uncertainty
import Unitful: AbstractQuantity

# The type

struct Constant{sym,T,D,U} <: AbstractQuantity{T,D,U} end

# Define helper functions whose method will be implemented in the macros below

function name end
function ref end

# Functions composing the building blocks of the macros

function _constant_preamble(sym, unit, def)
    esym = esc(sym)
    qsym = esc(Expr(:quote, sym))
    eunit = esc(unit)
    _bigconvert = isa(def,Symbol) ? quote
        function _big(::Constant{$qsym,T,D,U}) where {T,D,U}
            c = BigFloat()
            ccall(($(string("mpfr_const_", def)), :libmpfr),
                  Cint, (Ref{BigFloat}, Int32), c, MPFR.ROUNDING_MODE[])
            return c
        end
    end : quote
        _big(::Constant{$qsym,T,D,U}) where {T,D,U} = $(esc(def))
    end
    return esym, qsym, eunit, _bigconvert
end

function _constant_begin(qsym, esym, eunit, val, _bigconvert)
    quote
        const $esym = Constant{$qsym,Float64,dimension($eunit),typeof($eunit)}()
        export $esym
        Base.float(::Constant{$qsym,T,D,U}) where {T,D,U} = $val * $eunit
        Base.float(FT::DataType, ::Constant{$qsym,T,D,U}) where {T,D,U} = FT($val) * $eunit
        $_bigconvert
        Base.big(x::Constant{$qsym,T,D,U}) where {T,D,U} = _big(x) * $eunit
        Base.float(::Type{BigFloat}, x::Constant{$qsym,T,D,U}) where {T,D,U} = big(x)
    end
end

function _constant_end(qsym, esym, name, reference, eunit)
    quote
        Measurements.measurement(::Constant{$qsym,T,D,U}) where {T,D,U} = measurement(Float64, $esym)

        PhysicalConstants.name(::Constant{$qsym,T,D,U}) where {T,D,U}   = $name
        PhysicalConstants.ref(::Constant{$qsym,T,D,U}) where {T,D,U}    = $reference
        Unitful.unit(::Constant{$qsym,T,D,U}) where {T,D,U}      = $eunit
        Unitful.dimension(::Constant{$qsym,T,D,U}) where {T,D,U} = D

        @assert isa(ustrip(float($esym)), Float64)
        @assert isa(ustrip(big($esym)), BigFloat)
        @assert isa(ustrip(measurement($esym)), Measurement{Float64})
        @assert isa(ustrip(measurement(Float32, $esym)), Measurement{Float32})
        @assert ustrip(float(Float64, $esym)) == Float64(ustrip(big($esym)))
        @assert ustrip(float(Float32, $esym)) == Float32(ustrip(big($esym)))
        @assert Float64(value(ustrip(measurement(BigFloat, $esym)))) ==
            value(ustrip(measurement($esym)))
        @assert Float64(uncertainty(ustrip(measurement(BigFloat, $esym)))) ==
            uncertainty(ustrip(measurement($esym)))
        @assert ustrip(big($esym)) == value(ustrip(measurement(BigFloat, $esym)))
    end
end

# Currently AbstractQuantity defines some operations in terms of the inner field `val`.

function Base.getproperty(c::Constant{s,T,D,U}, sym::Symbol) where {s,T,D,U}
    if sym === :val
        return ustrip(unit(c), float(T, c))
    else # fallback to getfield
        return getfield(c, sym)
    end
end

# @constant and @derived_constant macros

macro constant(sym, name, val, def, unit, unc, bigunc, reference)
    esym, qsym, eunit, _bigconvert = _constant_preamble(sym, unit, def)
    tag = Measurements.tag_counters[Base.Threads.threadid()] += 1
    quote
        $(_constant_begin(qsym, esym, eunit, val, _bigconvert))

        function Measurements.measurement(FT::DataType, ::Constant{$qsym,T,D,U}) where {T,D,U}
            vl = FT($val)
            newder = Measurements.empty_der2(vl)
            if iszero($unc)
                return Measurement{FT}(vl, FT($unc), UInt64(0), newder) * $eunit
            else
                return Measurement{FT}(vl, FT($unc), $tag,
                                       Measurements.Derivatives(newder,
                                                                (vl, $unc, $tag)=>one(FT))) * $eunit
            end
        end
        function Measurements.measurement(::Type{BigFloat}, x::Constant{$qsym,T,D,U}) where {T,D,U}
            vl = _big(x)
            unc = BigFloat($bigunc)
            newder = Measurements.empty_der2(vl)
            if iszero($unc)
                return Measurement{BigFloat}(vl, unc, UInt64(0), newder) * $eunit
            else
                return Measurement{BigFloat}(vl, unc, $tag,
                                             Measurements.Derivatives(newder,
                                                                      (vl, unc, $tag)=>one(BigFloat))) * $eunit
            end
        end

        $(_constant_end(qsym, esym, name, reference, eunit))
    end
end

macro derived_constant(sym, name, val, def, unit, measure64, measurebig, reference)
    esym, qsym, eunit, _bigconvert = _constant_preamble(sym, unit, def)
    quote
        $(_constant_begin(qsym, esym, eunit, val, _bigconvert))

        Measurements.measurement(::Type{Float64}, ::Constant{$qsym,T,D,U}) where {T,D,U} = $(esc(measure64))
        Measurements.measurement(::Type{BigFloat}, ::Constant{$qsym,T,D,U}) where {T,D,U} = $(esc(measurebig))
        Measurements.measurement(FT::DataType, x::Constant{$qsym,T,D,U}) where {T,D,U} =
            convert(Measurement{FT}, ustrip(measurement(x))) * $eunit

        $(_constant_end(qsym, esym, name, reference, eunit))
    end
end

# Show the constants in the REPL

function Base.show(io::IO, x::Constant{sym,T,D,U}) where {T,D,U} where sym
    println(io, "$(name(x)) ($sym)")
    println(io, "Value                         = ", float(x))
    println(io, "Standard uncertainty          = ",
            iszero(uncertainty(ustrip(measurement(x)))) ? "(exact)" :
            uncertainty(ustrip(measurement(x))) * unit(x))
    println(io, "Relative standard uncertainty = ",
            iszero(uncertainty(ustrip(measurement(x)))) ? "(exact)" :
            round(uncertainty(ustrip(measurement(x)))/value(ustrip(measurement(x))),
                  sigdigits=2))
    print(io,   "Reference                     = ", ref(x))
end

"""
    float(::Constant{symbol,T,D,U}) where {T,D,U}
    float(FloatType, ::Constant{symbol,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with the floating type optionally specified by
`FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2014

julia> G
Newtonian constant of gravitation (G)
Value                         = 6.67408e-11 m^3 kg^-1 s^-2
Standard uncertainty          = 3.1e-15 m^3 kg^-1 s^-2
Relative standard uncertainty = 4.6e-5
Reference                     = CODATA 2014

julia> float(G)
6.67408e-11 m^3 kg^-1 s^-2

julia> float(Float32, G)
6.67408f-11 m^3 kg^-1 s^-2
```
"""
float(::Constant)

"""
    measurement(::Constant{symbol,T,D,U}) where {T,D,U}
    measurement(FloatType, ::Constant{symbol,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with standard uncertainty.  The floating-point
precision can be optionally specified with the `FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2014, Measurements

julia> h
Planck constant (h)
Value                         = 6.62607004e-34 J s
Standard uncertainty          = 8.1e-42 J s
Relative standard uncertainty = 1.2e-8
Reference                     = CODATA 2014

julia> measurement(h)
6.62607004e-34 ± 8.1e-42 J s

julia> measurement(Float32, h)
6.62607e-34 ± 8.1e-42 J s
```
"""
measurement(::Constant)

include("promotion.jl")
include("codata2014.jl")

end # module
