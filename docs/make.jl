using Documenter, PhysicalConstants, Unitful

## Generate list of constants
open(joinpath(@__DIR__, "src", "constants.md"), "w") do io
    print(io, """
              ## List of Set of Constants

              !!! note

                  Each dataset listed below exports by default only the full
                  long names of the constants.  Short aliases are provided for
                  convenience, but they are not exported, to avoid polluting
                  the main namespace with dozens of short-named variables.
                  Users can to import the short names of the variables they
                  use most frequently, as shown in the examples above.
              """
          )
    for set in (PhysicalConstants.CODATA2014, PhysicalConstants.CODATA2018)
        println(io)
        println(io, "### ", nameof(set))
        println(io)
        constants = names(set)
        others = setdiff(names(set, all = true), constants)
        println(io, "| Long name | Short | Value | Unit |")
        println(io, "| --------- | ----- | ----- | ---- |")
        for constant in constants
            c = getfield(set, constant)
            if c isa PhysicalConstants.PhysicalConstant
                sym = others[findall(x -> c === getfield(set, x), others)][1]
                println(io, "| `", constant, "` | `", sym, "` | ", ustrip(float(c)), " | ",
                        unit(c) == Unitful.NoUnits ? "" : "`$(unit(c))`", " |")
            end
        end
    end
end

## Build docs
makedocs(
    modules = [PhysicalConstants],
    sitename = "PhysicalConstants",
    pages    = [
        "Introduction" => "index.md",
        "Usage" => "usage.md",
        "List of Constants" => "constants.md",
        "API Reference" => "reference.md",
    ]
)

### Deploy docs
deploydocs(
    repo = "github.com/JuliaPhysics/PhysicalConstants.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
    push_preview = true,
)
