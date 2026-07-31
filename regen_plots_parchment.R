# Regenerate the knn_k_plots charts and scatter plot with the deck background
# color #f5f4ed. Model code and chart style are Emil's, unchanged; only the
# background is set so the charts blend into the slides.

library(ggplot2)

df <- read.csv("Iris.csv")
df$Id <- NULL

set.seed(42)
n <- nrow(df)
trainingCase <- sample(n, round(n * 0.6))
training <- df[trainingCase, ]

deck_bg <- "#f5f4ed"

bg_theme <- theme_minimal() +
  theme(
    plot.background   = element_rect(fill = deck_bg, colour = NA),
    panel.background  = element_rect(fill = deck_bg, colour = NA),
    legend.background = element_rect(fill = deck_bg, colour = NA),
    legend.key        = element_rect(fill = deck_bg, colour = NA)
  )

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
    bg_theme
}

dir.create("knn_k_plots", showWarnings = FALSE)
for (k_value in seq(1, 15, by = 2)) {
  plot_file <- sprintf("knn_k_plots/knn_k_%02d.png", k_value)
  ggsave(plot_file, make_decision_plot(k_value), width = 8, height = 6, dpi = 200, bg = deck_bg)
  cat("wrote", plot_file, "\n")
}

scatter_plot <- ggplot(training, aes(x = PetalLengthCm, y = PetalWidthCm, color = Species)) +
  geom_point(size = 3) +
  labs(title = "Iris Species Scatter Plot", x = "Petal Length (cm)", y = "Petal Width (cm)") +
  scale_color_manual(values = c("Iris-setosa" = "#C00000", "Iris-versicolor" = "#2E8B57", "Iris-virginica" = "#1F4E79")) +
  bg_theme

ggsave("iris_scatter_plot.png", scatter_plot, width = 8, height = 6, dpi = 200, bg = deck_bg)
ggsave("iris_knn_decision_regions.png", make_decision_plot(5), width = 8, height = 6, dpi = 200, bg = deck_bg)
cat("done\n")
