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
We evaluated a range of odd k values and used the best-performing one for the final story, which turned out to be k = 5.
Talking point: "KNN works by comparing a new flower's measurements to the closest matching flowers already in our training data, and then predicting the species that shows up most often among those neighbors — it's essentially a majority vote based on similarity."
 
9. Value of K Selected by the Model
k = 5
Talking point: "After comparing several odd k values, we chose k = 5 because it gave the best balance between local detail and smooth generalization."
 
10. Confusion Matrix Results
                    Reference
Prediction        Iris-setosa  Iris-versicolor  Iris-virginica
  Iris-setosa            16               0               0
  Iris-versicolor         0              19               2
  Iris-virginica          0               0              23
All 16 setosa flowers were classified correctly.
Out of 21 versicolor flowers, 19 were correct and 2 were misclassified as virginica, while all 23 virginica flowers were classified correctly.
Talking point: "Our confusion matrix shows the model got all of the setosa flowers right, and the only errors were a couple of versicolor cases near the overlap with virginica."
 
11. Accuracy of the Model
Accuracy: 0.9667 (96.67%)
Talking point: "Overall, the model achieved an accuracy of 96.67% on the test set — a strong result that still leaves room to explain where the classes overlap."
 
12. What Our Team Learned
KNN is a simple but powerful algorithm for classification problems, especially when classes are well separated (like setosa) — but it can still struggle slightly where classes overlap (versicolor vs. virginica).
Small, clean, well-labeled datasets like Iris make it easier to isolate and understand modeling concepts (train/test split, resampling, evaluation metrics) without the noise of messy data.
Evaluation metrics like the confusion matrix and accuracy give a fuller picture of model performance than a single headline number alone.
Talking point: "This project showed us how a simple algorithm like KNN can perform very well on a clean dataset, and how the overlap between versicolor and virginica makes the choice of k matter."
 
Closing
Talking point: "In summary, our KNN model, trained on 60% of the Iris dataset, achieved 96.67% accuracy on the test set and correctly identified almost every flower species based on just four simple measurements."
 

