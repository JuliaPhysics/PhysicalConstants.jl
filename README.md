# Constants.jl

Introduction
------------

`Constants.jl` provides common physical constants.  They are defined as
`Constant` objects, which can be turned into `Quantity` objects (from
[`Unitful.jl`](https://github.com/ajkeller34/Unitful.jl) package) or
`Measurement` objects (from
[`Measurements.jl`](https://github.com/JuliaPhysics/Measurements.jl) package) at
request.

Constants are grouped into different submodules, so that the user can choose
different datasets as needed.  Currently, only 2014 edition of
[CODATA](https://physics.nist.gov/cuu/Constants/) recommended values of the
fundamental physical constants is provided.

Installation
------------

`Measurements.jl` is available for Julia 0.7 and later versions, and can be
installed with
[Julia built-in package manager](http://docs.julialang.org/en/stable/manual/packages/).
In a Julia session run the command

```julia
pkg> add https://github.com/JuliaPhysics/Constants.jl
```

Usage
-----

You can load the package as usual with `using Constants` but this module does
not provide anything useful for the end-users.  You most probably want to
directly load the submodule with the dataset you are interested in.  For
example, for CODATA 2014 load `Constants.CODATA2014`:

```julia
julia> using Constants.CODATA2014

julia> c
Speed of light in vacuum (c)
Value                         = 2.99792458e8 m s^-1
Standard uncertainty          = (exact)
Relative standard uncertainty = (exact)
Reference                     = CODATA 2014

julia> G
Newtonian constant of gravitation (G)
Value                         = 6.67408e-11 m^3 kg^-1 s^-2
Standard uncertainty          = 3.1e-15 m^3 kg^-1 s^-2
Relative standard uncertainty = 4.6e-5
Reference                     = CODATA 2014
```

`c` and `G` are two of the `Constant`s defined in the `Constants.CODATA2014`
module, the full list of available constants is given below.

You can turn a `Constant` into a `Quantity` object, with physical units, by
using `float(x)`:

```julia
julia> float(ε_0)
8.854187817620389e-12 F m^-1
```

You can optionally specify the floating-point precision of the resulting number,
this package takes care of keeping the value accurate also with `BigFloat`:

```julia
julia> float(Float32, ε_0)
8.854188f-12 F m^-1

julia> float(BigFloat, ε_0)
8.854187817620389850536563031710750260608370166599449808102417152405395095459979e-12 F m^-1

julia> big(ε_0)
8.854187817620389850536563031710750260608370166599449808102417152405395095459979e-12 F m^-1

julia> big(ε_0) - inv(big(μ_0) * big(c)^2)
0.0 A^2 s^4 kg^-1 m^-3
```

Note that `big(x)` is an alias for `float(BigFloat, x)`.

If in addition to units you also want the standard uncertainty associated with
the constant, use `measurement(x)`:

```julia
julia> using Measurements

julia> measurement(ħ)
1.0545718001391127e-34 ± 1.2891550390443523e-42 J s

julia> measurement(Float32, ħ)
1.0545718e-34 ± 1.289e-42 J s

julia> measurement(BigFloat, ħ)
1.054571800139112651153941068725066773746246506229852090971714108355028066256094e-34 ± 1.289155039044352219727958483317366332479123130497697234856105486877064060837251e-42 J s

julia> measurement(BigFloat, ħ) / (measurement(BigFloat, h) / (2 * big(pi)))
1.0 ± 0.0
```

List of Constants
-----------------

<!-- using Constants.CODATA2014, Unitful -->
<!-- import Constants: Constant, name -->
<!-- symbol(::Constant{sym}) where sym = sym -->
<!-- println("| Symbol | Name | Value | Unit |") -->
<!-- println("| ------ | ---- | ----- | ---- |") -->
<!-- for c in getfield.(Ref(CODATA2014), names(CODATA2014)) -->
<!--     if c isa Constant -->
<!--         println("| `", symbol(c), "` | ", name(c), " | ", ustrip(float(c)), " | ", -->
<!--                 unit(c) == Unitful.NoUnits ? "" : "`$(unit(c))`", " |") -->
<!--     end -->
<!-- end -->

### CODATA 2014

| Symbol | Name                                      | Value                  | Unit             |
| ------ | ----                                      | -----                  | ----             |
| `G`    | Newtonian constant of gravitation         | 6.67408e-11            | `m^3 kg^-1 s^-2` |
| `N_A`  | Avogadro constant                         | 6.022140857e23         | `mol^-1`         |
| `R`    | Molar gas constant                        | 8.3144598              | `J K^-1 mol^-1`  |
| `R_∞`  | Rydberg constant                          | 1.0973731568508e7      | `m^-1`           |
| `Z_0`  | Characteristic impedance of vacuum        | 376.73031346177066     | `Ω`              |
| `a_0`  | Bohr radius                               | 5.2917721067e-11       | `m`              |
| `atm`  | Standard atmosphere                       | 101325.0               | `Pa`             |
| `b`    | Wien wavelength displacement law constant | 0.0028977729           | `K m`            |
| `c`    | Speed of light in vacuum                  | 2.99792458e8           | `m s^-1`         |
| `e`    | Elementary charge                         | 1.6021766208e-19       | `C`              |
| `g_n`  | Standard acceleration of gravitation      | 9.80665                | `m s^-2`         |
| `h`    | Planck constant                           | 6.62607004e-34         | `J s`            |
| `k_B`  | Boltzmann constant                        | 1.38064852e-23         | `J K^-1`         |
| `m_e`  | Electron mass                             | 9.10938356e-31         | `kg`             |
| `m_n`  | Neutron mass                              | 1.674927471e-27        | `kg`             |
| `m_p`  | Protron mass                              | 1.672621898e-27        | `kg`             |
| `m_u`  | Atomic mass constant                      | 1.66053904e-27         | `kg`             |
| `ħ`    | Planck constant over 2pi                  | 1.0545718001391127e-34 | `J s`            |
| `α`    | Fine-structure constant                   | 0.0072973525664        |                  |
| `ε_0`  | Electric constant                         | 8.854187817620389e-12  | `F m^-1`         |
| `μ_0`  | Magnetic constant                         | 1.2566370614359173e-6  | `N A^-2`         |
| `μ_B`  | Bohr magneton                             | 9.274009994e-24        | `J T^-1`         |
| `σ`    | Stefan-Boltzmann constant                 | 5.670367e-8            | `m^2`            |
| `σ_e`  | Thomson cross section                     | 6.6524587158e-29       | `m^2`            |

License
-------

The `Constants.jl` package is licensed under the MIT "Expat" License.  The
original author is [Mosè Giordano](https://github.com/giordano/).
