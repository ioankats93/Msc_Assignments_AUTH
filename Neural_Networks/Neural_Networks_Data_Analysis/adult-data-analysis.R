#__________________________________________________________________________
# ΥΠΟΛΟΓΙΣΤΙΚΗ ΝΟΥΜΟΣΥΝΗ - ΣΥΣΤΗΜΑΤΑ ΕΜΠΝΕΥΣΜΕΝΑ ΑΠΟ ΤΗ ΒΙΟΛΟΓΙΑ
# ΕΡΓΑΣΙΑ 1η
# Όνομα : Παυσανίας Κακαρίνος  AM :387 e-mail : pafsanias1984@gmail.com
# Όνομα : Ιωάννης Κατσικαβέλας ΑΜ :631 e-mail : ioankats93@gmail.com
#__________________________________________________________________________

# -------------------------------------------------------------------------
#  1. Load Libraries and Data
# -------------------------------------------------------------------------
install.packages("ggplot2")
install.packages("ggthemes")
install.packages("scales")
install.packages("gridExtra")
install.packages("earth")
install.packages("Boruta")
install.packages("ROCR")
install.packages("dplyr")
install.packages("mice")
install.packages("neuralnet")
install.packages("rnn")
install.packages("FSelector")
install.packages("caret")
install.packages("e1071")

# setting working directory (edit your path before running script)
rm(list=ls(all =TRUE))
path <- "/home/paf/Desktop"
setwd(path)
cat("PATH :",getwd(),"\n\n")

# load Libraries
library('ggplot2')   #
library('ggthemes')  #
library('scales')    # visualization
library('gridExtra') #
library('earth')     #
library("Boruta")    #
library("ROCR")      #

library('dplyr')      # data manipulation
library('mice')       # imputation
library('nnet')       # Neural Nets
library('neuralnet')  # Back propagation Neural Net
library("rnn")        # Recurrent Neural Network
library('FSelector')
library('caret')
library('e1071')

# TO DO   :: Check if there is a workspace and if not create it on Desktop

#load data
trainFile = "adult.data"; testFile = "adult.test"

