df=read.csv("Iris.csv")
use_caret <- requireNamespace("caret", quietly = TRUE)
if (use_caret) {
    library(caret)
} else {
    library(class)
}
library(ggplot2)

if (interactive()) {
    View(df)
}
str(df)
df$Id <- NULL

set.seed(42)
n= nrow(df)
trainingsize= round(n*0.6)

trainingCase= sample(n, trainingsize)
trainingCase

training=df[trainingCase,]
test= df[-trainingCase,]
if (interactive()) {
    View(test)
    View(training)
}

if (use_caret) {
    model_knn <- train(Species ~ ., data = training, method = "knn")
    predictions <- predict(model_knn, test)
    predictions
    head(predictions)
    print(confusionMatrix(as.factor(predictions), as.factor(test$Species)))
    print(mean(predictions == test$Species))
} else {
    predictors <- c("SepalLengthCm", "SepalWidthCm", "PetalLengthCm", "PetalWidthCm")
    training_x <- training[, predictors]
    test_x <- test[, predictors]
    training_y <- training$Species

    training_scaled <- scale(training_x)
    test_scaled <- scale(
        test_x,
        center = attr(training_scaled, "scaled:center"),
        scale = attr(training_scaled, "scaled:scale")
    )

    predictions <- class::knn(train = training_scaled, test = test_scaled, cl = training_y, k = 5)
    predictions
    head(predictions)
    print(table(Predicted = predictions, Actual = test$Species))
    print(mean(predictions == test$Species))
}

scatter_plot <- ggplot(training, aes(x = PetalLengthCm, y = PetalWidthCm, color = Species)) +
    geom_point(size = 3) +
    labs(title = "Iris Species Scatter Plot", x = "Petal Length (cm)", y = "Petal Width (cm)") +
    scale_color_manual(values = c("Iris-setosa" = "#C00000", "Iris-versicolor" = "#2E8B57", "Iris-virginica" = "#1F4E79")) +
    theme_minimal()

print(scatter_plot)
ggsave("iris_scatter_plot.png", scatter_plot, width = 8, height = 6, dpi = 300)

# KNN decision-region plot using the same two features shown in the scatter plot
vis_training <- training[, c("Species", "PetalLengthCm", "PetalWidthCm")]

if (use_caret) {
    vis_model_knn <- train(
        Species ~ PetalLengthCm + PetalWidthCm,
        data = vis_training,
        method = "knn",
        preProcess = c("center", "scale")
    )
} else {
    vis_scale <- scale(vis_training[, c("PetalLengthCm", "PetalWidthCm")])
    vis_model_knn <- list(
        training = vis_scale,
        species = vis_training$Species,
        center = attr(vis_scale, "scaled:center"),
        scale = attr(vis_scale, "scaled:scale")
    )
}

grid_points <- expand.grid(
    PetalLengthCm = seq(min(vis_training$PetalLengthCm) - 0.5,
                                            max(vis_training$PetalLengthCm) + 0.5,
                                            length.out = 200),
    PetalWidthCm = seq(min(vis_training$PetalWidthCm) - 0.2,
                                         max(vis_training$PetalWidthCm) + 0.2,
                                         length.out = 200)
)

if (use_caret) {
    grid_points$Species <- predict(vis_model_knn, newdata = grid_points)
} else {
    grid_scaled <- scale(
        grid_points[, c("PetalLengthCm", "PetalWidthCm")],
        center = vis_model_knn$center,
        scale = vis_model_knn$scale
    )
    grid_points$Species <- class::knn(
        train = vis_model_knn$training,
        test = grid_scaled,
        cl = vis_model_knn$species,
        k = 5
    )
}

decision_plot <- ggplot() +
    geom_tile(
        data = grid_points,
        aes(x = PetalLengthCm, y = PetalWidthCm, fill = Species),
        alpha = 0.25
    ) +
    geom_point(
        data = vis_training,
        aes(x = PetalLengthCm, y = PetalWidthCm, color = Species),
        size = 3
    ) +
    scale_fill_manual(values = c("Iris-setosa" = "#F8766D", "Iris-versicolor" = "#7CAE00", "Iris-virginica" = "#00BFC4")) +
    scale_color_manual(values = c("Iris-setosa" = "#C00000", "Iris-versicolor" = "#2E8B57", "Iris-virginica" = "#1F4E79")) +
    labs(
        title = "KNN Decision Regions for Iris Species",
        x = "Petal Length (cm)",
        y = "Petal Width (cm)"
    ) +
    theme_minimal()

print(decision_plot)
ggsave("iris_knn_decision_regions.png", decision_plot, width = 8, height = 6, dpi = 300)
