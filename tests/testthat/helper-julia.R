julia_ready <- function() {
  requireNamespace("JuliaConnectoR", quietly = TRUE) &&
    JuliaConnectoR::juliaSetupOk() &&
    JuliaConnectoR::juliaEval('using Pkg; _didint_pkgs = filter(p -> p.second.name == "DiDInt", Pkg.dependencies()); !isempty(_didint_pkgs) && first(values(_didint_pkgs)).version >= v"0.9.6"') #nolint
}