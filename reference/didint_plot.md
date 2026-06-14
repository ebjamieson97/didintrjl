# Make event study or parallel trends plots

`didint_plot()` produces either event study plots or parallel trends
plots depending on what is specified via the `event` argument. The
parallel trends plots, as well as the event study plots, are created
using the means residualized by covariates under different model
specifications that account for different violations of the common
causal covaraites (CCC) assumptions.

## Usage

``` r
didint_plot(
  outcome,
  state,
  time,
  data,
  gvar = NULL,
  treated_states = NULL,
  treatment_times = NULL,
  date_format = NULL,
  covariates = NULL,
  ref = NULL,
  ccc = "all",
  event = FALSE,
  weights = TRUE,
  ci = 0.95,
  freq = NULL,
  freq_multiplier = 1,
  start_date = NULL,
  end_date = NULL,
  hc = "hc1"
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

- ref:

  Optional named list indicating the reference category for categorical
  covariates.

- ccc:

  A string specifying the DID-INT specification. Any combination of
  `"none"`, `"hom"`, `"time"`, `"state"`, `"add"`, and `"int"`. Or,
  alternatively, `"all"` (default).

- event:

  A logical value used to specify if event study plots should be made
  (`TRUE`) or if parallel trends plots should be made (`FALSE`).

- weights:

  A logical value, if `TRUE`, estimates for the event study plot are
  computed as weighted averages of state level means for each period
  relative to their treatment period; if `FALSE`, uses unweighted
  averages.

- ci:

  A number between 0 and 1 used to specify the size of the confidence
  bands.

- freq:

  Optional string specifying the period length for staggered adoption.
  One of `"year"`, `"month"`, `"week"`, `"day"`.

- freq_multiplier:

  Integer multiplier for `freq`. Default is 1.

- start_date:

  Optional earliest date to retain in the data.

- end_date:

  Optional latest date to retain in the data.

- hc:

  Heteroskedasticity-consistent covariance matrix estimator. One of
  `"hc0"`, `"hc1"`, `"hc2"`, `"hc3"`, `"hc4"`.

## Value

A DiDIntPlotObj.

## Details

The arguments `treated_states` and `treatment_times` must be supplied
such that their ordering corresponds with one another. That is, the
first element of `treated_states` refers to the state treated at the
date given by the first element of `treatment_times`, and so on.

Dates can be entered as strings, numbers, or Date objects. When
character strings are supplied, the input format must be specified via
the `date_format` argument (e.g. `"yyyy-mm-dd"`).

Period grids are constructed automatically, based on the inputted data
Otherwise, the period grid can be created manually using the arguments
`freq`, `freq_multiplier`, `start_date`, `end_date`. More information on
this process can be seen on the didintrjl documentation site:
https://ebjamieson97.github.io/didintrjl/.

## References

Karim & Webb (2025). *Good Controls Gone Bad: Difference-in-Differences
with Covariates*. <https://arxiv.org/abs/2412.14447>

## Examples

``` r
# The example is capped at 9s elapsed so it exits gracefully on systems
# where Julia is unavailable; on a machine with Julia + DiDInt.jl a full
# run may take longer and be cut off — remove setTimeLimit() to run it to
# completion.
setTimeLimit(elapsed = 9, transient = TRUE)
tryCatch({
if (JuliaConnectoR::juliaSetupOk() &&
    JuliaConnectoR::juliaEval('using Pkg;
     _didint_pkgs = filter(p -> p.second.name == "DiDInt", Pkg.dependencies());
     !isempty(_didint_pkgs) && first(values(_didint_pkgs)).version >= v"0.9.6"')) {
 file_path <- system.file("extdata", "merit.csv", package = "didintrjl")
 df <- utils::read.csv(file_path)
 res_event <- didint_plot(
   "coll", "state", "year", df, event = TRUE,
   treated_states = c(71, 58, 64, 59, 85, 57, 72, 61, 34, 88),
   treatment_times = c(1991, 1993, 1996, 1997, 1997, 1998, 1998, 1999,
                       2000, 2000),
   covariates = c("asian", "black", "male")
 )
 plot(res_event)
}
}, error = function(e) invisible(NULL))
#> Starting Julia ...
```
