# DiDIntObj

Objects of this class store all of the results for a given set of
aggregation, weighting, and ccc options.

## Usage

``` r
create_didint_object(result, ccc, weighting, agg)
```

## Arguments

- result:

  DataFrame of results from DiDInt.jl

- ccc:

  The specified CCC variation of DID-INT that was used.

- weighting:

  The weighting method that was used.

- agg:

  The aggregation method that was used.

## Value

DiDIntObj with class "DiDIntObj"
