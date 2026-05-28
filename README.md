
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VI-TGIFA

The VI-TGIFA R package presents a set of functions that perform missing
data imputation using a truncated Gaussian infinite factor analysis
model designed for high-dimensional metabolomics data, with variational
inference used for inference.

## Installation

You can access VI-TGIFA by downloading the code from this repository.
You should ensure that you have the VIMSFA R package installed in order
to use VI-TGIFA. This package can be installed as follows:

``` r
# install remotes package if not already installed
# install.packages("remotes")
remotes::install_github("blhansen/VI-MSFA")
```

## Example imputation

To illustrate the VI-TGIFA functionality, here a test dataset is
generated with two missing values.

``` r
# source the relevant script
source("VI-TGIFA_model.R")

# generate example data
set.seed(1)
example_data <- matrix(abs(rnorm(200)), nrow = 5)

# add missingness to example data coded as NA
example_data[4, 2] <- NA
example_data[2, 18] <- NA
```

This example data can then be passed into the `VI_TGIFA_model()`
function which contains all functionality. Here, `input_data` is the
dataset with missing values, in matrix format. The `coding` argument
refers to how the missing values are coded. If your missing values all
have a value of `NA`, for example, you should input `coding = NA`. Here,
the value `k.star = 3` refers to the practical non-infinite number of
latent factors used by the VI-TGIFA model; usually this defaults to
`k.star = 5` but for this small example dataset we will use a smaller
number.

``` r
# run VI-TGIFA method
res <- VI_TGIFA_model(input_data = example_data, k.star = 3,
                     n.iters_min = 5, n.iters_max = 50)
```

The results of the VI-TGIFA imputation can be accessed as follows.

``` r
# checkout imputed dataset
res$imputed_dataset

# checkout further information on imputed entries
res$imputation_info
```

The input dataset, with missing values imputed according to the VI-TGIFA
imputation method is contained in `res$imputed_dataset` in matrix
format. Details on the imputation can be accessed from
`res$imputation_info`. This is a dataframe with number of rows equal to
the number of missing values in the dataset, and seven columns. The
`entry_row` and `entry_col` columns contain the row and column index of
each missing value in the input dataset. The `imputed_val` column
contains the imputed value, and `cred_int_upper` and `cred_int_lower`
contain the upper and lower limits of the 95% credible interval for the
imputed point. Finally, the `miss_mech` column gives the final inferred
missingness type of each point, with `miss_mech_unc` providing the
corresponding uncertainty.

If one wishes to change the hyperparameters of the VI-TGIFA model from
their defaults, this can be done as follows. Argument details are:
`n.iters_min` is the minimum number of CAVI iterations to perform;
`n.iters_max` is the maximum number of CAVI iterations to perform;
`tolerance` is the convergence tolerance for the CAVI algorithm;
`imp.iters_min` is the minimum number of imputation iterations to
perform; `imp.iters_max` is the maximum number of imputation iterations
to perform; `n_imp` is the number of imputations to perform per
iteration; `imp_pc_tol` is the convergence tolerance for imputation;
`return_multiple` indicates if all of the imputed datasets from the
final imputation iteration should be returned; `return_params` indicates
if the final model variational parameters should be returned; `init_imp`
is the imputation method used for initial imputation in the algorithm.
The remaining parameters, `kappa_1`, `kappa_2`, `a_sigma`, `b_sigma`,
`a_1`, and `a_2` are hyperparameters of the VI-TGIFA model.

``` r
res <- VI_TGIFA_model(input_data = example_data, k.star = 3,
                     n.iters_min = 5, n.iters_max = 50, tolerance = 0.01,
                     imp.iters_min = 3, imp.iters_max = 10, n_imp = 100,
                     imp_pc_tol = 0.05,
                     kappa_1 = 3L, kappa_2 = 2L,
                     a_sigma = 1L, b_sigma = 0.25, a_1 = 2.1, a_2 = 3.1,
                     return_multiple = TRUE, return_params = TRUE,
                     init_imp = "half_min")
```
