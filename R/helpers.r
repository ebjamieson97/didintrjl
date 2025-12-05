#' @keywords internal
#' Does initial check and setup. Returns the DiDInt.jl package to R as
#' an environment.
.didintrjl_setup <- function() {
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
  JuliaConnectoR::juliaImport("DiDInt")
}

#' @keywords internal
#' Checks the ccc args and filters the data for plotting
.plot_ccc_check <- function(df, ccc) {
  if (!("all" %in% ccc)) {
    df <- df[df$ccc %in% ccc, ]
  }
  df$ccc[df$ccc == "none"] <- "No covariates"
  df$ccc[df$ccc == "hom"] <- "Homogeneous covariates"
  df$ccc[df$ccc == "state"] <- "State-varying covariates"
  df$ccc[df$ccc == "time"] <- "Time-varying covariates"
  df$ccc[df$ccc == "add"] <- "Two one-way covariates"
  df$ccc[df$ccc == "int"] <- "Two-way intersection covariates"
  df$ccc <- factor(df$ccc, levels = c("No covariates",
                                      "Homogeneous covariates",
                                      "State-varying covariates",
                                      "Time-varying covariates",
                                      "Two one-way covariates",
                                      "Two-way intersection covariates"))
  df
}