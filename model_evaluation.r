# Step 5: Evaluate the model
# Make predictions on the test set
predictions <- predict(model, newdata = test_set)

# Compute the mean squared error of the predictions
mse <- mean((predictions - test_set$sentiment_score)^2)
print(paste("Mean Squared Error: ", mse))

# Print a summary of the model
print(summary(model))