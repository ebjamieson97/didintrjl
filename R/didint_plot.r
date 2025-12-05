#' Make event study or parallel trends plots
#'
#' `didint_plot()` produces either event study plots or parallel trends plots
#' depending on what is specified via the `event` argument. The parallel trends
#' plots, as well as the event study plots, are created using the means
#' residualized by covariates under different model specifications that account
#' for different violations of the common causal covaraites (CCC) assumptions.
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
#' Period grids are constructed automatically, based on the inputted data
#' Otherwise, the period grid can be created manually using the arguments
#' `freq`, `freq_multiplier`, `start_date`, `end_date`. More information
#' on this process can be seen on the didintrjl documentation site:
#' https://ebjamieson97.github.io/didintrjl/.
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
#' @param treatment_times Specify the treated_states using strings, numbers,
#'   or Dates, corresponding to `treated_states`.
#'
#' @param ccc A string specifying the DID-INT specification.
#'   Any combination of `"none"`, `"hom"`, `"time"`, `"state"`, `"add"`,
#'   and `"int"`. Or, alternatively, `"all"` (default).
#' @param covariates Optional string or vector of strings specifying
#'   covariates to include.
#' @param ref Optional named list indicating the reference category for
#'   categorical covariates.
#'
#' @param event A logical value used to specify if event study plots should be
#'   made (`TRUE`) or if parallel trends plots should be made (`FALSE`).
#' @param weights A logical value,  if `TRUE`, estimates for the event study
#'   plot are computed as weighted averages of state level means for each period
#'   relative to their treatment period; if `FALSE`, uses unweighted averages.
#' @param treated_states Character values specifying the treated state(s).
#' @param ci A number between 0 and 1 used to specify the size of the confidence
#'   bands.
#' @param hc Heteroskedasticity-consistent covariance matrix estimator.
#'   One of `"hc0"`, `"hc1"`, `"hc2"`, `"hc3"`, `"hc4"`.
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
#' @returns
#' A DiDIntPlotObj.
#'
#' @examples
#' file_path <- system.file("extdata", "merit.csv", package = "didintrjl")
#' df <- utils::read.csv(file_path)
#' #didint_plot()
#'
#' @references
#' Karim & Webb (2025).
#' *Good Controls Gone Bad: Difference-in-Differences with Covariates*.
#'   \url{https://arxiv.org/abs/2412.14447}
#'
#' @importFrom JuliaConnectoR juliaSetupOk juliaImport juliaEval
#' @export
didint_plot <- function(
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
  hc = "hc3"
) {

  # Import DiDInt
  DiDInt <- .didintrjl_setup()
  didintrjl_plot <- DiDInt$didint_plot

  # If event is specified do the check for state column characters
  data[, state] <- as.character(data[, state])
  if (event == TRUE) {
    treated_states <- as.character(treated_states)
  }

  # Run the function
  df <- didintrjl_plot(
    outcome,
    state,
    time,
    data,
    gvar = gvar,
    treated_states = treated_states,
    treatment_times = treatment_times,
    date_format = date_format,
    covariates = covariates,
    ref = ref,
    ccc = ccc,
    event = event,
    weights = weights,
    ci = ci,
    freq = freq,
    freq_multiplier = freq_multiplier,
    start_date = start_date,
    end_date = end_date,
    hc = hc,
    wrapper = "r"
  )
  out <- list(data = as.data.frame(df),
              outcome = outcome)
  class(out) <- "DiDIntPlotObj"
  out
}

