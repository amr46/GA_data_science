library(class)
library(e1071)
# classifier<-naiveBayes(iris[,1:4], iris[,5]) 
# table(predict(classifier, iris[,-5]), iris[,5], dnn=list('predicted','actual'))


BayesClassifier <- function(seed, test.start.index, test.end.index){
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
# # # # # # # # # BEGIN 10-fold cross validation results # # # # # # # # # 

#> BayesClassifier(4321, 1, 100)
#         actual
#predicted  1  2
        1 48  9
        2 24 19
#> BayesClassifier(4321, 101, 200)
#         actual
#predicted  1  2
        1 62 11
        2 13 14
#> BayesClassifier(4321, 201, 300)
         actual
#predicted  1  2
#        1 48 10
#        2 20 22
#> BayesClassifier(4321, 301, 400)
#         actual
#predicted  1  2
#        1 59  9
#        2 15 17
#> BayesClassifier(4321, 401, 500)
#         actual
#predicted  1  2
#        1 56 12
#        2 11 21
#> BayesClassifier(4321, 501, 600)
#         actual
#predicted  1  2
#        1 54 12
#        2 13 21
#> BayesClassifier(4321, 601, 700)
#         actual
#predicted  1  2
#        1 61  8
#        2 15 16
#> BayesClassifier(4321, 701, 800)
#         actual
#predicted  1  2
#        1 55 10
#        2 18 17
#> BayesClassifier(4321, 801, 900)
#         actual
#predicted  1  2
#        1 54 20
#        2 12 14
#> BayesClassifier(4321, 901, 1000)
#         actual
#predicted  1  2
        1 46 20
        2 16 18

# Average error for 10-fold cross validation = 27.8%

# # # # # # # # # END 10-fold cross validation results # # # # # # # # # 

# # # # # # # # # BEGIN 5-fold cross validation results # # # # # # # # # 

BayesClassifier(81, 1, 200)
#         actual
#predicted   1   2
#        1 107  31
#        2  35  27
# error = 66/200

BayesClassifier(81, 201, 400)
#         actual
#predicted   1   2
#        1 115  20
#        2  29  36
#  error = 49/200

BayesClassifier(81, 401, 600)
         actual
#predicted   1   2
#        1 109  28
#        2  22  41
# error = 50/200

BayesClassifier(81, 601, 800)
#         actual
#predicted   1   2
#        1 122  16
#        2  29  33
# error = 45/200

BayesClassifier(81, 801, 1000)
#         actual
#predicted  1  2
#        1 96 26
#        2 36 42
# error = 62/200

# 5-fold cross validation for a test set = 20% of overall data set
# average error = 27.2 %

# # # # # # # # # END 5-fold cross validation results # # # # # # # # # 

# # # # # # # # # BEGIN 3-fold cross validation results # # # # # # # # # 

# 3-fold cross validation

BayesClassifier(4321, 1, 333)
#         actual
#predicted   1   2
#        1 176  32
#        2  62  63
# average error = 95/333

BayesClassifier(4321, 334, 667)
#         actual
#predicted   1   2
#        1 180  34
#        2  56  64
# average error = 90/333

BayesClassifier(4321, 668, 1000)
#         actual
#predicted   1   2
#        1 178  57
#        2  48  50
# average error = 105/333         

# average error 3 Fold cross validation = 29.029% error
# # # # # # # # # END 3-fold cross validation results # # # # # # # # # 

# # # # # # # # # BEGIN 2-fold cross validation results # # # # # # # # # 
         
BayesClassifier(4321, 1, 500)
#          actual
# predicted   1   2
#         1 245  44
#         2 111 100

# error = 155/500

BayesClassifier(4321, 501, 1000)
#          actual
# predicted   1   2
#         1 264  75
#         2  80  81
         
# error = 155/500

# Average error 2-fold cross validation = 31%
# # # # # # # # # END 2-fold cross validation results # # # # # # # # # 

bayes_results <-  read.table('~/GA_data_science/homework1/hw1_bayes_results.txt', header=TRUE)
ggplot(bayes_results, aes(x=N, y=Error)) + geom_point() + geom_line()
ggsave("bayes_results.pdf");

# The above plot shows us the bayes error changes with different N for cross validation 

