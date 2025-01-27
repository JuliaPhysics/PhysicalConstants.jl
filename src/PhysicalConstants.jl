module PhysicalConstants

using Measurements, Unitful

import Measurements: value, uncertainty
import Unitful: AbstractQuantity

# The type

"""
    PhysicalConstant{name,T,D,U} <: AbstractQuantity{T,D,U}

A type representing a physical constant, with units and -- optionally -- with
error as standard deviation.

Each type is a singleton and is parametrised by

* `name`: a `Symbol` representing its name
* `T`: the numerical type of the constant, e.g. `Float64`
* `D`: the physical dimension, from [`Unitful.jl`](https://painterqubits.github.io/Unitful.jl/stable/)
* `U`: the physical unit, from [`Unitful.jl`](https://painterqubits.github.io/Unitful.jl/stable/)

See [`@constant`](@ref) and [`@derived_constant`](@ref) for how to define a new
physical constant.
"""
struct PhysicalConstant{name,T,D,U} <: AbstractQuantity{T,D,U} end

_name(::PhysicalConstant{name,T,D,U}) where {name,T,D,U} = name

# Functions composing the building blocks of the macros

function _constant_preamble(name, sym, unit, val, def)
    ename = esc(name)
    qname = esc(Expr(:quote, name))
    esym = esc(sym)
    qsym = esc(Expr(:quote, sym))
    eunit = esc(unit)
    e_val = esc(val)
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
    return ename, qname, esym, qsym, eunit, e_val, _bigconvert
end

