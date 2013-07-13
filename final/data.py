import csv
import math
import numpy as np
from sklearn import svm, datasets
from sklearn.metrics import confusion_matrix

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

    results = replaceSymbols(results)
    return results

def classToDeck(pclass):
    #print "Price is " 
    #print price
    if(pclass == 1):
        return "C"

    if(pclass == 2):
        return "D"

    return "G"

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


def replaceSymbols(dataOrig):
    data = dataOrig
    print data
    for row in data:
        for index, items in enumerate(row):
            if(index == 0):
                row[index] = 0
            if(index == 5):
                print "age: " + str(items)
                if(math.isnan(items)):
                    row[index] = 25
            if(items == "male"):
                row[index] = 0
            if(items == "female"):
                row[index] = 1
            elif(index == 8):
                row[index] = 0
            elif(index == 10):
 #               print "Value at index 10" + str(items)
                if(items == ""):
                    row[index] = DeckToInt(classToDeck(row[2]));
                else:
                    row[index] = DeckToInt(row[10]);
            elif(index == 11):
                row[index] = portToNum(row[index])

#    print "Massaged data" + str(data)

    return data


def create_data_and_outputs(input, dataIndices, resulIndex):
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

            
results = create_csv2('titanic_train.csv', -1)
# Create first round of parsed results
# print results

#results = replaceSymbols(results)
#print results

dataIndices = set([2,4,5,6,7,8,9,10,11])
resultIndex = 1
#Appropriately format the text into data and columns

#Created data!
(data, target) = create_data_and_outputs(results, dataIndices ,resultIndex)
print "Data is " + str(data)
print "Target is " + str(target)

mysvm = svm.SVC().fit(data, target)
mysvm_pred = mysvm.predict(data)
print confusion_matrix(mysvm_pred, target)

