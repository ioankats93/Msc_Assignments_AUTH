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
rm(list=ls(all= TRUE ))

#load libraries
library(caret) # data splitting - pre-processing - feature selection
library(lattice) # data visualization
library(manipulate) # accepts a plotting expression and a set of controls which used to dynamically change values within the expression
library(xtable) # Convert an R object to an xtable object
library(Amelia) # use missmap for missing values
library(e1071) # use for Density plots
library(corrplot)
library(ggplot2)
library(RColorBrewer)

# setting working directory
mac <- "/Users/ioanniskatsikavelas/Desktop"
linux <- "/home/ioannis/Desktop"
path <- linux
setwd(path)
cat("You have set the PATH to :", setwd(path), "\n\n")

# load data
dat <- read.delim("C:/Users/kapa/Desktop/Macine Learning/airfoil_self_noise.dat", header=FALSE)
names(dat) <- c("frequency", "angle_of_attack", "chord_length", "vel_m_s", "thickness", "noise_db")
sum <- summary(dat)
print(sum) # print summary of the dataset
str(dat)
plot(dat, gap=0) # Variables Scatterplot - relations between variables

# BoxPlot
boxplot(dat$frequency, main="Frequency")
boxplot(dat$angle_of_attack, main="Angle of attack")
boxplot(dat$chord_length, main="Chord length")
boxplot(dat$vel_m_s, main="Velocity in meters / sec")
boxplot(dat$thickness, main="Thickness")

# Density Plots
plot(density(dat$frequency), main="Density Plot: Frequency", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(dat$frequency), 2)))
polygon(density(dat$frequency), col="red")
plot(density(dat$angle_of_attack), main="Density Plot: Angle of Attack", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(dat$angle_of_attack), 2)))
polygon(density(dat$angle_of_attack), col="red")
plot(density(dat$chord_length), main="Density Plot: chord Length", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(dat$chord_length), 2)))
polygon(density(dat$chord_length), col="red")
plot(density(dat$vel_m_s), main="Density Plot: Velocity in Meters", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(dat$vel_m_s), 2)))
polygon(density(dat$vel_m_s), col="red")
plot(density(dat$thickness), main="Density Plot: Thickness", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(dat$thickness), 2)))
polygon(density(dat$thickness), col="red")

#----------------------------------------------------------------
# 2. Check for Missing Values and Correlations
#----------------------------------------------------------------
missmap(dat, main="Missing Values vs Observed") # check for missing values

descrCor <-  cor(dat)
print("Possible correlations -")
x = summary(descrCor[upper.tri(descrCor)])
print(descrCor)
print(x)
M <- cor(dat)
corrplot(M, type="upper", order="hclust", col=brewer.pal(n=8, name="RdBu"))

# TO DO Feature Scaling , Changing Features ,
# TO DO  added variables, ANOVA, MSE

# Removing and Mutating Features - Re = V_inf * C / nu

#nu <- 1.568e-5
#dat$re <- dat$chord_length * dat$vel_m_s / nu
#dat <- dat[,-c(3,4,5)]   # Should i remove thickness ?
#dat <- dat[,c(1:2,4,3)]
#names(dat)

#----------------------------------------------------------------
# 3. Training and Testing Split
#----------------------------------------------------------------
set.seed(1312)
index <- 1:nrow(dat)
testindex <- createDataPartition(y=dat$noise_db, p=0.30, list=FALSE)
testset <- dat[testindex,]
trainset <- dat[-testindex,]

eval_model <- function(model,trainset,testset) {

  pred_train <- predict(model,newdata = trainset)
  pred_test <- predict(model,newdata = testset)

  # Scatter plots of predictions on Training and Testing sets
  plot(pred_train,trainset$noise_db,xlim=c(90,150),ylim=c(90,150),col=1,
       pch=19,xlab = "Predicted",ylab = "Actual")
  points(pred_test,testset$noise_db,col=2,pch=19)
  leg <- c("Training","Testing")
  legend(90, 150, leg, col = c(1, 2),pch=c(19,19))

  # Scatter plots of % error on predictions on Training and Testing sets
  par(mfrow = c(2, 1))
  par(cex = 0.6)
  par(mar = c(5, 5, 3, 0), oma = c(2, 2, 2, 2))
  plot((pred_train - trainset$noise_db) * 100 / trainset$noise_db,
       ylab = "% Error of Prediction", xlab = "Index",
       col=1,pch=19)
  legend(0, 15, "Training", col = 1,pch=19)
  plot((pred_test - testset$noise_db) * 100 / testset$noise_db,
       ylab = "% Error of Prediction",  xlab = "Index",
       col=2,pch=19)
  legend(0, 7, "Testing", col = 2,pch=19)

  # Actual data Vs Predictions superimposed for Training and Testing Data
  plot(1:length(trainset$noise_db),trainset$noise_db,pch=21,col=1,
       main = "Training: Actual Vs Predicted",
       xlab = "Index",ylab = "Relative Performance")
  points(1:length(trainset$noise_db),pred_train,pch=21,col=2)
  #leg <- c("Training","Predicted Training")
  legend(0, 140, c("Actual","Predicted"), col = c(1, 2),pch=c(21,21))
  plot(1:length(testset$noise_db),testset$noise_db,pch=21,col=1,
       main = "Testing: Actual  Vs Predicted",
       xlab = "Index",ylab = "Relative Performance")
  points(1:length(testset$noise_db),pred_test,pch=21,col="red")
  legend(0, 115, c("Actual","Predicted"), col = c(1, 2),pch=c(21,21))

  ## Line graph of errors
  plot(pred_train-trainset$noise_db,type='l',
       xlab = "Index",ylab = "Actual - Predicted",main="Training")
  plot(pred_test-testset$noise_db,type='l',
       xlab = "Index",ylab = "Actual - Predicted",main="Testing")

  ISRMSE<- sqrt(mean((pred_train-trainset$noise_db)^2))
  OSRMSE<- sqrt(mean((pred_test-testset$noise_db)^2))

  return(c( ISRMSE,OSRMSE))
}

reg0 <- lm(noise_db~., data = trainset) # all in one model
#plot(reg0)
#print(summary(reg0))
#print(anova(reg0))


reg1 <- lm(noise_db~ frequency + angle_of_attack + log2(chord_length) * log2(vel_m_s) + thickness, data = trainset)
#plot(reg1)
#print(summary(reg1))
#print(anova(reg1))

reg2 <- lm(noise_db ~ angle_of_attack^3 + frequency^3 * (log2(chord_length)^3 * vel_m_s) + thickness^2, data = trainset)
#plot(reg2)
#print(summary(reg2))
#print(anova(reg2))

reg3 <- lm(noise_db ~ angle_of_attack * frequency + frequency * (log2(chord_length) * vel_m_s) * angle_of_attack  + thickness , data = trainset)
plot(reg3)
print(summary(reg3))
print(anova(reg3))

result0 <- eval_model(reg0,trainset,testset)
print(result0)

par(mfrow = c(1, 1))
result1 <- eval_model(reg1,trainset,testset)
print(result1)

par(mfrow = c(1, 1))
result2 <- eval_model(reg2,trainset,testset)
print(result2)

par(mfrow = c(1, 1))
result3 <- eval_model(reg3,trainset,testset)
print(result3)

confidence_bands <- predict(reg3,interval="confidence")
print(confidence_bands)
prediction_bands <- predict(reg3,interval="prediction")
print(prediction_bands)
