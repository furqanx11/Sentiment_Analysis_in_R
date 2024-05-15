# Source the scripts
csv_path <- "articles.csv"
#https://newsapi.org/
API_TOKEN1 <- ""
#https://www.thenewsapi.com/
API_TOKEN2 <- ""
print("Install all required libraries")
source("requirements.r", local = TRUE)
print("data_ingestion")
source("data_ingestion.r", local = TRUE)
print("data_transformation")
source("data_transformation.r", local = TRUE)
print("model_train")
source("model_train.r", local = TRUE)
print("model_evaluation")
source("model_evaluation.r", local = TRUE)