#_________________________________________________________
# Βάσεις Δεδομένων και εξόρυξη Γνώσης - Χειμερινό Εξ. 2017
# Εργασία Εξαμήνου - Ταξινόμηση - Classification
# Όνομα : Κατσικαβέλας Ιωάννης | ΑΜ: 361 | e-mail: ioankats93@gmail.com
#_________________________________________________________

#----------------------------------------------------------------
# 1. Load Data and libraries
#----------------------------------------------------------------
rm(list=ls(all= TRUE ))
# setting working directory
#macPath <- "/Users/ioanniskatsikavelas/Desktop/dataset"
linuxPath <- "/home/ioannis/Desktop/DM&DB/dataset"

setwd(linuxPath)
cat("You have set the PATH to :", setwd(linuxPath), "\n\n")

#load libraries
library('ggplot2')    #
library('ggthemes')   #
library('scales')     #
library('gridExtra')  # Visualization
library('earth')      #
library('Boruta')     #
library('ROCR')       #

library('dplyr')       # data manupulation
library('corrplot')    # data manupulation
library('mice')        # imputation
library('nnet')        # Neural Network
library('neuralnet')   # Neural Network
library('rpart')       # Trees
library('randomForest')# Random Forest
library('kernlab')     # SVM
library('e1071')       #
library('mlbench')     #
library('caret')       #
library('reshape')     #
library('class')       #
library('MLmetrics')   #

#load data
train <- read.csv(file="source-code-metrics_train.csv", header=TRUE, sep=";", fill=TRUE,
                  quote = "\"", dec=".", comment.char="")
bugs <- read.csv(file="bugs_train.csv", header=T, sep=";", fill=TRUE,
                  quote = "\"", dec=".", comment.char="")

bugs <- bugs[,2]
train <- cbind(train, bugs)
train <- train[-1]

test <- read.csv(file="source-code-metrics_test.csv", header=TRUE, sep=";", fill=TRUE,
                  quote = "\"", dec=".", comment.char="")
temp <- test[1]

output <- read.csv(file="bugs_train.csv",header = T, sep=";", fill=T,
                  quote = "\"", dec=".", comment.char="")

#----------------------------------------------------------------
# 2. Check and Clean The Data
#----------------------------------------------------------------
str(train)

# Check for NAs
x <- table(complete.cases(train))

# ONLY FOR THE REPORT - EXAMPLE WITHOUT NORMALIZATION
#cat("\n#########################################################################\n")
#cat("Train summary:\n")
#sumT <- summary(train)
#print(sumT)

#Normalization
normalize <- function(x){
              return((x-min(x))/(max(x) - min(x)))
}
normTrain <- as.data.frame(lapply(train[1:18], normalize))

cat("\n#########################################################################\n")
cat("Train summary with Normalization:\n")
#sumT <- summary(normTrain)
#print(sumT)
str(normTrain)

# 75% of the training size
set.seed(1234)
sz <- round(0.75 * dim(normTrain)[1])
training_set <- normTrain[1:sz,]
testing_set <- normTrain[-(1:sz),]

training_set_nn <- training_set
testing_set_nn <- testing_set

#----------------------------------------------------------------
# 2. Check variables and correlations  - Continuous Variables
#----------------------------------------------------------------
set.seed(100)
bugs.cor <- cor(training_set)
corrplot(bugs.cor, method="ellipse")

training_set$bugs <- factor(training_set$bugs, levels = c(0, 1), labels = c("No bugs", "Bugs"))
testing_set$bugs <- factor(testing_set$bugs, levels = c(0, 1), labels = c("No bugs", "Bugs"))

train[1:17] <- lapply(train[1:17], as.numeric)
train$bugs <- factor(train$bugs, levels = c(0, 1), labels = c("No bugs", "Bugs"))

# Feature Selection With lvq
#control <- trainControl(method='repeatedcv', number = 10, repeats = 3)
#model <- train(bugs~., data=train, method="lvq", preProcess="scale", trControl=control)
#importance <- varImp(model, scale = F)
#print(plot(importance))
#
#model <- 'bugs ~ wmc + numberOfLinesOfCode + fanOut + rfc + cbo + lcom +
#          numberOfMethods + numberOfAttributes + numberOfPrivateMethods +
#          numberOfPublicMethods + numberOfPublicAttributes+numberOfPublicMethods +
#          fanIn + noc + numberOfAttributesInherited'
#f <- as.formula(model)

# Feature Selection
library('FSelector')
subset <-cfs(bugs ~., train)
fs <- as.simple.formula(subset, "bugs")
print(fs)

#----------------------------------------------------------------
# 3. Model Fittings
#----------------------------------------------------------------

#----------------------------------------------------------------
# 3.1 Model Fittings - Full data
#----------------------------------------------------------------
#cross val for every model
trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

# Simple Neural Network
set.seed(1234)
cat("\nComputing Neural Network - Full data...\n")
nn_fit <- train(bugs ~., data = train, method = "nnet")
nnf <- predict(nn_fit, newdata = train)

# Tree
cat("\nComputing Tree - Full data...\n")
tree_fit <- train(bugs ~., data = train, method = "rpart",
                   trControl=trctrl,
                   tuneLength = 10,
                   parms=list(split='information'))
treef <- predict(tree_fit, newdata = train)

# Random Forest
cat("\nComputing Random Forest - Full data...\n")
rf_fit <- train(bugs ~., data = train, method = "rf",
                   trControl=trctrl,
                   tuneLength = 10)
rff <- predict(rf_fit, newdata = train)

