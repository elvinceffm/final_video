Video Script — KNN Classification on the Iris Dataset
(5-minute team presentation)
1. Dataset Name
Iris Species (Kaggle)
Talking point: "For this project, our team selected the Iris Species dataset from Kaggle."
 
2. Why We Selected This Dataset
It contains 150 observations, well above the 100-observation minimum.
The data is clean and well-structured — no missing values, consistent formatting, and clearly labeled columns.
It's a classic dataset for classification problems, making it ideal for demonstrating how KNN works.
Talking point: "We chose Iris because it's a solid-sized dataset — 150 rows — that is already clean, which let us focus on the modeling process rather than heavy data wrangling."
 
3. What the Dataset Is About
The dataset describes three species of iris flowers: Iris-setosa, Iris-versicolor, and Iris-virginica.
Each species has 50 samples, for a balanced total of 150 observations.
Each flower is described by four physical measurements (in cm).
A well-known characteristic of this dataset: Iris-setosa is linearly separable from the other two species, while versicolor and virginica overlap and are harder to separate.
Talking point: "The dataset includes three iris species, 50 samples each, described by petal and sepal measurements. One species — setosa — is easy to separate from the others, but versicolor and virginica overlap more, making them trickier to classify."
 
4. Target Variable
Species — the categorical variable we want to predict (setosa / versicolor / virginica).
 
5. Predictor Variables
SepalLengthCm
SepalWidthCm
PetalLengthCm
PetalWidthCm
Talking point: "We used all four numeric measurements — sepal length, sepal width, petal length, and petal width — as predictors for the species."
 
6. Data Cleaning
Removed the Id column, since it was just a row index/line number and had no predictive value.
Removed a leftover Model column (set to NULL) that wasn't part of the analysis.
Verified the structure of the dataset with str(df) to confirm variable types (numeric measurements + character species label) before modeling.
Talking point: "Before modeling, we cleaned the data by removing the Id column, since it was only a row number and irrelevant to prediction. We also confirmed the variable types were correct using str()."
 
7. Splitting Data into Training and Test Sets
Set a random seed with set.seed(42) to make results reproducible.
Split the 150 observations into: 
Training set: 60% → 90 observations
Test set: 40% → 60 observations
Used sample() to randomly select training row indices, then created training and test data frames accordingly.
Talking point: "We set seed 42 for reproducibility and split the dataset randomly: 60% of the data — 90 rows — went into training, and 40% — 60 rows — went into the test set."
 
8. How KNN Works (in simple words)
KNN (K-Nearest Neighbors) classifies a new flower by looking at the 'k' most similar flowers already in the training data (based on how close their measurements are).
It then assigns the new flower to whichever species is most common among those neighbors — essentially a "vote."
We trained the model with train(Species ~ ., data = training, method = "knn") from the caret package, which automatically tests different values of k and picks the best-performing one.
Talking point: "KNN works by comparing a new flower's measurements to the closest matching flowers already in our training data, and then predicting the species that shows up most often among those neighbors — it's essentially a majority vote based on similarity."
 
9. Value of K Selected by the Model
k = 5
Talking point: "The caret package automatically tested several k values using resampling and selected k = 5 as the best-performing option — meaning the model looks at the 5 closest flowers to make each prediction."
 
10. Confusion Matrix Results
                    Reference
Prediction        Iris-setosa  Iris-versicolor  Iris-virginica
  Iris-setosa            16               0               0
  Iris-versicolor         0              19               1
  Iris-virginica          0               0              24
All 16 setosa and all 24 virginica test flowers were classified correctly.
Out of 20 versicolor flowers, 19 were correct, and just 1 was misclassified as virginica — consistent with the known overlap between these two species.
Talking point: "Our confusion matrix shows the model got every single setosa and virginica flower right. The only mistake was one versicolor flower predicted as virginica — which makes sense, since those two species are known to overlap."
 
11. Accuracy of the Model
Accuracy: 0.9833 (98.33%)
95% Confidence Interval: (0.9106, 0.9996)
Kappa: 0.9746
Talking point: "Overall, the model achieved an accuracy of 98.33% on the test set — an extremely high result, showing that KNN handled this classification task very well."
 
12. What Our Team Learned
KNN is a simple but powerful algorithm for classification problems, especially when classes are well separated (like setosa) — but it can still struggle slightly where classes overlap (versicolor vs. virginica).
Small, clean, well-labeled datasets like Iris make it easier to isolate and understand modeling concepts (train/test split, resampling, evaluation metrics) without the noise of messy data.
Evaluation metrics like the confusion matrix, accuracy, and Kappa give a fuller picture of model performance than accuracy alone — e.g., Kappa here (0.9746) confirms the high accuracy isn't just due to class imbalance.
Talking point: "This project taught us how a simple algorithm like KNN can achieve near-perfect results on well-behaved data, and how important it is to use multiple metrics — not just accuracy — to properly evaluate a model."
 
Closing
Talking point: "In summary, our KNN model, trained on 60% of the Iris dataset, achieved 98.33% accuracy on the test set, correctly identifying nearly every flower species based on just four simple measurements."
 

