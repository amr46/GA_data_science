library(class)
Year <- c(1959, 1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969)
Population <- c(4835, 4970, 5085, 5160, 5310, 5260, 5235, 5255, 5235, 5210, 5175)

sample1 <- data.frame(Year, Population)
sample1


sample1$Year <- sample1$Year - 1964
sample1


plot(sample1$Year, sample1$Population, type="b")



fit1 <- lm(sample1$Population ~ sample1$Year)
fit2 <- lm(sample1$Population ~ sample1$Year + I(sample1$Year^2))
fit3 <- lm(sample1$Population ~ sample1$Year + I(sample1$Year^2) + I(sample1$Year^3))

# Pay particular attention to this one!
fit4 <- lm(sample1$Population ~ sample1$Year + I(sample1$Year^3))

summary(fit2)
summary(fit3)
summary(fit4)

plot(sample1$Year, sample1$Population, type="l", lwd=3)
points(sample1$Year, predict(fit2), type="l", col="red", lwd=2)
points(sample1$Year, predict(fit3), type="l", col="blue", lwd=2)
points(sample1$Year, predict(fit4), type="l", col="green", lwd=2)

# what is going on with fit4? Can you explain why it looks so different from fit2 and fit3?

# Answer:
# There's one polynomial coefficient missing, specifically x sample1$Year^2
# This is not a correct poly function. 
# The p value is much larger indicating a much worse fit
# There is no good variable that the fit corresponds to
