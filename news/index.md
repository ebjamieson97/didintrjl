# Changelog

## didintrjl 0.0.3

- Added
  [`didint_plot()`](https://ebjamieson97.github.io/didintrjl/reference/didint_plot.md)
  function and updated the
  [`summary()`](https://rdrr.io/r/base/summary.html) method for
  `DiDIntObj`.

## didintrjl 0.0.2

- Added [`coef()`](https://rdrr.io/r/stats/coef.html) and
  [`summary()`](https://rdrr.io/r/base/summary.html) methods to
  `DiDIntObj`.

## didintrjl 0.0.1

- Switched from using JuliaCall to now using JuliaConnectoR.
- [`didint()`](https://ebjamieson97.github.io/didintrjl/reference/didint.md)
  now returns an S3 object of class `DiDIntObj` instead of a raw
  dataframe.
- Added [`print()`](https://rdrr.io/r/base/print.html) method for
  `DiDIntObj` objects with `level` argument to display aggregate or
  sub-aggregate results via `"agg"` or `"sub"` options.

## didintrjl 0.0.0.9000

- Initial package setup.
