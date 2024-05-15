library(httr)
library(jsonlite)
library(dplyr)

titles <- c()
descriptions <- c()
# Define the API endpoint
#url <- "https://newsapi.org/v2/everything?q=cyber+crime&sortBy=publishedAt&language=en&apiKey=1bae6898f04d4237bf6950973b479def"
url <- paste0("https://newsapi.org/v2/everything?q=cyber+crime&sortBy=publishedAt&language=en&apiKey=", API_TOKEN1)
# Make the API request
response <- GET(url)

# Check the status code of the response (should be 200)
if (http_status(response)$category == "Success") {
  # Parse the response to JSON
  content <- content(response, "text", encoding = "UTF-8")
  json <- fromJSON(content)
 
  for (title in seq_along(json$articles[[3]])) {
    titles <- c(titles, json$articles[[3]][[title]])  # Access the 'title' field of each article
  }
  
  for (des in seq_along(json$articles[[4]])) {
    descriptions <- c(descriptions, json$articles[[4]][[des]])  # Access the 'title' field of each article
  }
  
} else {
  print(paste("Failed to fetch data for page"))
}

df <- data.frame(
  title = titles,
  description = descriptions
)

# Initialize empty vectors to store the results
titles_2 <- c()
descriptions_2 <- c()

for (i in 1:100) {
  print(i)
  url <- "https://api.thenewsapi.com/v1/news/all"
  
  # Define the parameters
  params <- list(
    api_token = API_TOKEN2,
    language = "en",
    search = "cyber+crime",
    page = i
  )
  
  url_with_params <- paste0(url, "?", 
                            paste(names(params), 
                                  unlist(params), 
                                  sep = "=", 
                                  collapse = "&"))
  
  response <- GET(url_with_params)
  # Check if the request was successful
  if (http_status(response)$category == "Success") {
    # Parse the response to JSON
    content <- content(response, "text", encoding = "UTF-8")
    json <- fromJSON(content)
    
    
    # Extract data from each result and add to the vectors
    for (title in seq_along(json$data[[2]])) {
      titles_2 <- c(titles_2, json$data[[2]][[title]])  # Assuming 'id' is the first element
    }
    for (desc in seq_along(json$data[[2]])) {
      descriptions_2 <- c(descriptions_2, json$data[[3]][[desc]])  # Assuming 'id' is the first element
    }
  } else {
    print(paste("Failed to fetch data for page", i))
  }
  # Wait for 5 seconds before making the next request
  Sys.sleep(5)
}

# Convert vectors to data frame
df_2 <- data.frame(
  title = titles_2,
  description = descriptions_2
)

#combine the two dataframes
df_combined <- rbind(df, df_2)
print(dim(df_combined))

# Save the data to a CSV file
write.csv(df_combined, file = csv_path, row.names = FALSE)

print("Saved data to articles.csv")