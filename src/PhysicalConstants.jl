module PhysicalConstants

using Measurements, Unitful

import Measurements: value, uncertainty
import Unitful: AbstractQuantity

# The type

struct PhysicalConstant{name,T,D,U} <: AbstractQuantity{T,D,U} end

_name(::PhysicalConstant{name,T,D,U}) where {name,T,D,U} = name

# Functions composing the building blocks of the macros

function _constant_preamble(name, sym, unit, def)
    ename = esc(name)
    qname = esc(Expr(:quote, name))
    esym = esc(sym)
    qsym = esc(Expr(:quote, sym))
    eunit = esc(unit)
    _bigconvert = isa(def,Symbol) ? quote
        function _big(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
            c = BigFloat()
            ccall(($(string("mpfr_const_", def)), :libmpfr),
                  Cint, (Ref{BigFloat}, Int32), c, MPFR.ROUNDING_MODE[])
            return c
        end
    end : quote
        _big(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = $(esc(def))
    end
    return ename, qname, esym, qsym, eunit, _bigconvert
end

function _constant_begin(qname, ename, esym, eunit, val, _bigconvert)
    quote
        const $ename = PhysicalConstant{gensym($qname),Float64,dimension($eunit),typeof($eunit)}()
        export $ename
        const $esym = $ename

        Base.float(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = $val * $eunit
        Base.float(FT::DataType, ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
            FT($val) * $eunit
        $_bigconvert
        Base.big(x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = _big(x) * $eunit
        Base.float(::Type{BigFloat}, x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = big(x)
    end
end

function _constant_end(qname, ename, qsym, descr, val, reference, eunit)
    quote
        Measurements.measurement(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
            measurement(Float64, $ename)

        Unitful.unit(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}      = $eunit
        Unitful.dimension(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = D

        function Base.show(io::IO, x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
            unc = uncertainty(ustrip(measurement($ename)))
            println(io, $descr, " (", $qsym, ")")
            println(io, "Value                         = ", float($ename))
            println(io, "Standard uncertainty          = ",
                    iszero(unc) ? "(exact)" : unc * $eunit)
            println(io, "Relative standard uncertainty = ",
                    iszero(unc) ? "(exact)" : round(unc / $val, sigdigits=2))
            print(io,   "Reference                     = ", $reference)
        end

        @assert isa(ustrip(float($ename)), Float64)
        @assert isa(ustrip(big($ename)), BigFloat)
        @assert isa(ustrip(measurement($ename)), Measurement{Float64})
        @assert isa(ustrip(measurement(Float32, $ename)), Measurement{Float32})
        @assert ustrip(float(Float64, $ename)) == Float64(ustrip(big($ename)))
        @assert ustrip(float(Float32, $ename)) == Float32(ustrip(big($ename)))
        @assert isapprox(Float64(value(ustrip(measurement(BigFloat, $ename)))),
                         value(ustrip(measurement($ename))), rtol = 1e-15)
        @assert Float64(uncertainty(ustrip(measurement(BigFloat, $ename)))) ==
            uncertainty(ustrip(measurement($ename)))
        @assert ustrip(big($ename)) == value(ustrip(measurement(BigFloat, $ename)))
    end
end

# Currently AbstractQuantity defines some operations in terms of the inner field `val`.

function Base.getproperty(c::PhysicalConstant{s,T,D,U}, sym::Symbol) where {s,T,D,U}
    if sym === :val
        return ustrip(float(T, c))
    else # fallback to getfield
        return getfield(c, sym)
    end
end

# @constant and @derived_constant macros

macro constant(name, sym, descr, val, def, unit, unc, bigunc, reference)
    ename, qname, esym, qsym, eunit, _bigconvert = _constant_preamble(name, sym, unit, def)
    tag = Measurements.tag_counters[Base.Threads.threadid()] += 1
    quote
       $(_constant_begin(qname, ename, esym, eunit, val, _bigconvert))

        function Measurements.measurement(FT::DataType,
                                          ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
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
        function Measurements.measurement(::Type{BigFloat},
                                          x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
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

        $(_constant_end(qname, ename, qsym, esc(descr), val, reference, eunit))
    end
end

macro derived_constant(name, sym, descr, val, def, unit, measure64, measurebig, reference)
    ename, qname, esym, qsym, eunit, _bigconvert = _constant_preamble(name, sym, unit, def)
    quote
        $(_constant_begin(qname, ename, esym, eunit, val, _bigconvert))

        Measurements.measurement(::Type{Float64},
                                 ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     $(esc(measure64))
        Measurements.measurement(::Type{BigFloat},
                                 ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     $(esc(measurebig))
        Measurements.measurement(FT::DataType,
                                 x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     convert(Measurement{FT}, ustrip(measurement(x))) * $eunit

        $(_constant_end(qname, ename, qsym, esc(descr), val, reference, eunit))
    end
end

"""
    float(::PhysicalConstant{name,T,D,U}) where {T,D,U}
    float(FloatType, ::PhysicalConstant{name,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with the floating type optionally specified by
`FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2014: G

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
float(::PhysicalConstant)

"""
    measurement(::PhysicalConstant{name,T,D,U}) where {T,D,U}
    measurement(FloatType, ::PhysicalConstant{name,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with standard uncertainty.  The floating-point
precision can be optionally specified with the `FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2014, Measurements

julia> import PhysicalConstants.CODATA2014: h

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
measurement(::PhysicalConstant)

include("promotion.jl")
include("codata2014.jl")
include("codata2018.jl")

end # module
