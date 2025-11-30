#' Estimate the ATT using DID-INT
#'
#' `didint()` estimates the average effect of treatment on the treated (ATT)
#' using intersection difference-in-differences developped by Karim & Webb
#' (2025). The method adjusts for covariates that may vary across states,
#' over time, or jointly by state and time. This function is an R wrapper
#' around the Julia implementation provided in the \pkg{Didint.jl} package.
#' For all the details visit the didintrjl documentation site:
#' https://ebjamieson97.github.io/didintrjl/.
#'
#' @details
#' The arguments `treated_states` and `treatment_times` must be supplied such
#' that their ordering corresponds with one another. That is, the first
#' element of `treated_states` refers to the state treated at the
#' date given by the first element of `treatment_times`, and so on.
#'
#' Dates can be entered as strings, numbers, or Date objects.
#' When character strings are supplied, the input format must be
#' specified via the `date_format` argument (e.g. `"yyyy-mm-dd"`).
#'
#' Period grids for staggered adoption are constructed automatically,
#' based on the inputted data. Otherwise, the period grid can be created
#' manually using the arguments `freq`, `freq_multiplier`, `start_date`,
#' and `end_date`.More information on this process can be seen on the didintrjl
#' documentation site: https://ebjamieson97.github.io/didintrjl/.
#'
#' @param outcome A string giving the column name of the outcome variable.
#' @param state A string giving the column identifying states.
#' @param time A string giving the column identifying dates.
#' @param data A data frame containing the variables used for estimation.
#'
#' @param gvar String giving the column that indicates first treatment time for
#'   each state. Use either this option or the combination of `treated_states`
#'   and `treatment_times`.
#' @param treated_states Specify the treated state(s).
#' @param treatment_times Specify the treated_states using strings, numbers,
#'   or Dates, corresponding to `treated_states`.
#'
#' @param covariates Optional string or vector of strings specifying
#'   covariates to include.
#' @param ccc A string specifying the DID-INT specification.
#'   One of `"hom"`, `"time"`, `"state"`, `"add"`, or `"int"` (default `"int"`).
#' @param agg A string indicating the aggregation method.
#'   One of `"cohort"`, `"simple"`, `"state"`, `"sgt"`, `"time"` or `"none"`.
#' @param weighting Weighting scheme to use.
#'   One of `"both"`, `"att"`, `"diff"`, or `"none"`.
#' @param notyet Logical value if `TRUE`, uses pre-treatment periods from
#'   treated states as controls.
#' @param ref Optional named list indicating the reference category for
#'   categorical covariates.
#'
#' @param date_format Optional string specifying the input date format
#'   when dates are supplied as character strings. Applies to `start_date`,
#'   `end_date`, `treatment_times` and the data in the `time` column if any
#'   of those are strings.
#' @param freq Optional string specifying the period length for staggered
#'   adoption. One of `"year"`, `"month"`, `"week"`, `"day"`.
#' @param freq_multiplier Integer multiplier for `freq`. Default is 1.
#' @param start_date Optional earliest date to retain in the data.
#' @param end_date Optional latest date to retain in the data.
#'
#' @param nperm Number of permutations for randomization inference.
#'   Default is 999.
#' @param verbose Logical value, if `TRUE`, prints progress during
#'   randomization inference procedure.
#' @param seed Integer seed for randomization inference.
#' @param hc Heteroskedasticity-consistent covariance matrix estimator.
#'   One of `"hc0"`, `"hc1"`, `"hc2"`, `"hc3"`, `"hc4"` or numeric 0–4.
#'
#' @returns
#' Results. ATT, p-values etc.
#'
#' @examples
#' file_path <- system.file("extdata", "merit.csv", package = "didintrjl")
#' df <- utils::read.csv(file_path)
#' #didint()
#'
#' @references
#' Karim & Webb (2025).
#' *Good Controls Gone Bad: Difference-in-Differences with Covariates*.
#'   \url{https://arxiv.org/abs/2412.14447}
#'
#' MacKinnon & Webb (2020).
#' *Randomization inference for difference-in-differences with few treated clusters*.
#'   \doi{10.1016/j.jeconom.2020.04.024}
#'
#' @importFrom JuliaCall julia_setup
#' @export
didint <- function(
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
  seed = sample.int(1000000, 1),
  use_pre_controls = FALSE,
  notyet = NULL,
  hc = "hc3"
) {

  # First, setup Julia in R using JuliaCall, set rebuild to TRUE to allow
  julia <- JuliaCall::julia_setup()

  # Then, if needed, install the DiDInt.jl Julia package
  julia$install_package_if_needed("https://github.com/ebjamieson97/DiDInt.jl")

  # Load the DiDInt.jl library
  julia$library("DiDInt")

  # Now, pass all the args to Julia
  # Assign the data frame to Julia
  julia$assign("data", data)

  # Convert ref from R list to Julia Dict if provided
  if (!is.null(ref)) {
    julia$assign("ref", ref)
    julia$command("begin
    ref = Dict{String, String}(string(k) => v for (k, v) in ref)
    end")
  } else {
    julia$assign("ref", NULL)
  }

  # Assign all other arguments
  julia$assign("outcome", outcome)
  julia$assign("state", state)
  julia$assign("time", time)
  julia$assign("gvar", gvar)
  julia$assign("treated_states", treated_states)
  julia$assign("treatment_times", treatment_times)
  julia$assign("date_format", date_format)
  julia$assign("covariates", covariates)
  julia$assign("ccc", ccc)
  julia$assign("agg", agg)
  julia$assign("weighting", weighting)
  julia$assign("freq", freq)
  julia$assign("freq_multiplier", freq_multiplier)
  julia$assign("start_date", start_date)
  julia$assign("end_date", end_date)
  julia$assign("nperm", nperm)
  julia$assign("verbose", verbose)
  julia$assign("seed", seed)
  julia$assign("use_pre_controls", use_pre_controls)
  julia$assign("notyet", notyet)
  julia$assign("hc", hc)

  # And then call the DiDInt.didint() function
  result <- julia$eval("begin
    DiDInt.didint(
      outcome,
      state,
      time,
      data;
      gvar = gvar,
      treated_states = treated_states,
      treatment_times = treatment_times,
      date_format = date_format,
      covariates = covariates,
      ccc = ccc,
      agg = agg,
      weighting = weighting,
      ref = ref,
      freq = freq,
      freq_multiplier = freq_multiplier,
      start_date = start_date,
      end_date = end_date,
      nperm = nperm,
      verbose = verbose,
      seed = seed,
      use_pre_controls = use_pre_controls,
      notyet = notyet,
      hc = hc
    )
  end")

  return(result)

}
