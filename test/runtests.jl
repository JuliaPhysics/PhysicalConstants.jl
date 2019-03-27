using PhysicalConstants.CODATA2014, Measurements, Unitful
using Test

@testset "Base" begin
    @test ustrip(big(h)) == big"6.626070040e-34"
    @test setprecision(BigFloat, 768) do; precision(ustrip(big(c))) end == 768
    @test measurement(h) === measurement(h)
    @test iszero(measurement(α) - measurement(α))
    @test isone(measurement(BigFloat, atm) / measurement(BigFloat, atm))
    @test iszero(measurement(BigFloat, ħ) - (measurement(BigFloat, h) / 2big(pi)))
    @test isone(measurement(BigFloat, ħ) / (measurement(BigFloat, h) / 2big(pi)))
end

@testset "Promotion" begin
    x = @inferred(inv(μ_0 * c ^ 2))
    T = promote_type(typeof(ε_0), typeof(x))
    u = u"A^2 * kg^-1 * m^-3 * s^4"
    @test promote_type(typeof(α), BigInt) === BigFloat
    @test promote_type(typeof(α), typeof(1u"m/cm")) === Float64
    @test T === Quantity{Float64, dimension(x), typeof(u)}
    @test convert(T, ε_0) === (ε_0 / unit(ε_0)) * u
    @test convert(Float32, α) === float(Float32, α)
    @test uconvert(u"cm/s", c) === uconvert(u"cm/s", float(c))
end

@testset "Maths" begin
    @test α ≈ @inferred(e^2/(4 * pi * ε_0 * ħ * c))
    @test @inferred(α + 2) ≈ 2 + float(α)
    @test @inferred(5 + α) ≈ float(α) + 5
    @test @inferred(α + 2.718) ≈ 2.718 + float(α)
    @test @inferred(-3.14 + α) ≈ float(α) - 3.14
    @test ε_0 ≈ @inferred(1 / (μ_0 * c ^ 2))
    @test @inferred(big(0) + α) == big(α)
    @test @inferred(α * 1.0) == float(α)
end

@testset "Show" begin
    @test repr(c) ==
        "Speed of light in vacuum (c)
Value                         = 2.99792458e8 m s^-1
Standard uncertainty          = (exact)
Relative standard uncertainty = (exact)
Reference                     = CODATA 2014"
    @test repr(α) ==
        "Fine-structure constant (α)
Value                         = 0.0072973525664
Standard uncertainty          = 1.7e-12
Relative standard uncertainty = 2.3e-10
Reference                     = CODATA 2014"
    @test repr(e) ==
        "Elementary charge (e)
Value                         = 1.6021766208e-19 C
Standard uncertainty          = 9.8e-28 C
Relative standard uncertainty = 6.1e-9
Reference                     = CODATA 2014"
end
