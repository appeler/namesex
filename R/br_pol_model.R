#' Get Sex of Person Based on Model Trained on Brazilian Politicians
#'
#' Get predicted sex of a Portuguese name based on a model trained on a dataset
#' of brazilian politicians. This model uses character counts, first and last
#' characters, and bigrams. Note the predictions favor men as most of the
#' database of politician's are men. With weak prediction the model favors
#' just guessing male.
#'
#' @param names vector of names
#' 
#' @return data.frame with original list and proportion women with that name
#' @export
#' @examples 
#' br_pol_model(names="Antonio")
#' 
br_pol_model <- function(names = NULL) {
  library(glmnet)
  data("brazil_lasso_model", envir = environment())
  
  c_names <- clean_names(names)
  
  newX <- gen_features(c_names)

  datX <- matrix(0, nrow = length(c_names), ncol = nrow(brazil_lasso_model$beta),
                 dimnames = list(NULL, brazil_lasso_model$beta@Dimnames[[1]]))
  datX[, intersect(colnames(newX), colnames(datX))] <- newX[, intersect(colnames(newX), colnames(datX))]               

  # Initialize results df
  name_sex <- data.frame(names = c_names, pr_women=NA)
  
  name_sex$pr_women <- unname(1 - predict(brazil_lasso_model, datX, type = "response"))
  
  name_sex
}