# KNN
cat("\nComputing KNN - Full data...\n")
knn_fit <- train(bugs ~ ., data = train, method="knn",
                tuneLength = 15,
                trControl = trctrl,
                 preProc = c("center", "scale"))
knnf <- predict(knn_fit, newdata = train)

# Naive Bayes
cat("\nComputing Naive Bayes - Full data...\n")
nb_fit <- train(bugs ~ ., data = train, method="nb",
                tuneLength = 15,
                trControl = trctrl,
                preProc = c("center", "scale"))
nbf <- predict(nb_fit, newdata = train)

# Support Vector Machines
cat("\nComputing SVMs - Full data...\n")
svm_fit <- train(bugs ~ ., data = train, method="svmLinear",
                tuneLength = 15,
                trControl = trctrl,
                preProc = c("center", "scale"))
svmf <- predict(svm_fit, newdata = train)


#----------------------------------------------------------------
# 3.2 Model Fittings - With Feature Selection
#----------------------------------------------------------------
#cross val for every model
trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

# Simple Neural Network
set.seed(1234)
cat("\nComputing Neural Network...\n")
nn_fit1 <- train(bugs ~ cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                rfc + wmc, data = train, method = "nnet")
nn <- predict(nn_fit1, newdata = train)

# Tree
cat("\nComputing Tree...\n")
tree_fit1 <- train(bugs ~cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                  rfc + wmc, data = train, method = "rpart",
                   trControl=trctrl,
                   tuneLength = 10,
                   parms=list(split='information'))
tree <- predict(tree_fit1, newdata = train)

# Random Forest
cat("\nComputing Random Forest...\n")
rf_fit1 <- train(bugs ~cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                rfc + wmc, data = train, method = "rf",
                   trControl=trctrl,
                   tuneLength = 10)
rf <- predict(rf_fit1, newdata = train)

# KNN
cat("\nComputing KNN...\n")
knn_fit1 <- train(bugs ~ cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                rfc + wmc, data = train, method="knn",
                tuneLength = 15,
                trControl = trctrl,
                 preProc = c("center", "scale"))
knn <- predict(knn_fit1, newdata = train)

# Naive Bayes
cat("\nComputing Naive Bayes...\n")
nb_fit1 <- train(bugs ~ cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                rfc + wmc, data = train, method="nb",
                tuneLength = 15,
                trControl = trctrl,
                preProc = c("center", "scale"))
nb <- predict(nb_fit1, newdata = train)

# Support Vector Machines
cat("\nComputing SVMs...\n")
svm_fit1 <- train(bugs ~ cbo + fanOut + numberOfLinesOfCode + numberOfPublicAttributes +
                rfc + wmc, data = train, method="svmLinear",
                tuneLength = 15,
                trControl = trctrl,
                preProc = c("center", "scale"))
svm <- predict(svm_fit1, newdata = train)

#----------------------------------------------------------------
# 4. Evaluation
#----------------------------------------------------------------
evaluation <- function(pred) {
    cat("\nConfusion matrix:\n")
    xtab = table(true = train$bugs, predicted = pred)
    print(xtab)
    cat("\nEvaluation:\n\n")
    accuracy = sum(pred == train$bugs)/length(train$bugs)
    precision = xtab[1,1]/sum(xtab[,1])
    recall = xtab[1,1]/sum(xtab[1,])
    f = 2 * (precision * recall) / (precision + recall)
    cat(paste("Accuracy:\t", format(accuracy, digits=2), "\n",sep=" "))
    cat(paste("Precision:\t", format(precision, digits=2), "\n",sep=" "))
    cat(paste("Recall:\t\t", format(recall, digits=2), "\n",sep=" "))
    cat(paste("F-measure:\t", format(f, digits=2), "\n",sep=" "))
}
cat("\n########################################################################\n")
cat("\nSimple Neural Network - Full data \n")
evaluation(nnf)

cat("\n########################################################################\n")
cat("\nSimple Neural Network - Feature Selection \n")
evaluation(nn)

cat("\n########################################################################\n")
cat("\nTree - Full data\n")
evaluation(treef)

cat("\n########################################################################\n")
cat("\nTree - Feature Selection\n")
evaluation(tree)

cat("\n########################################################################\n")
cat("\nRandom Forest - Full Data\n")
evaluation(rff)

cat("\n########################################################################\n")
cat("\nRandom Forest - Feature Selection\n")
evaluation(rf)

cat("\n########################################################################\n")
cat("\nKNN - Full Data\n")
evaluation(knnf)

cat("\n########################################################################\n")
cat("\nKNN - Feature Selection\n")
evaluation(knn)

cat("\n########################################################################\n")
cat("\nNaive Bayes - Full data \n")
evaluation(nbf)

cat("\n########################################################################\n")
cat("\nNaive Bayes - Feature Selection \n")
evaluation(nb)

cat("\n########################################################################\n")
cat("\nSVMs - Full Data\n")
evaluation(svmf)

cat("\n########################################################################\n")
cat("\nSVMs - Feature Selection\n")
evaluation(svm)

#----------------------------------------------------------------
# 7. bugs_test file creation for KNN with feature selection
#----------------------------------------------------------------
cat("\n########################################################################\n")
cat("\ bugs_test file creation for KNN with feature selection... \n")
final <- predict(knn_fit, newdata = test)
final <- as.integer(final)
for (i in 1:198){
  final[i] = final[i] -1
}
final <- as.data.frame(final)
prediction <- temp
prediction[,2] <- final
write.csv2(prediction, file="bugs_test.csv", row.names=FALSE, quote=FALSE)
