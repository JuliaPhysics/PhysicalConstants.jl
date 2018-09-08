using Constants, Measurements, Unitful
using Test

using Constants.CODATA2014

@testset begin
    @test ustrip(big(h)) == big"6.626070040e-34"
    @test setprecision(BigFloat, 768) do; precision(ustrip(big(c))) end == 768
    @test measurement(h) === measurement(h)
    @test iszero(measurement(α) - measurement(α))
    @test isone(measurement(BigFloat, atm) / measurement(BigFloat, atm))
    @test iszero(measurement(BigFloat, ħ) - (measurement(BigFloat, h) / 2big(pi)))
    @test isone(measurement(BigFloat, ħ) / (measurement(BigFloat, h) / 2big(pi)))
end
