library(caret)

data(iris)

dataset <- iris

dataset
colnames(dataset) <- c("Sepal.Length","Sepal.Width","Petal.Length","Petal.Width","Species")

# create a list of 80% of the rows in the original dataset we can use for training
validation_index <- createDataPartition(dataset$Species, p=0.80, list=FALSE)
# select 20% of the data for validation
validation <- dataset[-validation_index,]
# use the remaining 80% of data to training and testing the models
dataset <- dataset[validation_index,]

sapply(dataset, class)

levels(dataset$Species)

percentage <- prop.table(table(dataset$Species)) * 100

cbind(freq=table(dataset$Species), percentage=percentage)
# ---------------------------------------------------------------------

x <- dataset[,1:4]
y <- dataset[,5]

par(mfrow=c(1,4))
for(i in 1:4) {
  boxplot(x[,i], main=names(iris)[i])
}

plot(y)

featurePlot(x=x, y=y, plot="ellipse")

featurePlot(x=x, y=y, plot="box")

scales <- list(x=list(relation='free'), y=list(relation="free"))

featurePlot(x=x, y=y, plot="density", scales=scales)

# ---------------------------------------------------------------------

control <- trainControl(method='cv', number=10)
metric  <- "Accuracy"

# ---------------------------------------------------------------------

# a) Linear Algorithms
#LDA
set.seed(7)
fit.lda <- train(Species~., data=dataset, method='lda', metric=metric, trControl=control)

# b) nonlinear Algorithms
#CART
set.seed(7)
fit.cart <- train(Species~., data=dataset, method='rpart', metric=metric, trControl=control)

#KNN
set.seed(7)
fit.knn <- train(Species~., data=dataset, method='knn', metric=metric, trControl=control)

# c) advanced algorithms

#SVM
set.seed(7)
fit.svm <- train(Species~., data=dataset, method='svmRadial', metric=metric, trControl=control)

#Random Forest

set.seed(7)
fit.rf <- train(Species~., data=dataset, method='rf', metric=metric, trControl=control)

# ---------------------------------------------------------------------

results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)

#dotplot(results)
parallelplot(results)
print(fit.lda)

# ---------------------------------------------------------------------

predictions <- predict(fit.lda, validation)
confusionMatrix(predictions, validation$Species)


