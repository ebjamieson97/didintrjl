test_that("didint_plot parallel test", {
  path <- system.file("extdata", "merit.csv", package = "didintrjl")
  df <- read.csv(path)
  df_sub <- df[df$state %in% c(71, 58, 11, 34, 14), ]
  res_parallel <- didint_plot("coll", "state", "year", df_sub,
              treatment_times = c(1991, 1993, 2000),
              covariates = c("asian", "black", "male"))
  expect_equal(!is.null(res_parallel$data), TRUE)

})

test_that("didint_plot event test", {
  path <- system.file("extdata", "merit.csv", package = "didintrjl")
  df <- read.csv(path)
  res_event <- didint_plot("coll", "state", "year", df, event = TRUE,
              treated_states = c(71, 58, 64, 59, 85, 57, 72, 61, 34, 88),
              treatment_times = c(1991, 1993, 1996, 1997, 1997, 1998, 1998, 1999, 2000, 2000),
              covariates = c("asian", "black", "male"))
  expect_equal(!is.null(res_event$data), TRUE)
})

