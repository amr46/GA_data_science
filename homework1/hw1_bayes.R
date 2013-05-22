library(e1071)
# classifier<-naiveBayes(iris[,1:4], iris[,5]) 
# table(predict(classifier, iris[,-5]), iris[,5], dnn=list('predicted','actual'))


BayesClassifier <- function(seed, test.start.index, test.end.index ){
    df <- read.table('~/GA_data_science/homework1/hw1_data_w_labels.txt', header=TRUE)
        
    # Set the randomization seed 
	set.seed(seed);
    
    # Set the number of rows in the data frame
	N<-nrow(df);
	
    # generate a randomization of numbers from 1-1000, constant because of input seed
	train.master <- sample(1:N, N, replace=F)
	
	#Compute the size of the training data set as a pct of the original
    train.1.pct = ((N-test.end.index+test.start.index-1)*100)/N
    
    #Set the randomized indices of the test set
    offset.range = test.start.index:test.end.index
	test.1.indices <- train.master[offset.range]
	train.1.indices <- train.master[-offset.range];	
	
	classifier<-naiveBayes(df[train.1.indices, -25], as.factor(df[train.1.indices, 25]));
	
	result.table <- table(predict(classifier, df[test.1.indices, -25]), df[test.1.indices,25], dnn=list('predicted','actual'))
	result.table
}

BayesClassifier(81, 1, 200)

