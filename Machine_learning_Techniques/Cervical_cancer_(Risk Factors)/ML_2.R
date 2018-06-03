#_________________________________________________________
# Τεχνικές Μηχανικής μαθησης - Εαρινό Εξ. 2017 - 2018
# ΕΡΓΑΣΙΑ 1η
# Εργασία Εξαμήνου - Παλινδρόμηση
# Όνομα : Παυσανίας Κακαρίνος  | AM 387 e-mail : pafsanias1984@gmail.com
# Όνομα : Ιωάννης Κατσικαβέλας | AM 631 e-mail : ioankats93@gmail.com
#_________________________________________________________

#----------------------------------------------------------------
# 1. Load Data and libraries
#----------------------------------------------------------------
library(ggplot2)        #Data Visualization
library(dplyr)          #Data Manipulation
library(Boruta)         #Feature Importance Analysis
library(e1071)          # SVM
library(caret)          # Confusion matrix
require(pROC)           # ROC curve 
require(DMwR)           # Oversampling 

mac <- '/Users/ioanniskatsikavelas/Desktop'
linux <- '/home/ioannis/Desktop'
tmp <- paste(mac, "risk_factors_cervical_cancer.csv", sep="/")
raw.data = read.csv(tmp)
dim(raw.data)
glimpse(raw.data) # too many factors cause '?'

unique(raw.data$STDs..Time.since.first.diagnosis)

# Verify Dataset Integrity - NAs
prop_NA <- function(x) { mean(is.na(x))}
missdata <- sapply(raw.data, prop_NA)
missdata <- data.frame(Variables = names(missdata), Proportion = missdata, Completude = 1 - missdata)
missdata <- missdata[order(desc(missdata$Proportion)),]

# Data Visualization: Completude vs NAs
ggplot(missdata, aes(x = Variables, y = Completude))+
  geom_bar(stat = "identity", fill = "lawngreen")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "Porportion of non NA Values")+
  theme(plot.title = element_text(hjust = 0.5))

# Verify Dataset Integrity - Blanks and Zeroes
prop_NullZero <- function(x) { mean(x == "" | x == 0)}
nullzerodata <- sapply(raw.data, prop_NullZero)
nullzerodata <- data.frame(Variables = names(nullzerodata), Proportion = nullzerodata, Completude = 1 - nullzerodata)
nullzerodata <- nullzerodata[order(desc(nullzerodata$Completude)),]

# Data Visualization: Completude vs blanks and zeroes
ggplot(nullzerodata, aes(x = Variables, y = Completude))+
  geom_bar(stat = "identity", fill = "deepskyblue2")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "Proportion of non Zero or Blank Values")+
  theme(plot.title = element_text(hjust = 0.5))

#Verify Dataset Integrity - ?
prop_exclamation <- function(x) { mean(x == '?')}
exclamationdata <- sapply(raw.data, prop_exclamation)
exclamationdata <- data.frame(Variables = names(exclamationdata), Proportion = nullzerodata, Completude = 1 - exclamationdata)
exclamationdata <- exclamationdata[order(desc(exclamationdata$Completude)),]

# Data Visualization: Completude vs blanks and zeroes
ggplot(exclamationdata, aes(x = Variables, y = Completude))+
  geom_bar(stat = "identity", fill = "coral")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "Proportion of '?' Values")+
  theme(plot.title = element_text(hjust = 0.5))

## Data Manipulation
# Create function to identify all columns that need repair
find_cols = function(x){
  cols = vector()
  for (i in 1:ncol(x)){
    if (sum(x[,i] == "?") > 0){
      cols = c(cols,i)
    }
  }
  return(cols)
}

# Create function to fix missing values
fix_columns = function(x,cols) {
  for (j in 1:length(cols)) {
    x[,cols[j]] = as.character(x[,cols[j]])
    x[which(x[,cols[j]] == "?"),cols[j]] = "-1.0"
    x[,cols[j]] = as.numeric(x[,cols[j]])
  }
  return(x)
}

# Apply functions
cols_to_fix = find_cols(raw.data)
raw.data = fix_columns(raw.data,cols_to_fix)

# Create target variable
raw.data$CervicalCancer = raw.data$Hinselmann + raw.data$Schiller + raw.data$Citology + raw.data$Biopsy
raw.data$CervicalCancer = factor(raw.data$CervicalCancer, levels=c("0","1","2","3","4"))

# create train and Validation set
set.seed(1234) # try different seeds
ind <- sample(2, nrow(raw.data), replace=TRUE, prob=c(0.7, 0.3))
trainData <- raw.data[ind==1,]
validationData <- raw.data[ind==2,]

# Explore target variable distribution
round(prop.table(table(raw.data$CervicalCancer)),2)

# Plot target variable distribution
ggplot(raw.data,(aes(x = CervicalCancer, y = sum(as.integer(as.character(CervicalCancer))),fill = CervicalCancer)))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("limegreen","gold","orangered","red2","purple"))+
  labs(title = "Quantity of CervicalCancer Classes")+
  theme(plot.title = element_text(hjust = 0.5))

# Density: CervicalCancer across Age
ggplot(raw.data, aes(x = Age, fill=CervicalCancer))+
  geom_density(alpha = 0.40, color=NA)+
  scale_fill_manual(values=c("limegreen","gold","orangered","red2","purple"))+
  labs(title = "Density of CervicalCancer across Age")+
  theme(plot.title = element_text(hjust = 0.5))+
  facet_grid(as.factor(CervicalCancer) ~ .)

