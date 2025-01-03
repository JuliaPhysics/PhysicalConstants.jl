module CODATA2022

using PhysicalConstants, Measurements, Unitful, Roots

import Unitful: Ω, A, C, F, Hz, J, kg, K, m, mol, N, Pa, s, T, W
import PhysicalConstants: @constant, @derived_constant

## Helper functions for the Wien displacement law constants
_λf(x) = (x - 5) * exp(x) + 5
_Dλf(x) = (x - 4) * exp(x)
const _λx0 = 4.965114231744276
_λx(T) = find_zero((_λf, _Dλf), T(_λx0), Roots.Newton())

_νf(x) = (x - 3) * exp(x) + 3
_Dνf(x) = (x - 2) * exp(x)
const _νx0 = 2.8214393721220787
_νx(T) = find_zero((_νf, _Dνf), T(_νx0), Roots.Newton())
## end

@constant(FineStructureConstant, α, "Fine-structure constant", 7.297_352_564_3e-3,
          BigFloat(7_297_352_564_3)/BigFloat(10_000_000_000_000), Unitful.NoUnits,
          1.1e-12, BigFloat(11)/BigFloat(10_000_000_000_000), "CODATA 2022")
@constant(BohrRadius, a_0, "Bohr radius", 5.291_772_105_44e-11,
          BigFloat(5_291_772_105_44)/BigFloat(10_000_000_000_000_000_000_000), m,
          8.2e-21, BigFloat(82)/BigFloat(10_000_000_000_000_000_000_000), "CODATA 2022")
@constant(StandardAtmosphere, atm, "Standard atmosphere", 101_325.0, BigFloat(101_325), Pa,
          0.0, BigFloat(0), "CODATA 2022")
@constant(SpeedOfLightInVacuum, c_0, "Speed of light in vacuum", 299_792_458.0,
          BigFloat(299_792_458.0), m / s, 0.0, BigFloat(0), "CODATA 2022")
@constant(VacuumMagneticPermeability, µ_0, "Vacuum magnetic permeability", 1.256_637_061_27e-6,
          BigFloat(1_256_637_061_27)/BigFloat(100_000_000_000_000_000), N * A^-2, 2.0e-16,
          BigFloat(20)/BigFloat(100_000_000_000_000_000), "CODATA 2022")
@constant(VacuumElectricPermittivity, ε_0, "Vacuum electric permittivity", 8.854_187_818_8e-12,
          BigFloat(8_854_187_818_8)/BigFloat(10_000_000_000_000_000_000_000), F * m^-1,
          1.4e-21, BigFloat(14)/BigFloat(10_000_000_000_000_000_000_000), "CODATA 2022")
@constant(ElementaryCharge, e, "Elementary charge", 1.602_176_634e-19,
          BigFloat(1_602_176_634)/BigFloat(10_000_000_000_000_000_000_000_000_000),
          C, 0.0, BigFloat(0.0), "CODATA 2022")
@constant(NewtonianConstantOfGravitation, G, "Newtonian constant of gravitation",
          6.674_30e-11, BigFloat(6_674_30)/BigFloat(10_000_000_000_000_000), m^3 * kg^-1 * s^-2,
          1.5e-15, BigFloat(15)/BigFloat(10_000_000_000_000_000), "CODATA 2022")
@constant(StandardAccelerationOfGravitation, g_n, "Standard acceleration of gravitation",
          9.806_65, BigFloat(9_806_65)/BigFloat(100_000), m * s^-2, 0, 0, "CODATA 2022")
@constant(PlanckConstant, h, "Planck constant", 6.626_070_15e-34,
          BigFloat(6_626_070_15)/BigFloat(1_000_000_000_000_000_000_000_000_000_000_000_000_000_000),
          J * s, 0.0, BigFloat(0.0), "CODATA 2022")
@derived_constant(ReducedPlanckConstant, ħ, "Reduced Planck constant",
                  convert(Float64, ustrip(big(h))/(2 * big(pi))),
                  ustrip(big(h))/(2 * big(pi)), J * s,
                  measurement(h)/2pi, measurement(BigFloat, h)/(2 * big(pi)), "CODATA 2022")
@constant(BoltzmannConstant, k_B, "Boltzmann constant", 1.380_649e-23,
          BigFloat(1_380_649)/BigFloat(100_000_000_000_000_000_000_000_000_000), J * K^-1,
          0.0, BigFloat(0.0), "CODATA 2022")
