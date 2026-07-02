# Estimate the ATT using DID-INT

`didint()` estimates the average effect of treatment on the treated
(ATT) using intersection difference-in-differences developped by Karim &
Webb (2025). The method adjusts for covariates that may vary across
states, over time, or jointly by state and time. This function is an R
wrapper around the Julia implementation provided in the DiDInt.jl
package. For more details on the didintrjl wrapper, visit the didintrjl
documentation site: https://ebjamieson97.github.io/didintrjl/. For more
details on the backend implementation, see:
https://ebjamieson97.github.io/DiDInt.jl/stable/

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
  hc = "hc1",
  truejack = FALSE,
  edgecase = FALSE
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

- truejack:

  Logical value, if `TRUE`, re-estimates the DID-INT model from the
  first step (if `ccc` option is not `"int"` or "`state`").

- edgecase:

  Logical value, if `TRUE` computes any edge case standard errors from
  saturated Step 3 regressions - see the DiDInt.jl documentation site
  (https://ebjamieson97.github.io/DiDInt.jl/stable/) for more details.
  Defaults to `FALSE.`

## Value

An object of class `DiDIntObj`, a list containing the aggregate results,
sub-aggregate results, and model specifications. Has associated
[`print.DiDIntObj`](https://ebjamieson97.github.io/didintrjl/reference/print.DiDIntObj.md),
[`summary.DiDIntObj`](https://ebjamieson97.github.io/didintrjl/reference/summary.DiDIntObj.md),
and
[`coef.DiDIntObj`](https://ebjamieson97.github.io/didintrjl/reference/coef.DiDIntObj.md)
methods.

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
DiDInt.jl documentation site:
https://ebjamieson97.github.io/DiDInt.jl/stable/.

## References

Karim & Webb (2025). *Good Controls Gone Bad: Difference-in-Differences
with Covariates*. <https://arxiv.org/abs/2412.14447>

MacKinnon & Webb (2020). *Randomization inference for
difference-in-differences with few treated clusters*.
[doi:10.1016/j.jeconom.2020.04.024](https://doi.org/10.1016/j.jeconom.2020.04.024)

## Examples

``` r
if (Sys.getenv("NOT_CRAN") == "true" && didintrjl_ready()) {
 file_path <- system.file("extdata", "merit.csv", package = "didintrjl")
 df <- utils::read.csv(file_path)
 res <- didint("coll", "state", "year", df, verbose = FALSE,
               treated_states = c(71, 58, 64, 59, 85, 57, 72, 61, 34, 88), nperm = 399,
               treatment_times = c(1991, 1993, 1996, 1997, 1997, 1998, 1998, 1999, 2000, 2000))
 summary(res)
 DONTSHOW({
   JuliaConnectoR::stopJulia()
 })
}
#> Starting Julia ...
#> Package "Tables.jl" (version >= 1.0) is required. Installing ...
#> Starting Julia ...
#> 
#>   Model Specification: Two-way DID-INT
#>   Weighting: both
#>   Aggregation: cohort
#>   Period Length: 1 year
#>   First Period: 1989
#>   Last Period: 2000
#>   Permutations: 399
#> 
#> Aggregate Results:
#>         ATT Std. Error     p-value RI p-value Jackknife SE Jackknife p-value
#>  0.04582252 0.01159691 0.007526681  0.1629073   0.01520398        0.00404305
#> 
#> Subaggregate Results:
#> Treatment Time              ATT         SE    p-value   RI p-val      JK SE   JK p-val     Weight
#> -------------------------------------------------------------------------------------------------------------- 
#> 1991-01-01               0.0529     0.0221     0.0172     0.4912         NA         NA     0.2018
#> 1993-01-01               0.0236     0.0166     0.1554     0.7343         NA         NA     0.1915
#> 1996-01-01               0.0564     0.0242     0.0208     0.4762         NA         NA     0.0757
#> 1997-01-01               0.0711     0.0230     0.0023     0.1955     0.0257     0.0080     0.3211
#> 1998-01-01               0.0485     0.0329     0.1427     0.4536     0.0838     0.5650     0.1086
#> 1999-01-01               0.0120     0.0150     0.4235     0.8822         NA         NA     0.0355
#> 2000-01-01              -0.0331     0.0320     0.3081     0.7243     0.0966     0.7336     0.0658
```
