# Check if didintrjl is ready to go

Checks whether Julia is set up correctly via `JuliaConnectoR` and the
`DiDInt.jl` package (version \>= 0.9.6) is available. Used to guard
examples and tests that require a live Julia session.

## Usage

``` r
didintrjl_ready()
```

## Value

A single logical value: `TRUE` if Julia, JuliaConnectoR, and DiDInt.jl
(\>= 0.9.6) are all available; `FALSE` otherwise.
