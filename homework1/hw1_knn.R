library(class)
library(ggplot2)

myKNNClassifier <- function(seed, start.index, end.index){
	df <- read.table('~/GA_data_science/homework1/hw1_data_w_labels.txt', header=TRUE)

	set.seed(seed);

	N<-nrow(df);
	labels <- df$Classification

	train.master <- sample(1:N, N, replace=F)
    train.1.pct = ((N-end.index+start.index)*100)/N
	test.1.indices <- train.master[start.index:end.index]
	train.1.data <- df[-test.1.indices, ]
	test.1.data <- df[test.1.indices,]
	 train.1.labels <- as.factor(as.matrix(labels)[-test.1.indices, ]) 
	 test.1.labels <- as.factor(as.matrix(labels)[test.1.indices, ]) 

	 max.k <- 100
    err.1.rates <- data.frame()

	for (k in 1:max.k) {
		knn.1.fit <- knn(
      train = train.1.data,         # training set
      test = test.1.data,           # test set
    	cl = train.1.labels,          # true labels
    	k = k                       # number of NN to poll
  		)

	  # print params and confusion matrix for each value k
	  cat('\n', 'k = ', k, ', train.pct = ', train.1.pct, '\n', sep='')
	  print(table(test.1.labels, knn.1.fit))

	  # store generalization error and append to total results
	  this.1.err <- sum(test.1.labels != knn.1.fit) / length(test.1.labels)
 	 err.1.rates <- rbind(err.1.rates, this.1.err)
	}


	## OUTPUT RESULTS
	results.1 <- data.frame(1:max.k, err.1.rates)   # create results summary data frame
	names(results.1) <- c('k', 'err.1.rates')        # label columns of results df

	# create title for results plot
	title <- paste('knn results (train.pct = ',  train.1.pct, ')', sep='')

	# create results plot
	results.1.plot <- ggplot(results.1, aes(x=k, y=err.1.rates)) + geom_point() + geom_line()
	results.1.plot <- results.1.plot + ggtitle(title)

	# draw results plot

	results.1.plot
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  








