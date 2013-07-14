import csv
import math
import numpy as np
from sklearn import svm, datasets
from sklearn.metrics import confusion_matrix
from sklearn.naive_bayes import GaussianNB


def create_csv(csvFileName, numRows):
    results = []
    with open(csvFileName, 'rb') as csvfile:
        reader=csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_NONNUMERIC)
        for row in reader:
            results.append(list(row))
            count = count +1
            if(numRows == count):
                break;                           
    return results

def create_csv2(csvFileName, numRows):
    temp = []
    results = []
    temp = np.genfromtxt(csvFileName, dtype=None, delimiter=',', names=True, usemask=False)

    count = 0;
    for row in temp:       
        results.append(list(row))
        count = count+1
        if(count == numRows):
            break

    results = replaceSymbols(results, False)
    return results

def classToDeck(pclass):
    #print "Price is " 
    #print price
    if(pclass == 1):
        return "C"

    if(pclass == 2):
        return "D"

    return "G"

def classToPrice(pclass):
    if(pclass == 1):
        return 23.0

    if(pclass == 2):
        return 14.0

    return 7.0

def portToNum(port):
    if(port == "C"):
        return 0
    if(port == "Q"):
        return 1
    if(port == "S"):
        return 2

    return 2
    

def DeckToInt(deck):
#    print "Deck is " + str(deck)
    if "C" in deck:
        return 3
    if "A" in deck:
        return 1
    if "B" in deck:
        return 2
    if "D" in deck:
        return 4
    if "E" in deck:
        return 5
    if "F" in deck:
        return 6
    
    return 7


def replaceSymbols(dataOrig, isTest):
    data = dataOrig
    offset = 0
    if(isTest):
        offset = 1;

    for row in data:
        for index, items in enumerate(row):
            if(index == 5-offset):
                #print "age: " + str(items)
                if(math.isnan(items)):
                    row[index] = 25
            if(items == "male"):
                row[index] = 0
            if(items == "female"):
                row[index] = 1
            elif(index == 8-offset):
                row[index] = 0
            elif(index == 9-offset):
                row[index] = classToPrice(row[2-offset])
            elif(index == 10-offset):
 #               print "Value at index 10" + str(items)
                if(items == ""):
                    row[index] = DeckToInt(classToDeck(row[2-offset]))
                else:
                    row[index] = DeckToInt(row[10-offset]);
            elif(index == 11-offset):
                row[index] = portToNum(row[index])

#    print "Massaged data" + str(data)

    return data


def create_data_and_outputs(input, dataIndices, resultIndex):
    data = []
    values = []
    
    for trow in input:
        #print trow
        row = list(trow)
        #print row
        newrow=[]
        for index, item in enumerate(row):
            if(index in dataIndices):
                newrow.append(item)

            if(index == resultIndex):
                values.append(item)

        data.append(newrow)

    return (data, values)

def runGNB(train_data, test_data, dataIndices, resultindex):
    gnb = GaussianNB()

    (train_data_points, train_target_points) = create_data_and_outputs(train_data, dataIndices ,resultIndex)
    (test_data_points, test_target_points) = create_data_and_outputs(test_data, dataIndices, resultIndex)

    gnb_pred = gnb.fit(train_data_points, train_target_points).predict(test_data_points)
    error_matrix =  confusion_matrix(gnb_pred, test_target_points)

    total_correct = float(error_matrix[0][0] + error_matrix[1][1])
    total_wrong = float(error_matrix[0][1] + error_matrix[1][0])

    pct_accuracy = total_correct*100.0/(total_correct+total_wrong)
    return pct_accuracy
    

def runSVM(train_data, test_data, dataIndices, resultindex):
    (train_data_points, train_target_points) = create_data_and_outputs(train_data, dataIndices ,resultIndex)

    mysvm = svm.SVC().fit(train_data_points, train_target_points)
    
    (test_data_points, test_target_points) = create_data_and_outputs(test_data, dataIndices, resultIndex)
        
    mysvm_pred = mysvm.predict(test_data_points)
    error_matrix =  confusion_matrix(mysvm_pred, test_target_points)

    total_correct = float(error_matrix[0][0] + error_matrix[1][1])
    total_wrong = float(error_matrix[0][1] + error_matrix[1][0])

    pct_accuracy = total_correct*100.0/(total_correct+total_wrong)
    return pct_accuracy

train_data  = create_csv2('titanic_train.csv', -1)
test_data   = create_csv2('titanic_test.csv', -1)
resultIndex = 1

"""
All SVM Tests 
"""
# Social Class, Sex And Age
dataIndices = set([2,4,5])
pct_acc = runSVM(train_data, test_data, dataIndices, resultIndex)
print "SVM Pct Accuracy (Class, Sex and Age) " + str(pct_acc)

# Sex and Age
dataIndices = set([4,5])
pct_acc = runSVM(train_data, test_data, dataIndices, resultIndex)
print "SVM Pct Accuracy (Sex and Age) " + str(pct_acc)

# Sex
dataIndices = set([4])
pct_acc = runSVM(train_data, test_data, dataIndices, resultIndex)
print "SVM Pct Accuracy (Sex) " + str(pct_acc)

# Cabin, Sex And Age
dataIndices = set([2,4,5,6,7,8,9,10,11])
pct_acc = runSVM(train_data, test_data, dataIndices, resultIndex)
print "SVM Pct Accuracy (All attributes) " + str(pct_acc)

"""
All Gaussian Naive Bayes tests
"""
# Social Class, Sex And Age
dataIndices = set([2,4,5])
pct_acc = runGNB(train_data, test_data, dataIndices, resultIndex)
print "GNB Pct Accuracy (Class, Sex and Age) " + str(pct_acc)

# Sex and Age
dataIndices = set([4,5])
pct_acc = runGNB(train_data, test_data, dataIndices, resultIndex)
print "GNB Pct Accuracy (Sex and Age) " + str(pct_acc)

# Sex
dataIndices = set([4])
pct_acc = runGNB(train_data, test_data, dataIndices, resultIndex)
print "GNB Pct Accuracy (Sex) " + str(pct_acc)

# All Attributes
dataIndices = set([2,4,5,6,7,8,9,10,11])
pct_acc = runGNB(train_data, test_data, dataIndices, resultIndex)
print "GNB Pct Accuracy (All attributes) " + str(pct_acc)

# Create first round of parsed results
# print results

#results = replaceSymbols(results)
#print results

#All data
#dataIndices = set([2,4,5,6,7,8,9,10,11])

#Class, Age and Sex
#dataIndices = set([5])
#resultIndex = 1
#Appropriately format the text into data and columns

#Created data!

#(data, target) = create_data_and_outputs(results, dataIndices ,resultIndex)

#mysvm = svm.SVC().fit(data, target)

#test_results = create_csv2('titanic_test.csv', -1)

#(test_data, test_target) = create_data_and_outputs(test_results, dataIndices, resultIndex)

#print "Data" + str(test_data)
#print "Target" + str(test_target)

#mysvm_pred = mysvm.predict(test_data)
#error_matrix =  confusion_matrix(mysvm_pred, test_target)
#total_correct = float(error_matrix[0][0] + error_matrix[1][1])
#total_wrong = float(error_matrix[0][1] + error_matrix[1][0])

#print "Percent Accuracy = " + str(total_correct*100.0/(total_correct+total_wrong)) + "%"







