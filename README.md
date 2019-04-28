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
different datasets as needed.  Currently, only 2014 edition of
[CODATA](https://physics.nist.gov/cuu/Constants/) recommended values of the
fundamental physical constants is provided.

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
example, for CODATA 2014 load `PhysicalConstants.CODATA2014`:

```julia
julia> using PhysicalConstants.CODATA2014

julia> SpeedOfLightInVacuum
Speed of light in vacuum (c_0)
Value                         = 2.99792458e8 m s^-1
Standard uncertainty          = (exact)
Relative standard uncertainty = (exact)
Reference                     = CODATA 2014

julia> NewtonianConstantOfGravitation
Newtonian constant of gravitation (G)
Value                         = 6.67408e-11 m^3 kg^-1 s^-2
Standard uncertainty          = 3.1e-15 m^3 kg^-1 s^-2
Relative standard uncertainty = 4.6e-5
Reference                     = CODATA 2014
```

`SpeedOfLightInVacuum` and `NewtonianConstantOfGravitation` are two of the
`Constant`s defined in the `PhysicalConstants.CODATA2014` module, the full list
of available constants is given below.

`Constant`s can be readily used in mathematical operations, using by default
their `Float64` value:

```julia
julia> import PhysicalConstants.CODATA2014: c_0, ε_0, μ_0

julia> 2 * ε_0
1.7708375635240778e-11 F m^-1

julia> ε_0 - 1 / (μ_0 * c_0 ^ 2)
0.0 A^2 s^4 kg^-1 m^-3
```

If you want to use a different precision for the value of the constant, use the
function `float(float_type, constant)`, for example:

```julia
julia> float(Float32, ε_0)
8.854188f-12 F m^-1

julia> float(BigFloat, ε_0)
8.854187817620389850536563031710750260608370166599449808102417152405395095459979e-12 F m^-1

julia> big(ε_0)
8.854187817620389850536563031710750260608370166599449808102417152405395095459979e-12 F m^-1

julia> big(ε_0) - inv(big(μ_0) * big(c_0)^2)
0.0 A^2 s^4 kg^-1 m^-3
```

Note that `big(constant)` is an alias for `float(BigFloat, constant)`.

If in addition to units you also want the standard uncertainty associated with
the constant, use `measurement(x)`:

```julia
julia> using Measurements

julia> import PhysicalConstants.CODATA2014: ħ

julia> measurement(ħ)
1.0545718001391127e-34 ± 1.2891550390443523e-42 J s

julia> measurement(Float32, ħ)
1.0545718e-34 ± 1.289e-42 J s

julia> measurement(BigFloat, ħ)
1.054571800139112651153941068725066773746246506229852090971714108355028066256094e-34 ± 1.289155039044352219727958483317366332479123130497697234856105486877064060837251e-42 J s

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
import PhysicalConstants: Constant, name

const constants = names(CODATA2014)
const others = setdiff(names(CODATA2014, all = true), constants)

symbol(::Constant{sym}) where sym = sym
println("| Long name | Short | Value | Unit |")
println("| --------- | ----- | ----- | ---- |")
for c in getfield.(Ref(CODATA2014), constants)
    if c isa Constant
        sym = others[findall(x -> c == getfield(CODATA2014, x), others)][1]
        println("| `", symbol(c), "` | `", sym, "` | ", ustrip(float(c)), " | ",
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
| `ElectrictConstant`                     | `ε_0` | 8.854187817620389e-12  | `F m^-1`         |
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
| `StefanBoltzmannConstant`               | `σ`   | 5.670367e-8            | `W m^-2 K^-4`    |
| `ThomsonCrossSection`                   | `σ_e` | 6.6524587158e-29       | `m^2`            |
| `WienWavelengthDisplacementLawConstant` | `b`   | 0.0028977729           | `K m`            |

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
