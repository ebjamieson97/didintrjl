# didintrjl 0.2.5

* Wrapped the examples for `didint()` and `didint_plot()` in `donttest{}` since there still seems to be an issue on the CRAN check not found on `check_win_devel()`.

# didintrjl 0.2.4

* Wrapped the examples for `didint()` and `didint_plot()` with a `setTimeLimit()` call in order to ensure a graceful exit on systems without Julia.

# didintrjl 0.2.3

* Added the `edgecase` option for `didint()` to toggle computation of edge case standard errors from saturated Step 3 regressions (see https://ebjamieson97.github.io/DiDInt.jl/stable/details/ for more details). 

# didintrjl 0.2.1

* Added the `truejack` option, which re-estimates the DID-INT model from step 1 while calculating the jackknife if set to `TRUE`.

# didintrjl 0.2.0

* Added arguments `window` and `mingroup` to the `plot()` method for `DiDIntPlotObj`. These new arguments allow the user to specify the range of periods plotted, and the points for which they want the confidence band to appear in the case of events plots. These new arguments require updating the DiDInt.jl package for Julia to v0.6.15.

# didintrjl 0.1.0

* `didint_plot()` now returns a `DiDIntPlotObj` which has the `plot()` method. The `DiDIntPlotObj` also stores the data used to make the plot so that users can customize their own plots if they so choose.
* All anticipated front-end features are now implemented.

# didintrjl 0.0.3

* Added `didint_plot()` function and updated the `summary()` method for `DiDIntObj`.

# didintrjl 0.0.2

* Added `coef()` and `summary()` methods to `DiDIntObj`.

# didintrjl 0.0.1

* Switched from using JuliaCall to now using JuliaConnectoR.
* `didint()` now returns an S3 object of class `DiDIntObj` instead of a raw dataframe.
* Added `print()` method for `DiDIntObj` objects with `level` argument to display aggregate or sub-aggregate results via `"agg"` or `"sub"` options.

# didintrjl 0.0.0.9000

* Initial package setup.
