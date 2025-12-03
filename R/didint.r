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
#' and `end_date`. More information on this process can be seen on the didintrjl
#' documentation site: https://ebjamieson97.github.io/didintrjl/.
#'
#' @param outcome A string giving the column name of the outcome variable.
#' @param state A string giving the column identifying states. The state column
#'   should be a character column.
#' @param time A string giving the column identifying dates.
#' @param data A data frame containing the variables used for estimation.
#'
#' @param gvar String giving the column that indicates first treatment time for
#'   each state. Use either this option or the combination of `treated_states`
#'   and `treatment_times`.
#' @param treated_states Character values specifying the treated state(s).
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
#'   One of `"hc0"`, `"hc1"`, `"hc2"`, `"hc3"`, `"hc4"`.
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
#' @importFrom JuliaConnectoR juliaSetupOk juliaImport juliaEval
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
  notyet = NULL,
  hc = "hc3"
) {

  # Check JuliaSetupOK
  if (!identical(JuliaConnectoR::juliaSetupOk(), TRUE)) {
    stop(paste0("Could not connect to Julia using JuliaConnectoR.",
                " JuliaConnectoR::juliaSetupOk() failed.",
                "\nSee the JuliaConnectoR package for more details:",
                " https://github.com/stefan-m-lenz/JuliaConnectoR"))
  }

  # Check that DiDINT exists
  didint_exists <- JuliaConnectoR::juliaEval('
                   using Pkg
                   "DiDInt" in [pkg.name for pkg in values(Pkg.dependencies())]
                   ')
  if (!didint_exists) {
    stop(paste0("Could not find the DiDInt.jl Julia package. Try running:\n",
                "JuliaConnectoR::juliaEval('using Pkg;\n",
                "Pkg.add(url=\"https://github.com/ebjamieson97/DiDInt.jl\")')"))
  }

  # Import DiDInt
  DiDInt <- JuliaConnectoR::juliaImport("DiDInt")
  didintrjl <- DiDInt$didint

  # Ensure that the state column and treated_states are strings
  data[, state] <- as.character(data[, state])
  treated_states <- as.character(treated_states)

  # Run the function and convert to R dataframe
  result <- didintrjl(outcome,
                      state,
                      time,
                      data,
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
                      notyet = notyet,
                      hc = hc,
                      wrapper = "r")
  result <- as.data.frame(result)

  # Rename any of the sub-aggregate att columns for ease of conversion
  cols <- names(result)
  prefixes <- c("att_", "se_att_", "pval_att_",
                "jknifese_att_", "jknifepval_att_", "ri_pval_att_")
  for (prefix in prefixes) {
    matching_cols <- grep(paste0("^", prefix), cols, value = TRUE)
    for (old_name in matching_cols) {
      new_name <- paste0(prefix, "sub")
      names(result)[names(result) == old_name] <- new_name
    }
  }

  result <- create_didint_object(result, ccc, weighting, agg)
  return(result)

}


#' @title DiDIntObj
#'
#' @description Objects of this class store all of the results for a given
#' set of aggregation, weighting, and ccc options.
#'
#' @param result DataFrame of results from DiDInt.jl
#' @param ccc The specified CCC variation of DID-INT that was used.
#' @param weighting The weighting method that was used.
#' @param agg The aggregation method that was used.
#' @return DiDIntObj with class "DiDIntObj"
#' @export
create_didint_object <- function(result, ccc, weighting, agg) {

  # Check if sub-aggregate results were produced
  has_sub <- "att_sub" %in% names(result)

  # Extract consistent data
  period <- result$period[1]
  start_date <- result$start_date[1]
  end_date <- result$end_date[1]
  nperm <- result$nperm[1]

  # Determine grouping variable
  group_label <- NULL
  if (agg == "sgt") {
    group_label <- paste0(result$state, ": ", result$gvar, ";", result$t)
    group_title <- "State: gvar;time"
  } else if (agg == "simple") {
    group_label <- paste0(result$gvar, ";", result$time)
    group_title <- "gvar;time"
  } else if (agg == "time") {
    group_label <- result$periods_post_treat
    group_title <- "Periods Post Treatment"
  } else if (agg == "cohort") {
    group_label <- result$treatment_time
    group_title <- "Treatment Time"
  } else if (agg == "state") {
    group_label <- result$state
    group_title <- "State"
  }

  # Determine model type
  if (ccc == "state") {
    model_type <- "State-varying DID-INT"
  } else if (ccc == "time") {
    model_type <- "Time-varying DID-INT"
  } else if (ccc == "int") {
    model_type <- "Two-way DID-INT"
  } else if (ccc == "add") {
    model_type <- "Two one-way DID-INT"
  } else if (ccc == "hom") {
    model_type <- "Homogeneous DID-INT"
  }

  # Create aggregate results dataframe
  agg_df <- data.frame(
    att = result$agg_att[1],
    se = result$se_agg_att[1],
    pval = result$pval_agg_att[1],
    ri_pval = result$ri_pval_agg_att[1],
    jknife_se = result$jknifese_agg_att[1],
    jknife_pval = result$jknifepval_agg_att[1]
  )

  # Create sub-aggregate results dataframe if available
  sub_df <- NULL
  if (has_sub && !is.null(group_label)) {
    sub_df <- data.frame(
      group = group_label,
      att = result$att_sub,
      se = result$se_att_sub,
      pval = result$pval_att_sub,
      ri_pval = result$ri_pval_att_sub,
      jknife_se = result$jknifese_att_sub,
      jknife_pval = result$jknifepval_att_sub,
      weights = result$weights,
      stringsAsFactors = FALSE
    )
    names(sub_df)[1] <- group_title
  }

  # Create object
  out <- list(
    agg = agg_df,
    sub = sub_df,

    specs = list(
      period = period,
      start_date = start_date,
      end_date = end_date,
      nperm = nperm,
      ccc = ccc,
      weighting = weighting,
      agg = agg,
      model_type = model_type
    ),

    full_results = result
  )

  class(out) <- "DiDIntObj"
  return(out)
}

#' @title Print method for \code{DiDIntObj}
#'
#' @param x A \code{DiDIntObj} object
#' @param level Specify either `"agg"` or `"sub"` to view the aggregate
#'   or sub-aggregate results.
#' @param ... other arguments
#' @export
print.DiDIntObj <- function(x, level = c("agg", "sub"), ...) {
  level <- match.arg(level)

  cat("\n")
  cat(sprintf("  Model Specification: %s\n", x$specs$model_type))
  cat(sprintf("  Aggregation: %s\n\n", x$specs$agg))

  if (level == "agg") {
    cat(sprintf("  Aggregate ATT:  %.4f\n", x$agg$att[1]))

    if (!is.null(x$sub)) {
      cat(
        sprintf(
          "\n(%d sub-aggregate estimates available via print(., level='sub'))\n",
          nrow(x$sub)
        )
      )
    }
  } else {
    if (is.null(x$sub)) {
      cat("No sub-aggregate estimates available.\n")
    } else {
      cat("Sub-Aggregate ATTs:\n")
      cat("-------------------\n")
      sub_print <- data.frame(
        Group = x$sub[[1]],
        ATT = sprintf("%.4f", x$sub$att),
        stringsAsFactors = FALSE
      )
      names(sub_print)[1] <- names(x$sub)[1]
      print(sub_print, row.names = FALSE, right = TRUE)
    }
  }

  invisible(x)
}