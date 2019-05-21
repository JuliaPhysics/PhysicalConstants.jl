# PhysicalConstants.jl

| **Build Status**                          | **Code Coverage**               |
|:-----------------------------------------:|:-------------------------------:|
| [![Build Status][travis-img]][travis-url] | [![][coveral-img]][coveral-url] |
| [![Build Status][appvey-img]][appvey-url] | [![][codecov-img]][codecov-url] |

Introduction
------------

`PhysicalConstants.jl` provides common physical constants.  They are defined as
instances of the new `Constant` type, which is subtype of `AbstractQuantity`
(from [`Unitful.jl`](https://github.com/ajkeller34/Unitful.jl) package) and can
also be turned into `Measurement` objects (from
[`Measurements.jl`](https://github.com/JuliaPhysics/Measurements.jl) package) at
request.

Constants are grouped into different submodules, so that the user can choose
different datasets as needed.  Currently, 2014 and 2018 editions of
[CODATA](https://physics.nist.gov/cuu/Constants/) recommended values of the
fundamental physical constants are provided.

Installation
------------

The latest version of `PhysicalConstants.jl` is available for Julia 1.0 and
later versions, and can be installed with [Julia built-in package
manager](https://julialang.github.io/Pkg.jl/stable/).  After entering the
package manager mode by pressing `]`, run the command

```julia
pkg> add PhysicalConstants
```

Usage
-----

You can load the package as usual with `using PhysicalConstants` but this module
does not provide anything useful for the end-users.  You most probably want to
directly load the submodule with the dataset you are interested in.  For
example, for CODATA 2018 load `PhysicalConstants.CODATA2018`:

```julia
julia> using PhysicalConstants.CODATA2018

julia> SpeedOfLightInVacuum
Speed of light in vacuum (c_0)
Value                         = 2.99792458e8 m s^-1
Standard uncertainty          = (exact)
Relative standard uncertainty = (exact)
Reference                     = CODATA 2018

julia> NewtonianConstantOfGravitation
Newtonian constant of gravitation (G)
Value                         = 6.6743e-11 m^3 kg^-1 s^-2
Standard uncertainty          = 1.5e-15 m^3 kg^-1 s^-2
Relative standard uncertainty = 2.2e-5
Reference                     = CODATA 2018
```

`SpeedOfLightInVacuum` and `NewtonianConstantOfGravitation` are two of the
`Constant`s defined in the `PhysicalConstants.CODATA2018` module, the full list
of available constants is given below.

`Constant`s can be readily used in mathematical operations, using by default
their `Float64` value:

```julia
julia> import PhysicalConstants.CODATA2018: c_0, ε_0, μ_0

julia> 2 * ε_0
1.77083756256e-11 F m^-1

julia> ε_0 - 1 / (μ_0 * c_0 ^ 2)
-3.8450973786644646e-25 A^2 s^4 kg^-1 m^-3
```

If you want to use a different precision for the value of the constant, use the
function `float(float_type, constant)`, for example:

```julia
julia> float(Float32, ε_0)
8.854188f-12 F m^-1

julia> float(BigFloat, ε_0)
8.854187812799999999999999999999999999999999999999999999999999999999999999999973e-12 F m^-1

julia> big(ε_0)
8.854187812799999999999999999999999999999999999999999999999999999999999999999973e-12 F m^-1

julia> big(ε_0) - inv(big(μ_0) * big(c_0)^2)
-3.849883307464075736533920296598236938395867709081184624499315166190408485179288e-25 A^2 s^4 kg^-1 m^-3
```

Note that `big(constant)` is an alias for `float(BigFloat, constant)`.

If in addition to units you also want the standard uncertainty associated with
the constant, use `measurement(x)`:

```julia
julia> using Measurements

julia> import PhysicalConstants.CODATA2018: h, ħ

julia> measurement(ħ)
1.0545718176461565e-34 ± 0.0 J s

julia> measurement(Float32, ħ)
1.0545718e-34 ± 0.0 J s

julia> measurement(BigFloat, ħ)
1.054571817646156391262428003302280744722826330020413122421923470598435912734741e-34 ± 0.0 J s

julia> measurement(BigFloat, ħ) / (measurement(BigFloat, h) / (2 * big(pi)))
1.0 ± 0.0
```

List of Set of Constants
------------------------

*Note*: each dataset listed below exports by default only the full long names of
the constants.  Short aliases are provided for convenience, but they are not
exported, to avoid polluting the main namespace with dozens of short-named
variables.  Users can to import the short names of the variables they use most
frequently, as shown in the examples above.

<!--
using PhysicalConstants.CODATA2014, Unitful

const constants = names(CODATA2014)
const others = setdiff(names(CODATA2014, all = true), constants)

println("| Long name | Short | Value | Unit |")
println("| --------- | ----- | ----- | ---- |")
for constant in constants
    c = getfield(CODATA2014, constant)
    if c isa PhysicalConstants.PhysicalConstant
        sym = others[findall(x -> c === getfield(CODATA2014, x), others)][1]
        println("| `", constant, "` | `", sym, "` | ", ustrip(float(c)), " | ",
                unit(c) == Unitful.NoUnits ? "" : "`$(unit(c))`", " |")
    end
end
-->

### `CODATA2014`

| Long name                               | Short | Value                  | Unit             |
| ---------                               | ----- | -----                  | ----             |
| `AtomicMassConstant`                    | `m_u` | 1.66053904e-27         | `kg`             |
| `AvogadroConstant`                      | `N_A` | 6.022140857e23         | `mol^-1`         |
| `BohrMagneton`                          | `μ_B` | 9.274009994e-24        | `J T^-1`         |
| `BohrRadius`                            | `a_0` | 5.2917721067e-11       | `m`              |
| `BoltzmannConstant`                     | `k_B` | 1.38064852e-23         | `J K^-1`         |
| `CharacteristicImpedanceOfVacuum`       | `Z_0` | 376.73031346177066     | `Ω`              |
| `ElectricConstant`                      | `ε_0` | 8.854187817620389e-12  | `F m^-1`         |
| `ElectronMass`                          | `m_e` | 9.10938356e-31         | `kg`             |
| `ElementaryCharge`                      | `e`   | 1.6021766208e-19       | `C`              |
| `FineStructureConstant`                 | `α`   | 0.0072973525664        |                  |
| `MagneticConstant`                      | `μ_0` | 1.2566370614359173e-6  | `N A^-2`         |
| `MolarGasConstant`                      | `R`   | 8.3144598              | `J K^-1 mol^-1`  |
| `NeutronMass`                           | `m_n` | 1.674927471e-27        | `kg`             |
| `NewtonianConstantOfGravitation`        | `G`   | 6.67408e-11            | `m^3 kg^-1 s^-2` |
| `PlanckConstant`                        | `h`   | 6.62607004e-34         | `J s`            |
| `PlanckConstantOver2pi`                 | `ħ`   | 1.0545718001391127e-34 | `J s`            |
| `ProtonMass`                            | `m_p` | 1.672621898e-27        | `kg`             |
| `RydbergConstant`                       | `R_∞` | 1.0973731568508e7      | `m^-1`           |
| `SpeedOfLightInVacuum`                  | `c_0` | 2.99792458e8           | `m s^-1`         |
| `StandardAccelerationOfGravitation`     | `g_n` | 9.80665                | `m s^-2`         |
| `StandardAtmosphere`                    | `atm` | 101325.0               | `Pa`             |
| `StefanBoltzmannConstant`               | `σ`   | 5.670367e-8            | `W K^-4 m^-2`    |
| `ThomsonCrossSection`                   | `σ_e` | 6.6524587158e-29       | `m^2`            |
| `WienWavelengthDisplacementLawConstant` | `b`   | 0.0028977729           | `K m`            |

### `CODATA2018`

| Long name                               | Short | Value                  | Unit             |
| ---------                               | ----- | -----                  | ----             |
| `AtomicMassConstant`                    | `m_u` | 1.6605390666e-27       | `kg`             |
| `AvogadroConstant`                      | `N_A` | 6.02214076e23          | `mol^-1`         |
| `BohrMagneton`                          | `μ_B` | 9.2740100783e-24       | `J T^-1`         |
| `BohrRadius`                            | `a_0` | 5.29177210903e-11      | `m`              |
| `BoltzmannConstant`                     | `k_B` | 1.380649e-23           | `J K^-1`         |
| `ElectronMass`                          | `m_e` | 9.1093837015e-31       | `kg`             |
| `ElementaryCharge`                      | `e`   | 1.602176634e-19        | `C`              |
| `FineStructureConstant`                 | `α`   | 0.0072973525693        |                  |
| `MolarGasConstant`                      | `R`   | 8.31446261815324       | `J K^-1 mol^-1`  |
| `NeutronMass`                           | `m_n` | 1.67492749804e-27      | `kg`             |
| `NewtonianConstantOfGravitation`        | `G`   | 6.6743e-11             | `m^3 kg^-1 s^-2` |
| `PlanckConstant`                        | `h`   | 6.62607015e-34         | `J s`            |
| `ProtonMass`                            | `m_p` | 1.67262192369e-27      | `kg`             |
| `ReducedPlanckConstant`                 | `ħ`   | 1.0545718176461565e-34 | `J s`            |
| `RydbergConstant`                       | `R_∞` | 1.097373156816e7       | `m^-1`           |
| `SpeedOfLightInVacuum`                  | `c_0` | 2.99792458e8           | `m s^-1`         |
| `StandardAccelerationOfGravitation`     | `g_n` | 9.80665                | `m s^-2`         |
| `StandardAtmosphere`                    | `atm` | 101325.0               | `Pa`             |
| `StefanBoltzmannConstant`               | `σ`   | 5.6703744191844294e-8  | `W K^-4 m^-2`    |
| `ThomsonCrossSection`                   | `σ_e` | 6.6524587321e-29       | `m^2`            |
| `VacuumElectricPermittivity`            | `ε_0` | 8.8541878128e-12       | `F m^-1`         |
| `VacuumMagneticPermeability`            | `μ_0` | 1.25663706212e-6       | `N A^-2`         |
| `WienFrequencyDisplacementLawConstant`  | `b′`  | 5.878925757646825e10   | `Hz K^-1`        |
| `WienWavelengthDisplacementLawConstant` | `b`   | 0.0028977719551851727  | `K m`            |

License
-------

The `PhysicalConstants.jl` package is licensed under the MIT "Expat" License.
The original author is [Mosè Giordano](https://github.com/giordano/).


[travis-img]: https://travis-ci.org/JuliaPhysics/PhysicalConstants.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaPhysics/PhysicalConstants.jl

[appvey-img]: https://ci.appveyor.com/api/projects/status/ct2nx2t38hok2vy0?svg=true
[appvey-url]: https://ci.appveyor.com/project/giordano/constants-jl

[coveral-img]: https://coveralls.io/repos/github/JuliaPhysics/PhysicalConstants.jl/badge.svg?branch=master
[coveral-url]: https://coveralls.io/github/JuliaPhysics/PhysicalConstants.jl?branch=master

[codecov-img]: https://codecov.io/gh/JuliaPhysics/PhysicalConstants.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaPhysics/PhysicalConstants.jl
