# didintrjl: Intersection Difference-in-Differences

An R wrapper for the Julia package DiDInt.jl, implementing intersection
difference-in-differences (DID-INT).

## Details

Implements intersection difference-in-differences (DID-INT), a method
developed by Karim and Webb (2025) that allows for unbiased estimation
of the average effect of treatment on the treated (ATT) in settings
where the common causal covariates (CCC) assumption is violated.
Supports common or staggered adoption and the inclusion of covariates
whose effects on the outcome of interest may vary by state, time, or
both. The package interfaces with the Julia package DiDInt.jl via
JuliaConnectoR.

## Estimation

- [`didint`](https://ebjamieson97.github.io/didintrjl/reference/didint.md) -
  Estimates the ATT, returning a `DiDIntObj` with
  [`print()`](https://rdrr.io/r/base/print.html),
  [`summary()`](https://rdrr.io/r/base/summary.html), and
  [`coef()`](https://rdrr.io/r/stats/coef.html) methods.

## Plotting

- [`didint_plot`](https://ebjamieson97.github.io/didintrjl/reference/didint_plot.md) -
  Produces parallel trends or event study plots, returning a
  `DiDIntPlotObj` with a
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) method.

## See also

Useful links:

- <https://ebjamieson97.github.io/didintrjl/>

- <https://github.com/ebjamieson97/undidR>

- Report bugs at <https://github.com/ebjamieson97/didintrjl/issues>

## Author

Eric B. Jamieson
