## This file contains helper functions used throughout the package
## Functions:
##           gen_features
##           ngrams

#' Generate Features for ML model of classification
#'
#' Generates features and appropriate data matrix to be used in prediction using existing models. Ignores accents for now.
#'
#' @param names vector of names
#' 
#' @return matrix that is used in our basic ML classification model
#' @export
#' @examples 
#' br_pol(names="dilma")
#' 

gen_features <- function(names=NULL) {
  
  # Nuke leading and trailing spaces, upper case and accents
  c_names  <- clean_names(names)
  
  NULL
}

#' Remove Whitespace, Accents, Uppercase
#'
#' @param names vector of names
#' 
#' @return vector of cleaned names
#' @export
#' 
clean_names <- function(names=NULL,
                        encoding="ASCII//TRANSLIT"){
  
  c_names <- tolower(gsub("^ *| *$", "", names))
  
  if(!is.null(encoding)) {
    c_names <- iconv(c_names, to = encoding)
  }
  
  return(c_names)
}