# Constants.jl

Introduction
------------

`Constants.jl` provides common physical constants.  They are defined as
`Constant` objects, which can be turned into `Quantity` objects (from
[`Unitful.jl`](https://github.com/ajkeller34/Unitful.jl) package) or
`Measurement` objects (from
[`Measurements.jl`](https://github.com/JuliaPhysics/Measurements.jl) package).

Constants are grouped into different submodules, so that the user can choose
different datasets as needed.  Currently, only 2014 edition of
[CODATA](https://physics.nist.gov/cuu/Constants/) recommended values of the
fundamental physical constants is provided.

Installation
------------

`Measurements.jl` is available for Julia 0.7 and later versions, and can be
installed with
[Julia built-in package manager](http://docs.julialang.org/en/stable/manual/packages/).
In a Julia session run the commands

```julia
pkg> add https://github.com/JuliaPhysics/Constants.jl
```

Usage
-----

...

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

| Symbol | Name                                      | Value                  | Unit             |
| ------ | ----                                      | -----                  | ----             |
| `G`    | Newtonian constant of gravitation         | 6.67408e-11            | `m^3 kg^-1 s^-2` |
| `N_A`  | Avogadro constant                         | 6.022140857e23         | `mol^-1`         |
| `R`    | Molar gas constant                        | 8.3144598              | `J K^-1 mol^-1`  |
| `R_∞`  | Rydberg constant                          | 1.0973731568508e7      | `m^-1`           |
| `a_0`  | Bohr radius                               | 5.2917721067e-11       | `m`              |
| `atm`  | Standard atmosphere                       | 101325.0               | `Pa`             |
| `b`    | Wien wavelength displacement law constant | 0.0028977729           | `K m`            |
| `c`    | Speed of light in vacuum                  | 2.99792458e8           | `m s^-1`         |
| `e`    | Elementary charge                         | 1.6021766208e-19       | `C`              |
| `g_n`  | Standard acceleration of gravitaty        | 9.80665                | `m s^-2`         |
| `h`    | Planck constant                           | 6.62607004e-34         | `J s`            |
| `k_B`  | Boltzmann constant                        | 1.38064852e-23         | `J K^-1`         |
| `m_e`  | Electron mass                             | 9.10938356e-31         | `kg`             |
| `m_n`  | Neutron mass                              | 1.674927471e-27        | `kg`             |
| `m_p`  | Protron mass                              | 1.672621898e-27        | `kg`             |
| `ħ`    | Planck constant over 2pi                  | 1.0545718001391127e-34 | `J s`            |
| `α`    | Fine-structure constant                   | 0.0072973525664        |                  |
| `ε_0`  | Electric constant                         | 8.854187817620389e-12  | `F m^-1`         |
| `μ_0`  | Magnetic constant                         | 1.2566370614359173e-6  | `N A^-2`         |
| `μ_B`  | Bohr magneton                             | 9.274009994e-24        | `J T^-1`         |
| `σ`    | Stefan-Boltzmann constant                 | 5.670367e-8            | `m^2`            |
| `σ_e`  | Thomson cross section                     | 6.6524587158e-29       | `m^2`            |
