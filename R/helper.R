## This file contains helper functions used throughout the package
## Functions:
##           gen_features
##           ngrams

#' Generate Features for ML model of classification
#'
#' Do not use this unless you know exactly what it does. Use the prediction functions instead. Generates features and appropriate data matrix to be used in prediction using existing models. Ignores accents for now.
#'
#' @param names vector of names
#' 
#' @return matrix that is used in our basic ML classification model. May be have more columns than the fit model. Make sure to only keep columns found in the model.
#' @export
#' 

gen_features <- function(names=NULL) {
  
  library(dummies)
  
  # Nuke leading and trailing spaces, upper case and accents
  c_names  <- clean_names(names)
  
  # Get first and last letters
  letterDf <- data.frame(last_letter = rep(NA, length(c_names)))
  letterDf$last_letter <- substr(c_names, nchar(c_names), nchar(c_names)) 
  letterDf$first_letter <- substr(c_names, 1, 1)
  
  # Create dummy variables for letters
  letterDf <- dummy.data.frame(letterDf,
                               c("last_letter", "first_letter"),
                               omit.constants = F)

  # Get ngrams
  # First all individual letters
  # Get letters by name as a list
  letters <- lapply(c_names, function(x) ngram(x, 1))
  # Get all letters found in all names
  letterList <- unique(unlist(letters, use.names = F, recursive = F))
  # Create empty character-name matrix
  letterMat <- matrix(0, ncol = length(letterList), nrow = length(letters),
                      dimnames = list(NULL,
                                      c(letterList)))
  
  # Repeate for bigrams
  bigrams <- lapply(c_names, function(x) ngram(x, 2))
  bigramList <- unique(unlist(bigrams, use.names = F, recursive = F))
  bigramMat <- matrix(0, ncol = length(bigramList), nrow = length(bigrams),
                      dimnames = list(NULL,
                                      c(bigramList)))

  # fill out uni and bigrams
  for(i in 1:length(bigrams)) {
    # get characters/bigrams and counts of their appearance
    gramTab <- table(bigrams[[i]])
    letterTab <- table(letters[[i]])
    
    letterMat[i, names(letterTab)] <- letterTab
    bigramMat[i, names(gramTab)] <- gramTab 
  }

  # Design matrix is first and last letters, counts of any letter, and bigrams
  X <- as.matrix(cbind(letterDf, letterMat, bigramMat))
  
  return(X)
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

#' Generates ngrams of characters
#' 
#' @param string string to be chunked
#' @param n 'n'-grams to generate
#' 
#' @return character vector of all ngrans
#' @export
#' 
ngram <- function(xs, n = 2) {
  if (nchar(xs) >= n) {
    c(substr(xs, 1, n), ngram(substr(xs, 2, nchar(xs)), n))
  }
}