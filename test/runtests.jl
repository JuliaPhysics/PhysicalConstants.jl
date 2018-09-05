using Constants
using Test

using Constants.CODATA2014

@testset begin
    @test big(h).val == big"6.626070040e-34"
    @test setprecision(BigFloat, 768) do; precision(big(c).val) end == 768
    @test measurement(h) === measurement(h)
    @test iszero(measurement(h) - measurement(h))
    @test isone(measurement(BigFloat, c) / measurement(BigFloat, c))
end
