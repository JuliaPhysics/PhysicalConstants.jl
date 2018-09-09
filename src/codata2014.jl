module CODATA2014

using PhysicalConstants, Unitful, Measurements

import PhysicalConstants: @constant, @derived_constant

@constant(α, "Fine-structure constant", 7.297_352_5664e-3,
          BigFloat(72_973_525_664)/BigFloat(10_000_000_000_000), Unitful.NoUnits,
          1.7e-12, BigFloat(17)/BigFloat(10_000_000_000_000), "CODATA 2014")
@constant(a_0, "Bohr radius", 0.529_177_210_67e-10,
          BigFloat(52_917_721_067)/BigFloat(1_000_000_000_000_000_000_000), u"m",
          1.2e-20, BigFloat(12)/BigFloat(1_000_000_000_000_000_000_000), "CODATA 2014")
@constant(atm, "Standard atmosphere", 101_325.0, BigFloat(101_325), u"Pa",
          0.0, BigFloat(0), "CODATA 2014")
@constant(b, "Wien wavelength displacement law constant", 2.897_7729e-3,
          BigFloat(28_977_729)/BigFloat(10_000_000_000), u"m * K",
          1.7e-9, BigFloat(17)/BigFloat(10_000_000_000), "CODATA 2014")
@constant(c, "Speed of light in vacuum", 299_792_458.0, BigFloat(299_792_458.0), u"m/s",
          0.0, BigFloat(0), "CODATA 2014")
@constant(µ_0, "Magnetic constant", 1.2566370614359173e-6, 4*big(pi)/BigFloat(10_000_000),
          u"N * A^-2", 0.0, BigFloat(0.0), "CODATA 2014")
@constant(ε_0, "Electric constant", 8.854187817620389e-12,
          inv(ustrip(big(µ_0)) * ustrip(big(c))^2), u"F * m^-1",
          0.0, BigFloat(0.0), "CODATA 2014")
@constant(e, "Elementary charge", 1.602_176_6208e-19,
          big(16_021_766_208)/100_000_000_000_000_000_000_000_000_000,
          u"C", 9.8e-28, big(98)/100_000_000_000_000_000_000_000_000_000, "CODATA 2014")
@constant(G, "Newtonian constant of gravitation", 6.674_08e-11,
          big(667_408)/big(10_000_000_000_000_000), u"m^3 * kg^-1 * s^-2",
          3.1e-15, big(31)/big(10_000_000_000_000_000), "CODATA 2014")
@constant(g_n, "Standard acceleration of gravitation", 9.806_65, big(980_665)/big(100_000),
          u"m * s^-2", 0, 0, "CODATA 2014")
@constant(h, "Planck constant", 6.626_070_040e-34,
          6_626_070_040/10_000_000_000_000_000_000_000_000_000_000_000_000_000_000,
          u"J*s", 8.1e-42, 81/10_000_000_000_000_000_000_000_000_000_000_000_000_000_000,
          "CODATA 2014")
@derived_constant(ħ, "Planck constant over 2pi", 1.0545718001391127e-34,
                  ustrip(big(h))/(2 * big(pi)), u"J*s", measurement(h)/2pi,
                  measurement(BigFloat, h)/(2 * big(pi)), "CODATA 2014")
@constant(k_B, "Boltzmann constant", 1.380_648_52e-23,
          BigFloat(138_064_852)/BigFloat(10_000_000_000_000_000_000_000_000_000_000), u"J * K^-1",
          7.9e-30, BigFloat(79)/BigFloat(10_000_000_000_000_000_000_000_000_000_000), "CODATA 2014")
@constant(µ_B, "Bohr magneton", 927.400_9994e-26,
          BigFloat(9274_009_994)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000),
          u"J * T^-1", 5.7e-32,
          BigFloat(57)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000), "CODATA 2014")
@constant(m_e, "Electron mass", 9.109_383_56e-31,
          BigFloat(910_938_356)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          u"kg", 1.1e-38,
          BigFloat(11)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2014")
@constant(m_n, "Neutron mass", 1.674_927_471e-27,
          BigFloat(1674_927_471)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          u"kg", 2.1e-35,
          BigFloat(21)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2014")
@constant(m_p, "Protron mass", 1.672_621_898e-27,
          BigFloat(1672_621_898)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          u"kg", 2.1e-35,
          BigFloat(21)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2014")
@constant(m_u, "Atomic mass constant", 1.660_539_040e-27,
          BigFloat(1660_539_040)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          u"kg", 2.0e-35,
          BigFloat(20)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2014")
@constant(N_A, "Avogadro constant", 6.022_140_857e23,
          BigFloat(602_214_085_700_000_000_000_000), u"mol^-1",
          7.4e15, BigFloat(7_400_000_000_000_000), "CODATA 2014")
@constant(R, "Molar gas constant", 8.314_4598, BigFloat(8_314_4598)/BigFloat(10_000_000),
          u"J * mol^-1 * K^-1", 4.8e-6, BigFloat(48)/BigFloat(10_000_000), "CODATA 2014")
@constant(R_∞, "Rydberg constant", 10_973_731.568_508,
          BigFloat(10_973_731_568_508)/BigFloat(1_000_000), u"m^-1",
          6.5e-5, BigFloat(65)/BigFloat(1_000_000), "CODATA 2014")
@constant(σ, "Stefan-Boltzmann constant", 5.670_367e-8,
          BigFloat(5670_367)/BigFloat(100_000_000_000_000), u"m^2",
          1.3e-13, BigFloat(13)/BigFloat(100_000_000_000_000), "CODATA 2014")
@constant(σ_e, "Thomson cross section", 0.665_245_871_58e-28,
          BigFloat(66_524_587_158)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          u"m^2", 9.1e-38,
          BigFloat(91)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2014")
@constant(Z_0, "Characteristic impedance of vacuum", 376.73031346177066,
          BigFloat(1199_169_832)/BigFloat(10_000_000) * big(pi), u"Ω",
          0, BigFloat(0.0), "CODATA 2014")

end