# Density: CervicalCancer across Age
ggplot(raw.data, aes(x = Hormonal.Contraceptives..years., fill=CervicalCancer))+
  geom_density(alpha = 0.40, color=NA)+
  scale_fill_manual(values=c("limegreen","gold","orangered","red2","purple"))+
  labs(title = "Density of CervicalCancer across Years of Hormonal Contraceptives")+
  theme(plot.title = element_text(hjust = 0.5))+
  facet_grid(as.factor(CervicalCancer) ~ .)

# Create copy of the original dataset, Remove medical results columns
train = raw.data
train$Hinselmann = NULL
train$Schiller = NULL
train$Citology = NULL
train$Biopsy = NULL

# Create Validation and Train data for Evaluation
set.seed(1234)
ind <- sample(2, nrow(train), replace=TRUE, prob=c(0.8, 0.2))
trainData <- train[ind==1,]
validationData <- train[ind==2,]

# Oversampling - SMOTE Algorithm
trainData_Ftest <- trainData
validationData_Ftest <- validationData
trainData_Ftest$CervicalCancer <- as.factor(trainData_Ftest$CervicalCancer)
trainData_Ftest1 <- SMOTE(CervicalCancer ~., trainData_Ftest, perc.over = 5000, perc.under = 100)
print(prop.table(table(trainData_Ftest$CervicalCancer)))

# Perform Boruta Analysis on the training set
set.seed(1312) # Try with many different seeds
boruta_analysis = Boruta(CervicalCancer ~ ., data=train, maxRuns=200)

# Plot boruta results
plot(boruta_analysis,las=2,main="Boruta Analysis: Variable Importance")
as.data.frame(boruta_analysis$finalDecision)

getSelectedAttributes(boruta_analysis, withTentative = F ) # check confirmed variables 

# SVM modelling
index <- 1:nrow(train)
testindex <- sample(index, trunc(length(index)/4 ))
testset <- train[testindex,]
trainset <- train[-testindex,]

svm.all <- svm (CervicalCancer ~., data = trainData, cost = 100, gamma = 1, cross = 10)
svm.all_oversampled <- svm (CervicalCancer ~., data = trainData_Ftest, cost = 100, gamma = 1, cross = 10) # Model with oversampling
#svm.pred <- predict(svm.all, testset[,-33])
#print(table(pred=svm.pred, true= testset[,33]))

# Tune SVM 
tc <- tune.control(cross = 10) # For cross validation
tunedsvm <- tune.svm(CervicalCancer ~., data = trainData, gamma = 2^(-10:10), cost = 2^(1:10), tunecontrol = tc)
#print(summary(tunedsvm))
plot(tunedsvm, transform.x = log10, xlab=expression(log[10](gamma)), ylab="C")

svm.model_tuned <- svm(CervicalCancer~., data = trainData, cost = 2, gamma = 0.5, cross = 10)
svm.model2_tuned_oversampled <- svm(CervicalCancer~., data = trainData_Ftest, cost = 2, gamma = 0.5, cross = 10) # Model with oversampling

#svm.pred2 <-  predict(svm.model2, testset[,-33])
#print(table(pred=svm.pred2, true= testset[,33]))

# Based on Boruta
svm.model_boruta <- svm(CervicalCancer~ Age + Number.of.sexual.partners + Smokes..years. + Smokes..packs.year. +
                   Hormonal.Contraceptives+ Hormonal.Contraceptives..years. + IUD +IUD..years. + STDs +
                   STDs..number. + STDs.condylomatosis + STDs.vulvo.perineal.condylomatosis + STDs..Time.since.first.diagnosis +
                   STDs..Time.since.last.diagnosis + Dx.Cancer + Dx.HPV + Dx   , data = trainData, cost = 2, gamma = 0.5, cross = 10)

svm.model_boruta_oversampled <- svm(CervicalCancer~ Age + Number.of.sexual.partners + Smokes..years. + Smokes..packs.year. +
                   Hormonal.Contraceptives+ Hormonal.Contraceptives..years. + IUD +IUD..years. + STDs +
                   STDs..number. + STDs.condylomatosis + STDs.vulvo.perineal.condylomatosis + STDs..Time.since.first.diagnosis +
                   STDs..Time.since.last.diagnosis + Dx.Cancer + Dx.HPV + Dx   , data = trainData_Ftest, cost = 2, gamma = 0.5, cross = 10)
# Evaluation 
evaluation <- function(model, data, atype){ 
  cat("\nConfusion matrix:\n")
  prediction = predict(model, train, type=atype)
  xtab = table(prediction, train$CervicalCancer)
  print(xtab)
  cat("\nEvaluation:\n\n")
  accuracy = sum(prediction == train$CervicalCancer)/length(train$CervicalCancer)
  precision = xtab[1,1]/sum(xtab[,1])
  recall = xtab[1,1]/sum(xtab[1,])
  f = 2 * (precision * recall) / (precision + recall)
  cat(paste("Accuracy:\t", format(accuracy, digits=2), "\n",sep=" "))
  cat(paste("Precision:\t", format(precision, digits=2), "\n",sep=" "))
  cat(paste("Recall:\t\t", format(recall, digits=2), "\n",sep=" "))
  cat(paste("F-measure:\t", format(f, digits=2), "\n",sep=" "))
}

# Without Oversampling
evaluation(svm.all, testset, 'response')
evaluation(svm.model_tuned, testset, 'response')
evaluation(svm.model_boruta, 'response')

# With Oversampling
evaluation(svm.all_oversampled, validationData_Ftest, 'response')
evaluation(svm.model_tuned, validationData_Ftest, 'response')
evaluation(svm.model_boruta_oversampled, validationData_Ftest, 'response')


