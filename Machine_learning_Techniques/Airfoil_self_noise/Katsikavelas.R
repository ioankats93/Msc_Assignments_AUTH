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

# setting working directory
mac <- "/Users/ioanniskatsikavelas/Desktop"
linux <- "/home/ioannis/Desktop"
path <- linux
setwd(path)
cat("You have set the PATH to :", setwd(path), "\n\n")

#load libraries
library(caret) #data splitting - pre-processing - feature selection
library(lattice) #data visualization
library(manipulate) #accepts a plotting expression and a set of controls which used to dynamically change values within the expression
library(xtable) # Convert an R object to an xtable object
library(Amelia) # use missmap for missing values

#load data
dat <- read.table(paste(path,"airfoil_self_noise.dat",sep = "/"))
names(dat) <- c("frequency", "angle_of_attack", "chord_length", "velocity_in_meters_per_sec", "thickness", "noise_db")
sum <- summary(dat)
print(sum) # print summary of the dataset
plot(dat, gap=0) # Variables Scatterplot - relations between variables

#----------------------------------------------------------------
# 2. Check for Missing Values and Correlations
#----------------------------------------------------------------
missmap(dat, main="Missing Values vs Observed") # check for missing values

descrCor <-  cor(dat)
print("Possible correlations -")
x = summary(descrCor[upper.tri(descrCor)])
print(descrCor)
print(x)

# TO DO Feature Scaling , Tests with Removing Features, Changing Features
# TO DO  added variables, ANOVA, 

#----------------------------------------------------------------
# 3. Training and Testing Split
#----------------------------------------------------------------
set.seed(1312)
index <- 1:nrow(dat)
testindex <- sample(index, trunc(length(index)/4))
testset <- dat[testindex,]
trainset <- dat[-testindex]

reg0 <- lm(noise_db~., data = dat) # all in one model
plot(reg0)
print(summary(reg0))
print("ANOVA REG0")
print(anova(reg0))

confidence_bands <- predict(reg0,interval="confidence")
print(confidence_bands)
prediction_bands <- predict(reg0,interval="prediction")
print(prediction_bands)
print("END")

reg1 <-lm(noise_db~., data = trainset) # model with just the training set
plot(reg1) # VISREG ?
print(summary(reg1))


#----------------------------------------------------------------
# 4. Accuracy Estimation
#----------------------------------------------------------------
eval_model <- function(model) {

        pred_train <- predict(model,newdata = trainset)
        pred_test <- predict(model,newdata = testset)

        # Scatter plots of predictions on Training and Testing sets
        plot(pred_train,trainset$noise_db,xlim=c(100,150),ylim=c(100,150),col=1,
             pch=19,xlab = "Predicted Noise (dB)",ylab = "Actual Noise(dB)")
        points(pred_test,testset$noise_db,col=2,pch=19)
        leg <- c("Training","Testing")
        legend(100, 150, leg, col = c(1, 2),pch=c(19,19))

        # Scatter plots of % error on predictions on Training and Testing sets
        par(mfrow = c(2, 1))
        par(cex = 0.6)
        par(mar = c(5, 5, 3, 0), oma = c(2, 2, 2, 2))
        plot((pred_train - trainset$noise_db)* 100 /trainset$noise_db,
             ylab = "% Error of Prediction", xlab = "Index",
             ylim = c(-5,5),col=1,pch=19)
        legend(0, 4.5, "Training", col = 1,pch=19)
        plot((pred_test-testset$noise_db)* 100 /testset$noise_db,
             ylab = "% Error of Prediction",  xlab = "Index",
             ylim = c(-5,5),col=2,pch=19)
        legend(0, 4.5, "Testing", col = 2,pch=19)

        # Actual data Vs Predictions superimposed for Training and Testing Data
        plot(1:length(trainset$noise_db),trainset$noise_db,pch=21,col=1,
             main = "Training: Actual Noise Vs Predicted Noise",
             xlab = "Index",ylab = "Noise (dB)")
        points(1:length(trainset$noise_db),pred_train,pch=21,col=2)
        #leg <- c("Training","Predicted Training")
        legend(0, 140, c("Actual","Predicted"), col = c(1, 2),pch=c(21,21))
        plot(1:length(testset$noise_db),testset$noise_db,pch=21,col=1,
             main = "Testing: Actual Noise Vs Predicted Noise",
             xlab = "Index",ylab = "Noise (dB)")
        points(1:length(testset$noise_db),pred_test,pch=21,col="red")
        legend(0, 140, c("Actual","Predicted"), col = c(1, 2),pch=c(21,21))

        ## Line graph of errors
        plot(pred_train-trainset$noise_db,type='l',ylim=c(-5,+5),
             xlab = "Index",ylab = "Actual - Predicted",main="Training")
        plot(pred_test-testset$noise_db,type='l',ylim=c(-5,+5),
             xlab = "Index",ylab = "Actual - Predicted",main="Testing")

        ISRMSE<- sqrt(mean((pred_train-trainset$noise_db)^2))
        OSRMSE<- sqrt(mean((pred_test-testset$noise_db)^2))

        return(c( ISRMSE,OSRMSE))
}

ans_reg <- train(noise_db ~., data=trainset, method="glm")
#summary(ans_reg)
print(xtable(summary(ans_reg)))
reg <- eval_model(ans_reg)
print(reg)
