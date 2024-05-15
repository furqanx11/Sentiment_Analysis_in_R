# load required packages
library(tidyverse)
library(syuzhet)
library(tidytext)
library(tm)
# import text dataset
df <- read.csv(csv_path)

# Text Cleaning
text.df <- tibble(text = str_to_lower(df$description))
text.df$text <- gsub("[[:punct:]]", "", text.df$text)
text.df$text <- gsub("[[:digit:]]", "", text.df$text)
text.df$text <- removeWords(text.df$text, stopwords("en"))


# Handling NA values
text.df$text[is.na(text.df$text)] <- "unknown"


# analyze sentiments using the syuzhet package based on the NRC sentiment dictionary
emotions <- get_nrc_sentiment(text.df$text)
emo_bar <- colSums(emotions)
emo_sum <- data.frame(count=emo_bar, emotion=names(emo_bar))

# create a barplot showing the counts for each of eight different emotions and positive/negative rating
p1 <- ggplot(emo_sum, aes(x = reorder(emotion, -count), y = count)) + 
  geom_bar(stat = 'identity') 

# Start PNG device
png("plot.png")

# Your plot code
print(p1)

# Close the device
dev.off()

# sentiment analysis with the tidytext package using the "bing" lexicon
bing_word_counts <- text.df %>% unnest_tokens(output = word, input = text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) 

# select top 10 words by sentiment
bing_top_10_words_by_sentiment <- bing_word_counts %>% 
  group_by(sentiment) %>% 
  slice_max(order_by = n, n = 10) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, n)) 
bing_top_10_words_by_sentiment

# create a barplot showing contribution of words to sentiment
p2 <- bing_top_10_words_by_sentiment %>% 
  ggplot(aes(word, n, fill = sentiment)) + 
  geom_col(show.legend = FALSE) + 
  facet_wrap(~sentiment, scales = "free_y") + 
  labs(y = "Contribution to sentiment", x = NULL) + 
  coord_flip() 

# Start PNG device
png("plot2.png")

# Your plot code
print(p2)

# Close the device
dev.off()

# sentiment analysis with the tidytext package using the "loughran" lexicon
loughran_word_counts <- text.df %>% unnest_tokens(output = word, input = text) %>%
  inner_join(get_sentiments("loughran")) %>%
  count(word, sentiment, sort = TRUE) 

# select top 10 words by sentiment
loughran_top_10_words_by_sentiment <- loughran_word_counts %>% 
  group_by(sentiment) %>% 
  slice_max(order_by = n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n))
loughran_top_10_words_by_sentiment

# create a barplot showing contribution of words to sentiment
p3 <- loughran_top_10_words_by_sentiment %>% 
  ggplot(aes(word, n, fill = sentiment)) + 
  geom_col(show.legend = FALSE) + 
  facet_wrap(~sentiment, scales = "free_y") + 
  labs(y = "Contribution to sentiment", x = NULL) + 
  coord_flip() 

# Start PNG device
png("plot3.png")

# Your plot code
print(p3)

# Close the device
dev.off()

# Calculate sentiment scores
sentiment_scores <- get_sentiment(text.df$text)

# Add sentiment scores to the dataset
df$sentiment_score <- sentiment_scores

print(df$sentiment_score)



