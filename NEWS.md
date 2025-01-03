# History of PhysicalConstants.jl

## v0.2.4 (2025-01-03)

### New Features

* New set `CODATA2022` added in module `PhysicalConstants.CODATA2022`
  ([#34](https://github.com/JuliaPhysics/PhysicalConstants.jl/issues/34),
  [#39](https://github.com/JuliaPhysics/PhysicalConstants.jl/pull/39)).
* New function `PhysicalConstants.reference` to access the reference of a
  constant
  ([#35](https://github.com/JuliaPhysics/PhysicalConstants.jl/issues/35),
  [#37](https://github.com/JuliaPhysics/PhysicalConstants.jl/pull/37)).

## v0.2.3 (2022-09-01)

### Bug Fixes

* Fixed compatibility issue with `Measurements.jl` v2.8.0 caused by this package
  using internal functions non part of the public API
  ([#24](https://github.com/JuliaPhysics/PhysicalConstants.jl/issues/24),
  [#25](https://github.com/JuliaPhysics/PhysicalConstants.jl/pull/25)).

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
