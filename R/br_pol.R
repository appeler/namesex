#' Get Sex of Person Based on First Name Using Brazilian Politician Data
#'
#' Fetches proportion of women with that first name in brazilian politician data.
#'
#' @param names vector of names
#' 
#' @return data.frame with original list and proportion women with that name
#' @export
#' @examples 
#' br_pol(names="Antonio")
#' 

br_pol <- function(names=NULL) {
	
	# Nuke leading and trailing spaces
	c_names  <- gsub("^ *| *$", "", names)

	# Convert to lower case
	c_names  <- tolower(c_names)

	# Initialize results df
	name_sex <- data.frame(names = c_names, p_women=NA)

	# Match
	name_sex$p_women <- br_names$p_women[match(c_names, br_names$names)]

	name_sex
}
