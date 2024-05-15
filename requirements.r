# List of required packages
required_packages <- c("readr", "tm", "SnowballC", "caret", "syuzhet", "lmtest", "dplyr", "jsonlite", "httr", "tidyverse", "tidytext")

# Install required packages
install_required_packages <- function(packages) {
  for (pkg in packages) {
    if (!(pkg %in% installed.packages())) {
      install.packages(pkg)
    }
  }
}

# Install required packages
install_required_packages(required_packages)
