# Estimate the ATT using DID-INT

`didint()` estimates the average effect of treatment on the treated
(ATT) using intersection difference-in-differences developped by Karim &
Webb (2025). The method adjusts for covariates that may vary across
states, over time, or jointly by state and time. This function is an R
wrapper around the Julia implementation provided in the Didint.jl
package. For all the details visit the didintrjl documentation site:
https://ebjamieson97.github.io/didintrjl/.

## Usage

``` r
didint(
  outcome,
  state,
  time,
  data,
  gvar = NULL,
  treated_states = NULL,
  treatment_times = NULL,
  date_format = NULL,
  covariates = NULL,
  ccc = "int",
  agg = "cohort",
  weighting = "both",
  ref = NULL,
  freq = NULL,
  freq_multiplier = 1,
  start_date = NULL,
  end_date = NULL,
  nperm = 999,
  verbose = TRUE,
  seed = sample.int(1e+06, 1),
  notyet = NULL,
  hc = "hc3"
)
```

## Arguments

- outcome:

  A string giving the column name of the outcome variable.

- state:

  A string giving the column identifying states. The state column should
  be a character column.

- time:

  A string giving the column identifying dates.

- data:

  A data frame containing the variables used for estimation.

- gvar:

  String giving the column that indicates first treatment time for each
  state. Use either this option or the combination of `treated_states`
  and `treatment_times`.

- treated_states:

  Character values specifying the treated state(s).

- treatment_times:

  Specify the treated_states using strings, numbers, or Dates,
  corresponding to `treated_states`.

- date_format:

  Optional string specifying the input date format when dates are
  supplied as character strings. Applies to `start_date`, `end_date`,
  `treatment_times` and the data in the `time` column if any of those
  are strings.

- covariates:

  Optional string or vector of strings specifying covariates to include.

- ccc:

  A string specifying the DID-INT specification. One of `"hom"`,
  `"time"`, `"state"`, `"add"`, or `"int"` (default `"int"`).

- agg:

  A string indicating the aggregation method. One of `"cohort"`,
  `"simple"`, `"state"`, `"sgt"`, `"time"` or `"none"`.

- weighting:

  Weighting scheme to use. One of `"both"`, `"att"`, `"diff"`, or
  `"none"`.

- ref:

  Optional named list indicating the reference category for categorical
  covariates.

- freq:

  Optional string specifying the period length for staggered adoption.
  One of `"year"`, `"month"`, `"week"`, `"day"`.

- freq_multiplier:

  Integer multiplier for `freq`. Default is 1.

- start_date:

  Optional earliest date to retain in the data.

- end_date:

  Optional latest date to retain in the data.

- nperm:

  Number of permutations for randomization inference. Default is 999.

- verbose:

  Logical value, if `TRUE`, prints progress during randomization
  inference procedure.

- seed:

  Integer seed for randomization inference.

- notyet:

  Logical value if `TRUE`, uses pre-treatment periods from treated
  states as controls.

- hc:

  Heteroskedasticity-consistent covariance matrix estimator. One of
  `"hc0"`, `"hc1"`, `"hc2"`, `"hc3"`, `"hc4"`.

## Value

Results. ATT, p-values etc.

## Details

The arguments `treated_states` and `treatment_times` must be supplied
such that their ordering corresponds with one another. That is, the
first element of `treated_states` refers to the state treated at the
date given by the first element of `treatment_times`, and so on.

Dates can be entered as strings, numbers, or Date objects. When
character strings are supplied, the input format must be specified via
the `date_format` argument (e.g. `"yyyy-mm-dd"`).

Period grids for staggered adoption are constructed automatically, based
on the inputted data. Otherwise, the period grid can be created manually
using the arguments `freq`, `freq_multiplier`, `start_date`, and
`end_date`. More information on this process can be seen on the
didintrjl documentation site: https://ebjamieson97.github.io/didintrjl/.

## References

Karim & Webb (2025). *Good Controls Gone Bad: Difference-in-Differences
with Covariates*. <https://arxiv.org/abs/2412.14447>

MacKinnon & Webb (2020). *Randomization inference for
difference-in-differences with few treated clusters*.
[doi:10.1016/j.jeconom.2020.04.024](https://doi.org/10.1016/j.jeconom.2020.04.024)

## Examples

``` r
file_path <- system.file("extdata", "merit.csv", package = "didintrjl")
df <- utils::read.csv(file_path)
#didint()
```
