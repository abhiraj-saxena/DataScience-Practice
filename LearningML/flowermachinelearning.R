library(caret)

data(iris)

dataset <- iris

colnames(dataset) <- c("Septa.Length", "Sepal.Width", "Petal.Length",
                       "Petal.Width", "Species")

validation_index <- createDataPartition(dataset$Species, p=0.80, list=FALSE)

validation <- dataset[-validation_index,]

dataset <- dataset[validation_index,]

dim(dataset)

sapply(dataset, class)

head(dataset)

dataset

levels(dataset$Species)

percentage <- prop.table(table(dataset$Species)) * 100
cbind(freq=table(dataset$Species), percentage=percentage)

summary(dataset)


x <- dataset[,1:4]
y <- dataset[,5]


par(mfrow = c(1,4))
  for(i in 1:4) {
  boxplot(x[,i], main=names(iris)[i])
    
  }

