#' didintrjl: Intersection Difference-in-Differences
#'
#' @description
#' An R wrapper for the Julia package \pkg{DiDInt.jl}, implementing
#' intersection difference-in-differences (DID-INT).
#'
#' @details
#' Implements intersection difference-in-differences (DID-INT), a method
#' developed by Karim and Webb (2025) that allows for unbiased estimation
#' of the average effect of treatment on the treated (ATT) in settings
#' where the common causal covariates (CCC) assumption is violated.
#' Supports common or staggered adoption and the inclusion of covariates whose
#' effects on the outcome of interest may vary by state, time, or both.
#' The package interfaces with the Julia package \pkg{DiDInt.jl} via
#' \pkg{JuliaConnectoR}.
#'
#'
#' @section Estimation:
#' \itemize{
#'   \item \code{\link{didint}} - Estimates the ATT, returning a
#'   \code{DiDIntObj} with \code{print()}, \code{summary()}, and
#'   \code{coef()} methods.
#' }
#'
#' @section Plotting:
#' \itemize{
#'   \item \code{\link{didint_plot}} - Produces parallel trends or event
#'   study plots, returning a \code{DiDIntPlotObj} with a \code{plot()}
#'   method.
#' }
#'
#' @author Eric B. Jamieson
#'
#' @keywords internal
"_PACKAGE"
## usethis namespace: start
## usethis namespace: end
NULL