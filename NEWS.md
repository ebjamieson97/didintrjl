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
