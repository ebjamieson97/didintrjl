test_that("didint test", {
  df <- read.csv(test_path("../inst/extdata/merit.csv"))
  res <- didint("coll", "state", "year", df, verbose = FALSE,
                treated_states = c(71, 58, 64, 59, 85, 57, 72, 61, 34, 88),
                treatment_times = c(1991, 1993, 1996, 1997, 1997,
                                    1998, 1998, 1999, 2000, 2000))
  expect_equal(coef(res), 0.04582252, tolerance = 1e-6)
})