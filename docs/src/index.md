# PhysicalConstants.jl

## Introduction

[`PhysicalConstants.jl`](https://github.com/JuliaPhysics/PhysicalConstants.jl)
provides common physical constants.  They are defined as instances of the new
`Constant` type, which is subtype of `AbstractQuantity` (from
[`Unitful.jl`](https://github.com/PainterQubits/Unitful.jl) package) and can also
be turned into `Measurement` objects (from
[`Measurements.jl`](https://github.com/JuliaPhysics/Measurements.jl) package) at
request.

Constants are grouped into different submodules, so that the user can choose
different datasets as needed.  Currently, 2014, 2018, and 2022 editions of
[CODATA](https://physics.nist.gov/cuu/Constants/) recommended values of the
fundamental physical constants are provided.

## Installation

The latest version of `PhysicalConstants.jl` is available for Julia 1.0 and
later versions, and can be installed with [Julia built-in package
manager](https://julialang.github.io/Pkg.jl/stable/).  After entering the
package manager mode by pressing `]`, run the command

```julia
pkg> add PhysicalConstants
```

## License

The `PhysicalConstants.jl` package is licensed under the MIT "Expat" License.
The original author is [Mosè Giordano](https://github.com/giordano/).
