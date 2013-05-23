library(class)
library(ggplot2)

# Construct a linear model of the data to see correlations if any

df <- read.table('~/GA_data_science/homework1/hw1_data_w_labels.txt', header=TRUE)
fit.1 <- lm(Classification ~ . , data=df);


fit.2 <- lm(Classification ~ Status_of_existing_checking_account. , data=df);

plot(x)
pdf(file='~/GA_data_science/homework1/residuals2.pdf')
plot(x)
dev.off()