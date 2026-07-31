# Iris KNN pipeline: load, clean, split, scale

# Load
df <- read.csv("Iris.csv")
str(df)

# Clean: drop the Id column, it is only a row number
df$Id <- NULL

# Split: seed 42, 60% train / 40% test
set.seed(42)
trainingCase <- sample(nrow(df), round(nrow(df) * 0.6))
training <- df[trainingCase, ]
test     <- df[-trainingCase, ]

# Scale: standardize the four measurements, then KNN with k = 5
training_scaled <- scale(training[, 1:4])
test_scaled <- scale(test[, 1:4],
                     center = attr(training_scaled, "scaled:center"),
                     scale  = attr(training_scaled, "scaled:scale"))
predictions <- class::knn(training_scaled, test_scaled, training$Species, k = 5)

table(Predicted = predictions, Actual = test$Species)
mean(predictions == test$Species)
