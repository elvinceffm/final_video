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

predictors <- c("SepalLengthCm", "SepalWidthCm", "PetalLengthCm", "PetalWidthCm")
training_x <- training[, predictors]
test_x <- test[, predictors]
training_labels <- training$Species
test_labels <- test$Species

training_scaled <- scale(training_x)
test_scaled <- scale(
    test_x,
    center = attr(training_scaled, "scaled:center"),
    scale = attr(training_scaled, "scaled:scale")
)

evaluate_k <- function(k_value) {
    k_predictions <- class::knn(train = training_scaled, test = test_scaled, cl = training_labels, k = k_value)
    confusion <- table(Predicted = k_predictions, Actual = test_labels)

    data.frame(
        k = k_value,
        accuracy = mean(k_predictions == test_labels),
        iris_setosa = if ("Iris-setosa" %in% rownames(confusion) && "Iris-setosa" %in% colnames(confusion)) confusion["Iris-setosa", "Iris-setosa"] else 0,
        iris_versicolor = if ("Iris-versicolor" %in% rownames(confusion) && "Iris-versicolor" %in% colnames(confusion)) confusion["Iris-versicolor", "Iris-versicolor"] else 0,
        iris_virginica = if ("Iris-virginica" %in% rownames(confusion) && "Iris-virginica" %in% colnames(confusion)) confusion["Iris-virginica", "Iris-virginica"] else 0,
        misclassified = sum(confusion) - sum(diag(confusion)),
        stringsAsFactors = FALSE
    )
}

odd_k_values <- seq(1, 15, by = 2)
k_results <- do.call(rbind, lapply(odd_k_values, evaluate_k))
write.csv(k_results, "knn_k_summary.csv", row.names = FALSE)

build_confusion_rows <- function(k_value) {
    k_predictions <- class::knn(train = training_scaled, test = test_scaled, cl = training_labels, k = k_value)
    confusion <- as.data.frame(table(Predicted = k_predictions, Actual = test_labels))
    confusion$k <- k_value
    confusion
}

k_confusions <- do.call(rbind, lapply(odd_k_values, build_confusion_rows))
write.csv(k_confusions, "knn_k_confusions.csv", row.names = FALSE)

make_decision_plot <- function(k_value) {
    vis_training <- training[, c("Species", "PetalLengthCm", "PetalWidthCm")]
    vis_scaled <- scale(vis_training[, c("PetalLengthCm", "PetalWidthCm")])

    grid_points <- expand.grid(
        PetalLengthCm = seq(min(vis_training$PetalLengthCm) - 0.5,
                            max(vis_training$PetalLengthCm) + 0.5,
                            length.out = 200),
        PetalWidthCm = seq(min(vis_training$PetalWidthCm) - 0.2,
                           max(vis_training$PetalWidthCm) + 0.2,
                           length.out = 200)
    )

    grid_scaled <- scale(
        grid_points[, c("PetalLengthCm", "PetalWidthCm")],
        center = attr(vis_scaled, "scaled:center"),
        scale = attr(vis_scaled, "scaled:scale")
    )

    grid_points$Species <- class::knn(
        train = vis_scaled,
        test = grid_scaled,
        cl = vis_training$Species,
        k = k_value
    )

    ggplot() +
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
            title = paste("KNN Decision Regions for Iris Species (k =", k_value, ")"),
            x = "Petal Length (cm)",
            y = "Petal Width (cm)"
        ) +
        theme_minimal() +
        theme(
            plot.background = element_rect(fill = "#faf9f5", color = NA),
            panel.background = element_rect(fill = "#faf9f5", color = NA),
            legend.background = element_rect(fill = "#faf9f5", color = NA),
            legend.key = element_rect(fill = "#faf9f5", color = NA),
            panel.grid.minor = element_blank()
        )
}

dir.create("knn_k_plots", showWarnings = FALSE)
manifest <- data.frame(
    k = odd_k_values,
    file = sprintf("knn_k_plots/knn_k_%02d.png", odd_k_values),
    stringsAsFactors = FALSE
)

for (k_value in odd_k_values) {
    plot_file <- sprintf("knn_k_plots/knn_k_%02d.png", k_value)
    decision_plot_k <- make_decision_plot(k_value)
    ggsave(plot_file, decision_plot_k, width = 8, height = 6, dpi = 300)
}

write.csv(manifest, "knn_k_manifest.csv", row.names = FALSE)

scatter_plot <- ggplot(training, aes(x = PetalLengthCm, y = PetalWidthCm, color = Species)) +
    geom_point(size = 3) +
    labs(title = "Iris Species Scatter Plot", x = "Petal Length (cm)", y = "Petal Width (cm)") +
    scale_color_manual(values = c("Iris-setosa" = "#C00000", "Iris-versicolor" = "#2E8B57", "Iris-virginica" = "#1F4E79")) +
    theme_minimal() +
    theme(
        plot.background = element_rect(fill = "#faf9f5", color = NA),
        panel.background = element_rect(fill = "#faf9f5", color = NA),
        legend.background = element_rect(fill = "#faf9f5", color = NA),
        legend.key = element_rect(fill = "#faf9f5", color = NA),
        panel.grid.minor = element_blank()
    )

print(scatter_plot)
ggsave("iris_scatter_plot.png", scatter_plot, width = 8, height = 6, dpi = 300)

decision_plot <- make_decision_plot(5)
print(decision_plot)
ggsave("iris_knn_decision_regions.png", decision_plot, width = 8, height = 6, dpi = 300)
