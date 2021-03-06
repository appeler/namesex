#' Get Sex of Person Based on First Name Using Brazilian Politician Data
#'
#' Fetches proportion of women with that first name in brazilian politician data.
#'
#' @param names vector of names
#' @param matchAccent boolean for whether to match accent. Not matching on accent may be slower.
#' 
#' @return data.frame with original list and proportion women with that name
#' @export
#' @examples 
#' br_pol(names="Antonio")
#' 

br_pol <- function(names=NULL, matchAccent = TRUE) {
  
  # Load brazilian data
  data("brazilian_pols", package = "namesexdata", envir = environment())
  
	# Nuke leading and trailing spaces and upper case
	c_names  <- clean_names(names, encoding = NULL)
  
	# Remove accents if matchAccent == FALSE
	if (!matchAccent) {
	  c_names <- iconv(c_names, to = "ASCII//TRANSLIT")
	  brazilian_pols$pr_women <- brazilian_pols$pr_women_noaccent
	  brazilian_pols$first_name <- brazilian_pols$first_name_noaccent
	}
	
	# Initialize results df
	name_sex <- data.frame(names = c_names, pr_women=NA)

  # Match
	name_sex$pr_women <- brazilian_pols$pr_women[match(c_names, brazilian_pols$first_name)]
	
	name_sex
}