function _constant_begin(qname, ename, esym, eunit, e_val, _bigconvert)
    quote
        const $ename = PhysicalConstant{gensym($qname),Float64,dimension($eunit),typeof($eunit)}()
        export $ename
        const $esym = $ename

        Base.float(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = $e_val * $eunit
        Base.float(FT::DataType, ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
            FT($e_val) * $eunit
        $_bigconvert
        Base.big(x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = _big(x) * $eunit
        Base.float(::Type{BigFloat}, x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = big(x)
    end
end

function _constant_end(qname, ename, qsym, edescr, e_val, ereference, eunit)
    quote
        Measurements.measurement(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
            measurement(Float64, $ename)

        Unitful.unit(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}      = $eunit
        Unitful.dimension(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = D

        PhysicalConstants.reference(::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} = $ereference

        function Base.show(io::IO, ::MIME"text/plain", x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
            unc = uncertainty(ustrip(measurement($ename)))
            println(io, $edescr, " (", $qsym, ")")
            println(io, "Value                         = ", float($ename))
            println(io, "Standard uncertainty          = ",
                    iszero(unc) ? "(exact)" : unc * $eunit)
            println(io, "Relative standard uncertainty = ",
                    iszero(unc) ? "(exact)" : round(unc / $e_val, sigdigits=2))
            print(io,   "Reference                     = ", reference($ename))
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

"""
    @constant(name, sym, descr, val, def, unit, unc, bigunc, reference) -> PhysicalConstant

Macro to define a new [`PhysicalConstant`](@ref).

The arguments are:

* `name`: a symbol with the long name of the constant.  This symbol is automatically eported
* `sym`: a non-exported alias for the constant
* `descr`: a description of the constant
* `val`: the numerical `Float64` value of the constant, in the reference units
* `def`:  the expression to use to compute the constant in any precision, in the reference units
* `unit`: the reference units
* `unc`: the numerical `Float64` value of the uncertainty, in the reference units
* `bigunc`: the expression to use to compute the uncertainty in any precision, in the reference units
* `reference`: the name of the reference document that defines the constant

```jldoctest
julia> using PhysicalConstants, Unitful

julia> PhysicalConstants.@constant(MyConstant, mc, "A custom constant",
           12.34, BigFloat(1234) / BigFloat(100), u"m/s",
           0.56, BigFloat(56) / BigFloat(100), "My lab notebook")

julia> MyConstant
A custom constant (mc)
Value                         = 12.34 m s^-1
Standard uncertainty          = 0.56 m s^-1
Relative standard uncertainty = 0.045
Reference                     = My lab notebook
```
"""
macro constant(name, sym, descr, val, def, unit, unc, bigunc, reference)
    ename, qname, esym, qsym, eunit, e_val, _bigconvert = _constant_preamble(name, sym, unit, val, def)
    eunc = esc(unc)
    ebigunc = esc(bigunc)
    tag = Threads.atomic_add!(Measurements.tag_counter, UInt64(1))
    quote
       $(_constant_begin(qname, ename, esym, eunit, e_val, _bigconvert))

        function Measurements.measurement(FT::DataType,
                                          ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
            vl = FT($e_val)
            newder = Measurements.empty_der2(vl)
            if iszero($eunc)
                return Measurement{FT}(vl, FT($eunc), UInt64(0), newder) * $eunit
            else
                return Measurement{FT}(vl, FT($eunc), $tag,
                                       Measurements.Derivatives(newder,
                                                                (vl, $eunc, $tag)=>one(FT))) * $eunit
            end
        end
        function Measurements.measurement(::Type{BigFloat},
                                          x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U}
            vl = _big(x)
            unc = BigFloat($ebigunc)
            newder = Measurements.empty_der2(vl)
            if iszero($eunc)
                return Measurement{BigFloat}(vl, unc, UInt64(0), newder) * $eunit
            else
                return Measurement{BigFloat}(vl, unc, $tag,
                                             Measurements.Derivatives(newder,
                                                                      (vl, unc, $tag)=>one(BigFloat))) * $eunit
            end
        end

        $(_constant_end(qname, ename, qsym, esc(descr), e_val, esc(reference), eunit))
    end
end

"""
    @derived_constant(name, sym, descr, val, def, unit, measure64, measurebig, reference) -> PhysicalConstant

Macro to define a new [`PhysicalConstant`](@ref) derived from another existing `PhysicalConstant`.

The arguments are:

* `name`: a symbol with the long name of the constant.  This symbol is automatically eported
* `sym`: a non-exported alias for the constant
* `descr`: a description of the constant
* `val`: the numerical `Float64` value of the constant, in the reference units
* `def`:  the expression to use to compute the constant in any precision, in the reference units
* `unit`: the reference units
* `measure64`: the numerical `Measurement{Float64}` value of the constant, in the reference units
* `measurebig`: the expression to use to compute the comstamt as a `Measurement{BigFloat}`, in the reference units
* `reference`: the name of the reference document that defines the constant

```jldoctest
julia> using PhysicalConstants, Unitful, Measurements

julia> PhysicalConstants.@constant(MyConstant, mc, "A custom constant",
           12.34, BigFloat(1234) / BigFloat(100), u"m/s",
           0.56, BigFloat(56) / BigFloat(100), "My lab notebook")

julia> MyConstant
A custom constant (mc)
Value                         = 12.34 m s^-1
Standard uncertainty          = 0.56 m s^-1
Relative standard uncertainty = 0.045
Reference                     = My lab notebook

julia> PhysicalConstants.@derived_constant(MyDerivedConstant, mdc, "A custom derived constant",
           96.252, ustrip(big(mc)) * BigFloat(78) / BigFloat(10), u"m/s",
           measurement(mc) * 7.8, measurement(BigFloat, mc)  * BigFloat(78) / BigFloat(10),
           "My lab notebook")

julia> MyDerivedConstant
A custom derived constant (mdc)
Value                         = 96.252 m s^-1
Standard uncertainty          = 4.368 m s^-1
Relative standard uncertainty = 0.045
Reference                     = My lab notebook
```
"""
macro derived_constant(name, sym, descr, val, def, unit, measure64, measurebig, reference)
    ename, qname, esym, qsym, eunit, e_val, _bigconvert = _constant_preamble(name, sym, unit, val, def)
    quote
        $(_constant_begin(qname, ename, esym, eunit, e_val, _bigconvert))

        Measurements.measurement(::Type{Float64},
                                 ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     $(esc(measure64))
        Measurements.measurement(::Type{BigFloat},
                                 ::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     $(esc(measurebig))
        Measurements.measurement(FT::DataType,
                                 x::PhysicalConstant{_name($ename),T,D,U}) where {T,D,U} =
                                     convert(Measurement{FT}, ustrip(measurement(x))) * $eunit

        $(_constant_end(qname, ename, qsym, esc(descr), e_val, esc(reference), eunit))
    end
end

"""
    float(::PhysicalConstant{name,T,D,U}) where {T,D,U}
    float(FloatType, ::PhysicalConstant{name,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with the floating type optionally specified by
`FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2022: G

julia> G
Newtonian constant of gravitation (G)
Value                         = 6.6743e-11 m^3 kg^-1 s^-2
Standard uncertainty          = 1.5e-15 m^3 kg^-1 s^-2
Relative standard uncertainty = 2.2e-5
Reference                     = CODATA 2022

julia> float(G)
6.6743e-11 m^3 kg^-1 s^-2

julia> float(Float32, G)
6.6743f-11 m^3 kg^-1 s^-2
```
"""
float(::PhysicalConstant)

"""
    measurement(::PhysicalConstant{name,T,D,U}) where {T,D,U}
    measurement(FloatType, ::PhysicalConstant{name,T,D,U}) where {T,D,U}

Return the physical constant as a `Quantity` with standard uncertainty.  The floating-point
precision can be optionally specified with the `FloatType`, `Float64` by default.

```jldoctest
julia> using PhysicalConstants.CODATA2022, Measurements

julia> import PhysicalConstants.CODATA2022: μ_0

julia> μ_0
Vacuum magnetic permeability (μ_0)
Value                         = 1.25663706127e-6 N A^-2
Standard uncertainty          = 2.0e-16 N A^-2
Relative standard uncertainty = 1.6e-10
Reference                     = CODATA 2022

julia> measurement(μ_0)
1.25663706127e-6 ± 2.0e-16 N A^-2

julia> measurement(Float32, μ_0)
1.256637e-6 ± 2.0e-16 N A^-2
```
"""
measurement(::PhysicalConstant)

"""
    reference(::PhysicalConstant{name,T,D,U}) where {T,D,U}

Return the reference defined for the physical constant.

```jldoctest
julia> using PhysicalConstants

julia> using PhysicalConstants.CODATA2022: h

julia> h
Planck constant (h)
Value                         = 6.62607015e-34 J s
Standard uncertainty          = (exact)
Relative standard uncertainty = (exact)
Reference                     = CODATA 2022

julia> PhysicalConstants.reference(h)
"CODATA 2022"
```
"""
function reference end

include("promotion.jl")
include("codata2014.jl")
include("codata2018.jl")
include("codata2022.jl")

end # module
