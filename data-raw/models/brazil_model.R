## This file trains a simple lasso model on the brazilian name data used to predict sex



library(dummies)
library(glmnet)
library(namesex)

# Load data
data("brazilian_pols", package = "namesexdata")

#  Aggregate data with no accents
bn <- aggregate(brazilian_pols[c('total_found')],
                by=brazilian_pols['first_name_noaccent'],
                sum)

# Merge back in pr no accent
bn <- merge(bn,
            brazilian_pols[!duplicated(brazilian_pols$first_name_noaccent),
                           c("first_name_noaccent", "pr_women_noaccent")],
            by = "first_name_noaccent")

# Drop rows that are missing proportions
bn <- bn[!is.na(bn$pr_women_noaccent), ]

# Trim hyphens and question marks (I think from bad encoding on my part)
bn$first_name_noaccent <- gsub("-", "", gsub("\\?", "", bn$first_name_noaccent))

# Design matrix is first and last letters, counts of any letter, and bigrams
X <- gen_features(bn$first_name_noaccent)
colnames(X)
colSums(X)
head(X)

# Trim some bigrams to improve speed
Xtrim <- X[, (nchar(colnames(X)) < 2 | nchar(colnames(X)) > 3 | colSums(X) > 500)]

# Outcome is matrix with proportions and "level" of outcome (female=1)
y <- as.matrix(cbind(bn[, "pr_women_noaccent"], rep(1, nrow(bn))))
# Weights are total counts
w <- bn[, "total_found"]

set.seed(20160720)
cvg <- cv.glmnet(x = Xtrim, y = y, weights = w,
                 family = "binomial",
                 nfolds = 5,
                 nlambda = 20)
plot(cvg)

# Not stochastic, don't need seed
brazil_lasso_model <- glmnet(x = Xtrim, y = y, weights = w,
                             family = "binomial",
                             lambda = cvg$lambda.min)

devtools::use_data(brazil_lasso_model, overwrite = T)
