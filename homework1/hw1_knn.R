library(class)
library(ggplot2)

KnnClassifier <- function(seed, test.start.index, test.end.index, max.k, filename){
	 # Read data with heading row into data frame
	df <- read.table('~/GA_data_science/homework1/hw1_data_w_labels.txt', header=TRUE)
    
    # Set the randomization seed 
	set.seed(seed);
    
    # Set the number of rows in the data frame
	N<-nrow(df);
	
	# Extract the classification column 
	labels <- df$Classification

    # generate a randomization of numbers from 1-1000, constant because of input seed
	train.master <- sample(1:N, N, replace=F)
	
	#Compute the size of the training data set as a pct of the original
    train.1.pct = ((N-test.end.index+test.start.index-1)*100)/N
    
    offset.range = test.start.index:test.end.index
    #Set the randomized indices of the test set
	test.1.indices <- train.master[offset.range]
	train.1.indices <- train.master[-offset.range]
	
	#Extract the complement of the test indices from the data set and make that the training set	
	train.1.data <- df[train.1.indices, ]
	
	#Extract the test data set
	test.1.data <- df[test.1.indices, ]
	
	#Set up the output values of the train and test data sets
	 train.1.labels <- as.factor(as.matrix(labels)[train.1.indices, ]) 
	 test.1.labels <- as.factor(as.matrix(labels)[test.1.indices, ]) 
	  
	 
    #Initialize the data frame for the error rates
    err.1.rates <- data.frame()

   #Do knn!
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
	ggsave(filename)
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  

# 5 fold cross validation
KnnClassifier(81, 1, 200, 35, 'knn_pass1.pdf') #k = 12 err = 26%
KnnClassifier(81, 201, 400, 35, 'knn_pass2.pdf')  #k = 5 err = 23.5%
KnnClassifier(81, 401, 600, 35, 'knn_pass3.pdf')  #k = 11 err = 31.5%
KnnClassifier(81, 601, 800, 35, 'knn_pass4.pdf')  #k = 17 err = 21.5%
KnnClassifier(81, 801, 1000, 35, 'knn_pas5.pdf') #k = 8 err = 31.5%










