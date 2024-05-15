# Load the necessary libraries
library(readr)
library(tm)
library(SnowballC)
library(caret)
library(syuzhet)
library(lmtest)

# Step 1: Load the data
dataset <- read_csv(csv_path)

# Step 2: Preprocess the data
# Combine the title and description into one text
dataset$text <- paste(dataset$title, dataset$description)

# Create a text corpus
corpus <- Corpus(VectorSource(dataset$text))

# Clean the text
corpus_clean <- tm_map(corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords("english"))
corpus_clean <- tm_map(corpus_clean, stemDocument)

# Create a document-term matrix
dtm <- DocumentTermMatrix(corpus_clean)

# Convert the document-term matrix to a data frame
dataset_dtm <- as.data.frame(as.matrix(dtm))

# Compute sentiment scores
sentiment_scores <- get_sentiment(dataset$description, method = "bing")

# Add sentiment scores to the data frame
dataset_dtm$sentiment_score <- sentiment_scores

# Step 3: Train-test split
set.seed(123)
train_indices <- createDataPartition(dataset_dtm$sentiment_score, p = 0.8, list = FALSE)
train_set <- dataset_dtm[train_indices, ]
test_set <- dataset_dtm[-train_indices, ]

# Step 4: Train a model
model <- lm(sentiment_score ~ ., data = train_set)

