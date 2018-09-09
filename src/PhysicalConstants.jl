module Constants

using Measurements, Unitful

import Measurements: value, uncertainty

struct Constant{sym} <: Number end

function name end
function ref end

macro constant(sym, name, val, def, unit, unc, bigunc, reference)
    esym = esc(sym)
    qsym = esc(Expr(:quote, sym))
    eunit = esc(unit)
    tag = Measurements.tag_counters[Base.Threads.threadid()] += 1
    _bigconvert = isa(def,Symbol) ? quote
        function _big(::Constant{$qsym})
            c = BigFloat()
            ccall(($(string("mpfr_const_", def)), :libmpfr),
                  Cint, (Ref{BigFloat}, Int32), c, MPFR.ROUNDING_MODE[])
            return c
        end
    end : quote
        _big(::Constant{$qsym}) = $(esc(def))
    end
    quote
        const $esym = Constant{$qsym}()
        export $esym
        Base.float(::Constant{$qsym}) = $val * $unit
        Base.float(FT::DataType, ::Constant{$qsym}) = FT($val) * $eunit
        $_bigconvert
        Base.big(x::Constant{$qsym}) = _big(x) * $eunit
        Base.float(::Type{BigFloat}, x::Constant{$qsym}) = big(x)

        function Measurements.measurement(FT::DataType, ::Constant{$qsym})
            vl = FT($val)
            newder = Measurements.empty_der2(vl)
            if iszero($unc)
                return Measurement{FT}(vl, FT($unc), UInt64(0), newder) * $unit
            else
                return Measurement{FT}(vl, FT($unc), $tag,
                                       Measurements.Derivatives(newder,
                                                                (vl, $unc, $tag)=>one(FT))) * $unit
            end
        end
        function Measurements.measurement(::Type{BigFloat}, x::Constant{$qsym})
            vl = _big(x)
            unc = BigFloat($bigunc)
            newder = Measurements.empty_der2(vl)
            if iszero($unc)
                return Measurement{BigFloat}(vl, unc, UInt64(0), newder) * $unit
            else
                return Measurement{BigFloat}(vl, unc, $tag,
                                             Measurements.Derivatives(newder,
                                                                      (vl, unc, $tag)=>one(BigFloat))) * $unit
            end
        end
        Measurements.measurement(::Constant{$qsym}) = measurement(Float64, $esym)

        Constants.name(::Constant{$qsym})    = $name
        Constants.ref(::Constant{$qsym})     = $reference
        Unitful.unit(::Constant{$qsym})      = $unit
        Unitful.dimension(::Constant{$qsym}) = Unitful.dimension($unit)

        @assert isa(ustrip(float($esym)), Float64)
        @assert isa(ustrip(big($esym)), BigFloat)
        @assert isa(ustrip(measurement($esym)), Measurement{Float64})
        @assert ustrip(float(Float64, $esym)) == Float64(ustrip(big($esym)))
        @assert ustrip(float(Float32, $esym)) == Float32(ustrip(big($esym)))
        @assert Float64(value(ustrip(measurement(BigFloat, $esym)))) ==
            value(ustrip(measurement($esym)))
        @assert Float64(uncertainty(ustrip(measurement(BigFloat, $esym)))) ==
            uncertainty(ustrip(measurement($esym)))
    end
end

macro derived_constant(sym, name, val, def, unit, measure64, measurebig, reference)
    esym = esc(sym)
    qsym = esc(Expr(:quote, sym))
    eunit = esc(unit)
    tag = Measurements.tag_counters[Base.Threads.threadid()] += 1
    _bigconvert = isa(def,Symbol) ? quote
        function _big(::Constant{$qsym})
            c = BigFloat()
            ccall(($(string("mpfr_const_", def)), :libmpfr),
                  Cint, (Ref{BigFloat}, Int32), c, MPFR.ROUNDING_MODE[])
            return c
        end
    end : quote
        _big(::Constant{$qsym}) = $(esc(def))
    end
    quote
        const $esym = Constant{$qsym}()
        export $esym
        Base.float(::Constant{$qsym}) = $val * $unit
        Base.float(FT::DataType, ::Constant{$qsym}) = FT($val) * $eunit
        $_bigconvert
        Base.big(x::Constant{$qsym}) = _big(x) * $eunit
        Base.float(::Type{BigFloat}, x::Constant{$qsym}) = big(x)

        Measurements.measurement(::Type{Float64}, ::Constant{$qsym}) = $(esc(measure64))
        Measurements.measurement(::Type{BigFloat}, ::Constant{$qsym}) = $(esc(measurebig))
        Measurements.measurement(FT::DataType, x::Constant{$qsym}) =
            convert(Measurement{FT}, ustrip(measurement(x))) * $eunit
        Measurements.measurement(::Constant{$qsym}) = measurement(Float64, $esym)

        Constants.name(::Constant{$qsym})    = $name
        Constants.ref(::Constant{$qsym})     = $reference
        Unitful.unit(::Constant{$qsym})      = $unit
        Unitful.dimension(::Constant{$qsym}) = Unitful.dimension($unit)

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

function Base.show(io::IO, x::Constant{sym}) where sym
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
    float(::Constant{symbol})
    float(FloatType, ::Constant{symbol})

Return the physical constant as a `Quantity` with the floating type optionally specified by
`FloatType`, `Float64` by default.

```jldoctest
julia> using Constants.CODATA2014

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
    measurement(::Constant{symbol})
    measurement(FloatType, ::Constant{symbol})

Return the physical constant as a `Quantity` with standard uncertainty.  The floating-point
precision can be optionally specified with the `FloatType`, `Float64` by default.

```jldoctest
julia> using Constants.CODATA2014, Measurements

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

include("codata2014.jl")

end # module
