# install and load library DMwR
install.packages('DMwR')
library(DMwR)

# load data block algae
data(algae)

# get summary data for the data frame loaded
summary(algae)

# generate a histogram of column mxPH, probability densities are turned on
hist(algae$mxPH, prob = T)

# plot column NH4, no label on x axis
plot(algae$NH4, xlab = '')

# plot a horizontal line throught the mean value of NH4
abline(h = mean(algae$NH4, na.rm = T), lty = 1)  
# Plot a solid horizontal line through mean ,and a dotted horizontal
# line through the standard deviation
abline(h = mean(algae$NH4, na.rm = T) + sd(algae$NH4, na.rm = T), lty = 2)
abline(h = median(algae$NH4, na.rm = T), lty = 3)  

# construct a linear model for PO4 vs oPO4 using data set algae 
lm(PO4 ~ oPO4, data = algae)

# Run knn using 10 nearest neighbors and store in clean.algae
clean.algae <- knnImputation(algae, k = 10)

# construct a linear model of a1 vs the knn output from above step
lm.a1 <- lm(a1 ~ ., data = clean.algae[, 1:12])

# print summary of above model
summary(lm.a1)

# Analyze variance of above model
anova(lm.a1)

# Rerun model, remove season variable and print summary and analysis of variance
lm2.a1 <- update(lm.a1, . ~ . - season)
summary(lm2.a1)
anova(lm.a1, lm2.a1)

# Stepwise algorithm...not entirely sure what this is doing...
final.lm <- step(lm.a1)