#' @title Plot method for \code{DiDIntPlotObj}
#'
#' @param x A \code{DiDIntPlotObj} object.
#' @param y `NULL` value passed to `plot()` method.
#' @param ccc Specify which `ccc` options you would like plotted from the data.
#'   Any combination of `"none"`, `"hom"`, `"time"`, `"state"`, `"add"`,
#'   and `"int"`. Or, alternatively, `"all"` (default).
#' @param ... other arguments
#' @importFrom ggplot2 ggplot aes geom_line geom_vline theme element_text margin
#' @importFrom ggplot2 facet_wrap scale_x_continuous labs theme_bw unit
#' @importFrom ggplot2 geom_ribbon geom_point element_blank
#' @export
plot.DiDIntPlotObj <- function(x, y = NULL, ccc = "all", ...) {

  df <- x$data
  outcome <- x$outcome

  # Make sure inputted ccc options are valid
  ccc <- tolower(trimws(ccc))
  ccc_options <- c("all", "none", "hom", "time", "state", "add", "int")
  if (!all(ccc %in% ccc_options)) {
    stop("Invalid value(s) in `ccc`. Allowed options are: ",
         paste(ccc_options, collapse = ", "))
  }

  # Do event study plot if "time_since_treatment" column exists
  if ("time_since_treatment" %in% names(df)) {

    df$se_missing <- is.na(df$se)
    df <- .plot_ccc_check(df, ccc)
    p <- ggplot2::ggplot(df, ggplot2::aes(x = time_since_treatment, y = y)) +
      ggplot2::geom_ribbon(
        data = df[!df$se_missing, ],
        ggplot2::aes(ymin = ci_lower, ymax = ci_upper),
        fill = "steelblue",
        alpha = 0.2,
        colour = NA
      ) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(
        data = df[df$se_missing, ],
        shape = 15, size = 3, colour = "black"
      ) +
      ggplot2::geom_point(
        data = df[!df$se_missing, ],
        shape = 16, size = 3, colour = "black"
      ) +
      ggplot2::geom_vline(xintercept = 0,
                          linetype = "dotted", color = "black",
                          linewidth = 0.7) +
      ggplot2::facet_wrap(~ ccc) +
      ggplot2::scale_x_continuous(
        breaks = df$time_since_treatment,
        labels = ifelse(abs(df$time_since_treatment) %% 2 == 0,
                        df$time_since_treatment, "")
      ) +
      ggplot2::labs(
        x = "Periods Relative to Treatment",
        y = paste0(outcome, " (residualized by covariates)")
      ) +
      ggplot2::theme_bw(base_size = 13) +
      ggplot2::theme(
        strip.text = ggplot2::element_text(size = 12, face = "bold"),
        panel.spacing = ggplot2::unit(1, "lines"),
        axis.text.y = ggplot2::element_text(size = 13),
        axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 12)),
        axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 12)),
        panel.grid.minor = ggplot2::element_blank(),
        panel.grid.major.x = ggplot2::element_blank()
      )

    # Otherwise do parallel trends plot
  } else {

    # Grab treated states, order ccc, drop NA rows
    treat_periods <- unique(df$treat_period[!is.na(df$treat_period)])
    df <- df[is.na(df$treat_period), ]
    df <- .plot_ccc_check(df, ccc)

    # Make plot
    p <- ggplot2::ggplot(df, ggplot2::aes(x = period, y = lambda,
                                          color = state)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_vline(xintercept = treat_periods,
                          linetype = "dotted", color = "black",
                          linewidth = 0.7) +
      ggplot2::facet_wrap(~ ccc) +
      ggplot2::scale_x_continuous(
        breaks = df$period,
        labels = ifelse(df$period %% 2 == 0, df$time, "")
      ) +
      ggplot2::labs(
        x = "Time",
        y = paste0(outcome, " (residualized by covariates)"),
        color = "State"
      ) +
      ggplot2::theme_bw(base_size = 13) +
      ggplot2::theme(
        legend.position = "bottom",
        strip.text = ggplot2::element_text(size = 12, face = "bold"),
        panel.spacing = ggplot2::unit(1, "lines"),
        axis.text.y = ggplot2::element_text(size = 13),
        axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 12)),
        axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 12)),
        legend.text = ggplot2::element_text(size = 13)
      )
  }
  p
}
