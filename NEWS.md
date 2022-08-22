# History of PhysicalConstants.jl

## v0.2.2 (2022-08-22)

### New Features

* Add characteristic impedance of vacuum to CODATA2018

## v0.2.1 (2020-05-25)

* Documentation available at
  https://juliaphysics.github.io/PhysicalConstants.jl/stable/

## v0.2.0 (2019-05-21)

### New Features

* New set `CODATA2018` added.

### Bug Fixes

* Unit of `CODATA2014.StefanBoltzmannConstant` has been fixed
  ([#11](https://github.com/JuliaPhysics/PhysicalConstants.jl/pull/11))
* Spelling of `CODATA2014.ElectricConstant` has been fixed
  ([#12](https://github.com/JuliaPhysics/PhysicalConstants.jl/pull/12))

## v0.1.0 (2019-03-30)

* Initial release.

### New Features

* Define `PhysicalConstant` type, subtype of `AbstractQuantity` from
  `Unitful.jl`.
* Define first set of commonly used constants.