if (!file.exists(trainFile))
  download.file(url = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", destfile = trainFile )

if (!file.exists(testFile))
  download.file(url = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.test", destfile = testFile )

names <- c("age", "workclass",
  "fnlwgt", "education", "education-num",   # fnlwgt = Final Weight Determined by Census Org
  "marital-status", "occupation",
  "relationship", "race", "sex",
  "capital-gain", "capital-loss",
  "hours-per-week", "native-country", "income")

train <- read.table(trainFile, header = FALSE, sep = ",",
                    strip.white = TRUE, col.names = names,
                  na.strings = "?", stringsAsFactors = TRUE)

test <- read.table(testFile, header = FALSE, sep= ",", skip = 1,
                    strip.white = TRUE, col.names=names,
                  na.strings = "?", stringsAsFactors = TRUE)

test$income <- gsub("[.]","",test$income) #remove "." from test$income column    >50K. >50K

# -------------------------------------------------------------------------
#  2. Check and Clean The Data
# -------------------------------------------------------------------------

# check data
str(train)

# Check for NAs
x = table(complete.cases(train)) #Nas Table | FALSE = NAs
proportion <- (x[1]/(x[1]+x[2]))
cat("\n#######################################################################\n")
cat("\nThe NAs Are:", x[1], "| Not NAs:", x[2],"| NAs Proportion:", round(proportion*100),"%\n")

cat("\n#######################################################################\n")
cat("Train Summary:\n")
sum1 <- summary(train)
print(sum1)

cat("\n#######################################################################\n")
cat("Train summary for NAs only:\n")
sumNas <- summary(train[!complete.cases(train),])
print(sumNas)

cat("\n#######################################################################\n")
# Classes and NAs
for (i in 1:15) {
  cat(names[i]," has ",sum(is.na(train[i])),"NAs in Train\n")
}
cat("\n#######################################################################\n")

cat("\n#######################################################################\n")
# Classes and NAs
for (i in 1:15) {
  cat(names[i]," has ",sum(is.na(test[i])),"NAs in Test\n")
}
cat("\n#######################################################################\n")

# -------------------------------------------------------------------------
#  3. Check variables and corelations - Continuous Variables
# -------------------------------------------------------------------------

# Income Level Distribution
cat("\nIncome Level Distribution :\n")
print(table(train$income))
cat("\n")

# Remove Nas
cleanTrain <- train[!is.na(train$workclass) & !is.na(train$occupation) & !is.na(train$native.country),]
str(cleanTrain)

cleanTest <- test[!is.na(test$workclass) & !is.na(test$occupation) & !is.na(test$native.country),]
str(cleanTest)

subset <- cfs(income ~ .,cleanTrain)
form <- as.simple.formula(subset, "income")
print(form)

#cleanTrain$fnlwgt = NULL
#cleanTest$fnlwgt = NULL

cat("\n")
cat("----------CONTINUOUS VARIABLES------------\n")
# -------------------------------------------------------------------------
#  3.1 Age attribute
# -------------------------------------------------------------------------
cat("\n")
cat("-------------------------------------------------------------------------\n")
cat("Age Attribute\n")
cat("-------------------------------------------------------------------------\n")

ageHist <- hist(cleanTrain$age, col="blue", xlab="Age", main = "Histogram of Age distribution")
ageHist

ageDist <- summary(cleanTrain$age)
print(ageDist)

boxplot (age ~ income, data = cleanTrain,
        main = "Age distribution",
      xlab="Income Levels", ylab = "Age", col=terrain.colors(4))

age2income <- ggplot(cleanTrain, aes(x = age, fill = factor(income))) +
        geom_bar(stat='count', position='dodge') +
        labs(x= 'Age') +
        theme_bw()
# print(age2income)

incomeBelow50k <- (cleanTrain$income == "<=50K")
below50 <- qplot(age, data = cleanTrain[incomeBelow50k,], margins = TRUE,
              binwidth = 1, colour = income)
above50 <- qplot(age, data = cleanTrain[!incomeBelow50k,], margins = TRUE,
              binwidth = 1, colour = income)
grid.arrange(age2income,below50, above50, nrow = 3 )

#        # -------------------------------------------------------------------------
#        #  3.2 fnlwgt attribute
#        # -------------------------------------------------------------------------
#
#        cat("\n")
#        cat("-------------------------------------------------------------------------\n")
#        cat("fnlwgt Attribute\n")
#        cat("-------------------------------------------------------------------------\n")
#
#        fnlwgtHist <- hist(cleanTrain$age, col="blue", xlab="fnlwgt", main = "Histogram of fnlwgt distribution")
#        fnlwgtHist
#
#        fnlwgtDist <- summary(cleanTrain$fnlwgt)
#        print(fnlwgtDist)
#
#        boxplot (fnlwgt ~ income, data = cleanTrain,
#                main = "fnlwgt distribution",
#              xlab="Income Levels", ylab = "fnlwgt", col=terrain.colors(4))
#
#        fnlwgt2income <- ggplot(cleanTrain, aes(x = fnlwgt, fill = factor(income))) +
#                geom_bar(stat='count', position='dodge') +
#                labs(x= 'fnlwgt') +
#                theme_bw()
#         print(fnlwgt2income)

# -------------------------------------------------------------------------
#  3.3 Education attribute
# -------------------------------------------------------------------------
cat("\n")
cat("-------------------------------------------------------------------------\n")
cat("Education Years Attribute\n")
cat("-------------------------------------------------------------------------\n")

edHist <- hist(cleanTrain$education.num, col="blue", xlab="Education Years", main = "Histogram of Education Years distribution")
edHist

edDist <- summary(cleanTrain$education.num)
print(edDist)

boxplot (education.num ~ income, data = cleanTrain,
       main = "Education years distribution",
     xlab="Income Levels", ylab = "education years", col=terrain.colors(4))

ed2income <- ggplot(cleanTrain, aes(x = education.num, fill = factor(income))) +
       geom_bar(stat='count', position='dodge') +
       labs(x= 'Education Years') +
       theme_bw()
print(ed2income)

# -------------------------------------------------------------------------
#  3.4 Capital Gain attribute
# -------------------------------------------------------------------------
cat("\n")
cat("-------------------------------------------------------------------------\n")
cat("Capital loss Attribute\n")
cat("-------------------------------------------------------------------------\n")

cgHist <- hist(cleanTrain$capital.gain, col="blue", xlab="Capital Gain", main = "Histogram of Capital Gain distribution")
cgHist

cgDist <- summary(cleanTrain$capital.gain)
print(cgDist)

boxplot (capital.gain ~ income, data = cleanTrain,
       main = "Capital Gain distribution",
     xlab="Income Levels", ylab = "Capital Gain", col=terrain.colors(4))

# -------------------------------------------------------------------------
#  3.5 Capital loss attribute
# -------------------------------------------------------------------------
cat("\n")
cat("-------------------------------------------------------------------------\n")
cat("Capital loss Attribute\n")
cat("-------------------------------------------------------------------------\n")

clHist <- hist(cleanTrain$capital.loss, col="blue", xlab="Capital loss", main = "Histogram of Capital loss distribution")
clHist

clDist <- summary(cleanTrain$capital.loss)
print(clDist)

boxplot (capital.loss ~ income, data = cleanTrain,
      main = "Capital loss distribution",
    xlab="Income Levels", ylab = "Capital loss", col=terrain.colors(4))

# -------------------------------------------------------------------------
#  3.6 Hours per Week attribute
# -------------------------------------------------------------------------
cat("\n")
cat("-------------------------------------------------------------------------\n")
cat("Hours per Week Attribute\n")
cat("-------------------------------------------------------------------------\n")

hpwHist <- hist(cleanTrain$hours.per.week, col="blue", xlab="Hours Per Week", main = "Histogram of Hours per Week distribution")
hpwHist

hpwDist <- summary(cleanTrain$hours.per.week)
print(hpwDist)

boxplot (hours.per.week ~ income, data = cleanTrain,
       main = "Hours per Week distribution",
     xlab="Income Levels", ylab = "Hours per Week", col=terrain.colors(4))

hpw2income <- ggplot(cleanTrain, aes(x = hours.per.week, fill = factor(income))) +
       geom_bar(stat='count', position='dodge') +
       labs(x= 'Hours per Week') +
       theme_bw()
print(hpw2income)

cat("\n")
cat("---------- Correlation Between Continuous Variables ------------\n")
correlations <- cor(cleanTrain[, c("age", "education.num", "capital.gain", "capital.loss", "hours.per.week")])
# diag(correlations) = 0  Remive self correlations
print(correlations)

# -------------------------------------------------------------------------
#  4. Check variables and corelations - Categorical Variables
# -------------------------------------------------------------------------
cat("\n\n")
cat("----------CATEGORICAL VARIABLES------------\n")
#'
# Sex variable
sextable <- table(cleanTrain[,c("sex", "income")])
print(sextable)

workclassPlot <-qplot(income, data = cleanTrain, fill=workclass) + facet_grid(.~ workclass)
print(workclassPlot)

educationPlot <-qplot(income, data = cleanTrain, fill=education) + facet_grid(.~ education)
print(educationPlot)

mstatusPlot <-qplot(income, data = cleanTrain, fill=marital.status) + facet_grid(.~ marital.status)
print(mstatusPlot)

occupationPlot <-qplot(income, data = cleanTrain, fill=occupation) + facet_grid(.~ occupation)
print(occupationPlot)

racePlot <-qplot(income, data = cleanTrain, fill=race) + facet_grid(.~ race)
print(racePlot)

relationshipPlot <-qplot(income, data = cleanTrain, fill=relationship) + facet_grid(.~ relationship)  # Should be ordered??
print(relationshipPlot)

importance <- earth(income ~., data = cleanTrain)
ev <- evimp(importance)
plot(ev)

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#boruta_output <- Boruta(income ~., data=cleanTrain, doTrace=2)
#boruta_signif <- names(boruta_output$finalDecision[boruta_output$finalDecision %in% c("Confirmed", "Tentative")])
#print(boruta_signif)
#plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variance Importance")
#'
# -------------------------------------------------------------------------
#  5. Neural Network Implementation
# -------------------------------------------------------------------------
#ff <- nnet(income ~., data = cleanTrain, size = 10, maxit =600) # feed forward
#ffwl <- nnet(income ~., data = cleanTrain, size = 10, maxit =600, learningrate = 0.35)
#ffwp <- nnet(income ~., data = cleanTrain, size = 10, maxit =600, decay=5e-4, rang=0.1)

cleanTrainupd <- cleanTrain
levels(cleanTrainupd$income) <- c("below50K", "above50K")

cleanTest$income <- as.factor(cleanTest$income)
cleanTestupd <- cleanTest
levels(cleanTestupd$income) <- c("below50K", "above50K")

set.seed(123)
mgrid <- expand.grid(decay = c(0.5, 0.3, 0.1), size = c(5, 7, 9))
numFolds <- trainControl(method = 'cv', classProbs = TRUE, summaryFunction = twoClassSummary, preProcOptions = list(thresh = 0.3, ICAcomp = 3, k = 5))
model <- train(income ~ ., data = cleanTrainupd, method = "nnet", preProcess = c('center', 'scale'), trControl = numFolds, lifesign = "full", maxit = 1000, tuneGrid = mgrid)

set.seed(123)
model2 <- train(form, data = cleanTrainupd, method = "nnet", preProcess = c('center', 'scale'), trControl = numFolds, lifesign = "full", maxit = 1000, tuneGrid = mgrid)

# Data manipulation For back propagation?
backpropData <- cleanTrain


# int Data Normalization
backpropData$age <- (backpropData$age - min(backpropData$age))/
                                   (max(backpropData$age) - min(backpropData$age))

backpropData$fnlwgt <- (backpropData$fnlwgt - min(backpropData$fnlwgt))/
                                    (max(backpropData$fnlwgt) - min(backpropData$fnlwgt))

backpropData$education.num <- (backpropData$education.num - min(backpropData$education.num))/
                                    (max(backpropData$education.num) - min(backpropData$education.num))

backpropData$capital.gain <- (backpropData$capital.gain - min(backpropData$capital.gain))/
                                     (max(backpropData$capital.gain) - min(backpropData$capital.gain))

backpropData$capital.loss <- (backpropData$capital.loss - min(backpropData$capital.loss))/
                                    (max(backpropData$capital.loss) - min(backpropData$capital.loss))

backpropData$hours.per.week <- (backpropData$hours.per.week - min(backpropData$hours.per.week))/
                                    (max(backpropData$hours.per.week) - min(backpropData$hours.per.week))

# Factor variables
table(backpropData$workclass)
table(backpropData$education)
table(backpropData$marital.status)
table(backpropData$occupation)
table(backpropData$relationship)
table(backpropData$race)
table(backpropData$sex)
table(backpropData$native.country)
table(backpropData$income)

head(model.matrix(~workclass, data = backpropData))
head(model.matrix(~education, data = backpropData))
head(model.matrix(~marital.status, data = backpropData))
head(model.matrix(~occupation, data = backpropData))
head(model.matrix(~relationship, data = backpropData))
head(model.matrix(~race, data = backpropData))
head(model.matrix(~sex, data = backpropData))
head(model.matrix(~native.country, data = backpropData))
head(model.matrix(~income, data = backpropData))

adult_matrix <- model.matrix(~age+workclass+education+education.num
                            +marital.status+occupation+relationship
                            +race+sex+capital.gain+capital.loss
                            +hours.per.week+native.country+income, data=backpropData)

#adult_matrix2 <- model.matrix(~education.num
#                            +marital.status+relationship
#                            +capital.gain+capital.loss
#                            +income, data=backpropData)
colnames(adult_matrix)

colnames(adult_matrix) <- gsub("[.]","",colnames(adult_matrix))
colnames(adult_matrix) <- gsub("[-]","",colnames(adult_matrix))
colnames(adult_matrix)[84] <- "nativecountryOutlyingUSGuamUSVIetc"
colnames(adult_matrix)[94] <- "nativecountryTrinadadTobago"
colnames(adult_matrix)[98] <-"incomebigger50k"

col_list <- paste(c(colnames(adult_matrix[,-c(1,98)])), collapse="+")
col_list <- paste(c("incomebigger50k~", col_list), collapse="")
f <- formula(col_list)

#colnames(adult_matrix2) <- gsub("[.]","",colnames(adult_matrix2))
#colnames(adult_matrix2) <- gsub("[-]","",colnames(adult_matrix2))
#col_list2 <- paste(c(colnames(adult_matrix2[,-c(1,16)])), collapse="+")
#col_list2 <- paste(c("incomebigger50k~", col_list2), collapse="")
#f2 <- formula(col_list2)

#ctrl <- trainControl(method = "cv", classProbs = TRUE, summaryFunction = twoClassSummary)
#nnfit <- train(form, data = cleanTrain, method = "neuralnet", algorithm = 'backprop', hidden = 6, trControl = ctrl, linout = TRUE)

#nnbp <- neuralnet(f, data = adult_matrix, hidden = c(10,5), algorithm = "backprop", learningrate=0.35, threshold = 0.01, linear.output=F)

set.seed(1025732)
nn_prop <- neuralnet(f, data = adult_matrix, algorithm = "rprop+", hidden=c(10,3), threshold=0.30, lifesign="full", stepmax=25000)
plot(nn_prop)

#nn_prop2 <- neuralnet(f2, data = adult_matrix2, algorithm = "rprop-", hidden=c(6,4), learningrate = 0.2, threshold=0.30, lifesign="full")

# Make prediction for the neural network

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#nn1.pred <- predict(nn1, newdata=test, type = 'class')
#pred1 <- rep('<=50', length(nn1.pred))
#pred1[nn1.pred>=.5] <- '>50K'
#tb1 <- table(pred1, test$income)
#print(tb1)
#pr1 <- prediction(nn1.pred, test$income)
#prf1 <- performance(pr1, measure = 'tpr', x.measure = "fpr")
#dd1 <- data.frame(FP = prf1@x.values[[1]], TP= prf1@y.values[[1]])
#p <-performance(pr1, measure='auc')@y.values[[1]]
#print(p)

# Final Evaluation
evaluation <- function(model,  data){
  cat("\nConfusion Matrix:\n")
  predic <- predict(model, data[,-15])
  xtab = table(true = data$income, predicted = predic)
  print(xtab)
  cat("\nEvaluation:\n\n")
  accuracy = sum(predic == data$income)/length(data$income)
  precision = xtab[1,1]/sum(xtab[,1])
  recall = xtab[1,1]/sum(xtab[1,])
  f = 2*(precision * recall) / (precision + recall)
  cat(paste("Accuracy:\t", format(accuracy, digits=2), "\n", sep=" "))
  cat(paste("Precision:\t", format(precision, digits=2), "\n", sep=" "))
  cat(paste("Recall:\t\t", format(recall, digits=2), "\n", sep=" "))
  cat(paste("F-measure:\t", format(f, digits=2), "\n", sep=" "))

}

cat("\nFeed forward Neural Network with full set:\n")
evaluation(model, cleanTestupd)

cat("\nFeed forward Neural Network with subset:\n")
evaluation(model2, cleanTestupd)

cat("\nBack Propagation Neural Network:\n")

backpropDataY <- cleanTest


# int DataY Normalization
backpropDataY$age <- (backpropDataY$age - min(backpropDataY$age))/
  (max(backpropDataY$age) - min(backpropDataY$age))

backpropDataY$fnlwgt <- (backpropDataY$fnlwgt - min(backpropDataY$fnlwgt))/
  (max(backpropDataY$fnlwgt) - min(backpropDataY$fnlwgt))

backpropDataY$education.num <- (backpropDataY$education.num - min(backpropDataY$education.num))/
  (max(backpropDataY$education.num) - min(backpropDataY$education.num))

backpropDataY$capital.gain <- (backpropDataY$capital.gain - min(backpropDataY$capital.gain))/
  (max(backpropDataY$capital.gain) - min(backpropDataY$capital.gain))

backpropDataY$capital.loss <- (backpropDataY$capital.loss - min(backpropDataY$capital.loss))/
  (max(backpropDataY$capital.loss) - min(backpropDataY$capital.loss))

backpropDataY$hours.per.week <- (backpropDataY$hours.per.week - min(backpropDataY$hours.per.week))/
  (max(backpropDataY$hours.per.week) - min(backpropDataY$hours.per.week))

adult_matrixY <- model.matrix(~age+workclass+education+education.num
                              +marital.status+occupation+relationship
                              +race+sex+capital.gain+capital.loss
                              +hours.per.week+native.country+income, data=backpropDataY)

for (i in 2:70) {
  adult_matrixY[,i-1] <- adult_matrixY[,i]
  colnames(adult_matrixY)[i-1] <- colnames(adult_matrixY)[i]
}

colnames(adult_matrixY)[70] <- colnames(adult_matrix)[71]

for (i in 1:length(adult_matrixY[,70])) {
  adult_matrixY[i,70] <- 0
}

colnames(adult_matrixY) <- gsub("[.]","",colnames(adult_matrixY))
colnames(adult_matrixY) <- gsub("[-]","",colnames(adult_matrixY))
colnames(adult_matrixY)[83] <- "nativecountryOutlyingUSGuamUSVIetc"
colnames(adult_matrixY)[93] <- "nativecountryTrinadadTobago"
colnames(adult_matrixY)[97] <-"incomebigger50k"

pred <- compute(nn_prop, adult_matrixY[,1:96])
result <- 0
for (i in 1:15060){
  result[i] <- pred$net.result[i]
  if (result[i] > 0.5 ) {result[i] = ">50K"}
  else{result[i]= "<=50K"}
}

cat("\nConfusion Matrix:\n")
xtab <- table(true = cleanTest$income, predicted = result)
print(xtab)
cat("\nEvaluation:\n\n")
accuracy = sum(result == cleanTest$income)/length(cleanTest$income)
precision = xtab[1,1]/sum(xtab[,1])
recall = xtab[1,1]/sum(xtab[1,])
f = 2*(precision * recall) / (precision + recall)
cat(paste("Accuracy:\t", format(accuracy, digits=2), "\n", sep=" "))
cat(paste("Precision:\t", format(precision, digits=2), "\n", sep=" "))
cat(paste("Recall:\t\t", format(recall, digits=2), "\n", sep=" "))
cat(paste("F-measure:\t", format(f, digits=2), "\n", sep=" "))
