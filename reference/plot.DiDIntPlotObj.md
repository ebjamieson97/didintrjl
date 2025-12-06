# Plot method for `DiDIntPlotObj`

Plot method for `DiDIntPlotObj`

## Usage

``` r
# S3 method for class 'DiDIntPlotObj'
plot(x, y = NULL, ccc = "all", groupmin = 3, window = NULL, ...)
```

## Arguments

- x:

  A `DiDIntPlotObj` object.

- y:

  `NULL` value passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) method.

- ccc:

  Specify which `ccc` options you would like plotted from the data. Any
  combination of `"none"`, `"hom"`, `"time"`, `"state"`, `"add"`, and
  `"int"`. Or, alternatively, `"all"` (default).

- groupmin:

  The minimum number of states used to compute a point on the event
  study for which the confidence band should be shown. Defaults to `3`.

- window:

  Either `NULL` or a vector with two elements defining the first and
  last period that should be plotted.

- ...:

  other arguments
