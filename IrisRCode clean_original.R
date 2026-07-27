 df=read.csv(Filepath von euch)
 View(df)
 str(df)
 df$Model=NULL
 df$Id <- NULL

 set.seed(42)
 n= nrow(df)
 trainingsize= round(n*0.6)

 trainingCase= sample(n, trainingsize)
 trainingCase

 training=df[trainingCase,]
 test= df[-trainingCase,]
 View(test)
 View(training)

 model_knn <- train(Species ~ .,data = training,method = "knn")
 predictions= predict(model_knn, test)
 
 predictions

 head(predictions)

 confusionMatrix(as.factor(predictions), as.factor(test$Species))

 mean(predictions==test$Species)