@constant(BohrMagneton, µ_B, "Bohr magneton", 9.274_010_0657e-24,
          BigFloat(9_274_010_065_7)/BigFloat(10_000_000_000_000_000_000_000_000_000_000_000),
          J * T^-1, 2.9e-33,
          BigFloat(29)/BigFloat(100_00_000_000_000_000_000_000_000_000_000_000), "CODATA 2022")
@constant(ElectronMass, m_e, "Electron mass", 9.109_383_713_9e-31,
          BigFloat(9_109_383_713_9)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000_000),
          kg, 2.8e-40,
          BigFloat(28)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2022")
@constant(NeutronMass, m_n, "Neutron mass", 1.674_927_500_56e-27,
          BigFloat(1_674_927_500_56)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          kg, 8.5e-37,
          BigFloat(85)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2022")
@constant(ProtonMass, m_p, "Proton mass", 1.672_621_925_95e-27,
          BigFloat(1_672_621_925_95)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          kg, 5.2e-37,
          BigFloat(52)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2022")
@constant(AtomicMassConstant, m_u, "Atomic mass constant", 1.660_539_068_92e-27,
          BigFloat(1_660_539_068_92)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          kg, 5.2e-37,
          BigFloat(52)/BigFloat(100_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2022")
@constant(AvogadroConstant, N_A, "Avogadro constant", 6.022_140_76e23,
          BigFloat(6_022_140_760_000_000_000_000_00), mol^-1,
          0.0, BigFloat(0.0), "CODATA 2022")
@derived_constant(MolarGasConstant, R, "Molar gas constant",
                  convert(Float64, ustrip(big(N_A) * big(k_B))),
                  ustrip(big(N_A) * big(k_B)), J * mol^-1 * K^-1,
                  measurement(N_A) * measurement(k_B),
                  measurement(BigFloat, N_A) * measurement(BigFloat, k_B), "CODATA 2022")
@constant(RydbergConstant, R_∞, "Rydberg constant", 10_973_731.568_157,
          BigFloat(10_973_731_568_157)/BigFloat(1_000_000), m^-1,
          1.2e-5, BigFloat(12)/BigFloat(1_000_000), "CODATA 2022")
@derived_constant(StefanBoltzmannConstant, σ, "Stefan-Boltzmann constant",
                  convert(Float64, ustrip(2 * big(pi)^5 * big(k_B)^4 / (15 * big(h)^3 * big(c_0)^2))),
                  ustrip(2 * big(pi) ^ 5 * big(k_B) ^ 4 / (15 * big(h) ^ 3 * big(c_0) ^ 2)), W * m^-2 * K^-4,
                  (2 * pi ^ 5 * measurement(k_B) ^ 4) / (15 * measurement(h) ^ 3 * measurement(c_0) ^ 2),
                  (2 * big(pi) ^ 5 * measurement(BigFloat, k_B) ^ 4) / (15 * measurement(BigFloat, h) ^ 3 * measurement(BigFloat, c_0) ^ 2),
                  "CODATA 2022")
@constant(ThomsonCrossSection, σ_e, "Thomson cross section", 6.652_458_705_1e-29,
          BigFloat(6_652_458_705_1)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          m^2, 6.2e-38,
          BigFloat(62)/BigFloat(1000_000_000_000_000_000_000_000_000_000_000_000_000),
          "CODATA 2022")
@derived_constant(WienWavelengthDisplacementLawConstant, b, "Wien wavelength displacement law constant",
                  convert(Float64, ustrip(big(h) * big(c_0) / (_λx(BigFloat) * big(k_B)))),
                  ustrip(big(h) * big(c_0) / (_λx(BigFloat) * big(k_B))), m * K,
                  measurement(h) * measurement(c_0) / (_λx0 * measurement(k_B)),
                  measurement(BigFloat, h) * measurement(BigFloat, c_0) / (_λx(BigFloat) * measurement(BigFloat, k_B)),
                  "CODATA 2022")
@derived_constant(WienFrequencyDisplacementLawConstant, b′, "Wien frequency displacement law constant",
                  convert(Float64, ustrip(_νx(BigFloat) * big(k_B) / big(h))),
                  ustrip(_νx(BigFloat) * big(k_B) / big(h)), Hz / K,
                  _νx0 * measurement(k_B) / measurement(h),
                  _νx(BigFloat) * measurement(BigFloat, k_B) / measurement(BigFloat, h), "CODATA 2022")
@constant(CharacteristicImpedanceOfVacuum, Z_0, "Characteristic impedance of vacuum",
          376.730_313_412, BigFloat(376_730_313_412)/BigFloat(1_000_000_000), Ω, 5.9e-8,
          BigFloat(59) / BigFloat(1_000_000_000), "CODATA 2022")

end # module CODATA2022
