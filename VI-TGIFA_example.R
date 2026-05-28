source("VI-TGIFA_model.R")

# generate example data
set.seed(1)
example_data <- matrix(abs(rnorm(200)), nrow = 5)

# add missingness to example data coded as 0.001
example_data[4, 2] <- NA
example_data[2, 18] <- NA

# run method
cavi_res <- VI_TGIFA_model(input_data = example_data, k.star = 3,
                          n.iters_min = 5, n.iters_max = 50, tolerance = 0.01,
                          imp.iters_min = 3, imp.iters_max = 10, n_imp = 100,
                          imp_pc_tol = 0.05,
                          return_multiple = TRUE, return_params = TRUE,
                          init_imp = "half_min")


