module Constants

using Measurements, Unitful

export @constant

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

        @assert isa(float($esym).val, Float64)
        @assert isa(big($esym).val, BigFloat)
        @assert isa(measurement($esym).val, Measurement{Float64})
        @assert float(Float64, $esym).val == Float64(big($esym).val)
        @assert float(Float32, $esym).val == Float32(big($esym).val)
    end
end

function Base.show(io::IO, x::Constant)
    println(io, "Name        = ", name(x))
    println(io, "Value       = ", float(x).val)
    println(io, "Uncertainty = ", measurement(x).val.err)
    println(io, "Unit        = ", unit(x))
    print(io,   "Reference   = ", ref(x))
end

module CODATA2014

using Constants, Unitful

export c, h

@constant(c, "Speed of light in vacuum", 299_792_458.0, BigFloat(299_792_458.0), u"m/s",
          0.0, BigFloat(0), "CODATA 2014")
@constant(h, "Planck constant", 6.626_070_040e-34,
          6_626_070_040/10000000000000000000000000000000000000000000,
          u"J*s", 8.1e-42, 81/10000000000000000000000000000000000000000000,
          "CODATA 2014")

end

end # module
