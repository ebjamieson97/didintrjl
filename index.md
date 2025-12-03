# didintrjl

## Overview

**didintrjl** is an R wrapper for the Julia package
[DiDInt.jl](https://ebjamieson97.github.io/DiDInt.jl/dev/), which
implements intersection difference-in-differences (DID-INT), a method
developed by [Karim & Webb (2025)](https://arxiv.org/abs/2412.14447).
DID-INT allows for unbiased estimation of the average effect of
treatment on the treated (ATT) in cases when the common causal
covariates (CCC) assumption is violated.

## Installation

You can install the development version of didintrjl with:

``` r
# install.packages("remotes")
remotes::install_github("ebjamieson97/didintrjl")
```

## Examples

``` r
# Load data
df <- read.csv("inst/extdata/merit.csv")

# Load didintrjl and run didint()
library(didintrjl)
res <- didint("coll", "state", "year", df,
              treated_states = c(71, 58, 64, 59, 85, 57, 72, 61, 34, 88),
              treatment_times = c(1991, 1993, 1996, 1997, 1997, 1998, 1998, 1999, 2000, 2000))
#> Starting Julia ...
#> Completed 100 of 999 permutations
#> Completed 200 of 999 permutations
#> Completed 300 of 999 permutations
#> Completed 400 of 999 permutations
#> Completed 500 of 999 permutations
#> Completed 600 of 999 permutations
#> Completed 700 of 999 permutations
#> Completed 800 of 999 permutations
#> Completed 900 of 999 permutations

# Print aggregate and then sub-aggregate results
print(res)
#> 
#>   Model Specification: Two-way DID-INT
#>   Aggregation: cohort
#> 
#>   Aggregate ATT:  0.0458
#> 
#> (7 sub-aggregate estimates available via print(., level='sub'))
print(res, level = "sub")
#> 
#>   Model Specification: Two-way DID-INT
#>   Aggregation: cohort
#> 
#> Sub-Aggregate ATTs:
#> -------------------
#>  Treatment Time     ATT
#>      1991-01-01  0.0529
#>      1993-01-01  0.0236
#>      1996-01-01  0.0564
#>      1997-01-01  0.0711
#>      1998-01-01  0.0485
#>      1999-01-01  0.0120
#>      2000-01-01 -0.0331
```
