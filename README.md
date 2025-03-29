# ProgrammingAssignment3

## Overview
This script processes the **Human Activity Recognition (HAR) dataset** collected from the accelerometers of Samsung Galaxy smartphones. It extracts only the **mean and standard deviation** measurements, merges the training and test datasets, labels the activities, and outputs a cleaned dataset.

## Prerequisites
Ensure you have **R** installed on your system. The script also requires the following R packages:

```r
install.packages("data.table")
install.packages("reshape2")
```

## Dataset
The dataset is obtained from the UCI Machine Learning Repository:
- **Original Source:** [UCI HAR Dataset](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- The script downloads the dataset, extracts it, and processes it.

## How to Run the Script

### 1. Download and Extract the Dataset
If the dataset is not already extracted, the script will download and unzip it. Ensure you have an internet connection.

### 2. Execute the R Script
Run the script in R or RStudio:

```r
source("har_data_cleaning.R")
```

or execute it step by step in an interactive R session.

## Script Workflow

### Step 1: Load Required Libraries
The script uses **data.table** for efficient data handling and **reshape2** for reshaping data.

### Step 2: Download & Extract Dataset
- Checks if the dataset exists.
- If not, downloads the ZIP file and extracts it.

### Step 3: Read and Process Data
- Reads **activity labels** and **features**.
- Selects only the features related to **mean** and **standard deviation**.

### Step 4: Load Training and Test Data
- Reads **training** and **test** datasets (X, Y, subject files).
- Merges them into a single dataset.

### Step 5: Assign Descriptive Column Names
- Renames dataset columns for clarity.
- Uses descriptive activity names.

### Step 6: Create a Tidy Dataset
- Melts the dataset for reshaping.
- Computes the **average of each variable** for each subject-activity pair.
- Saves the final dataset as `tidyData.txt`.

## Output
- The cleaned dataset is saved as **tidyData.txt** in the working directory.
- It contains the **average of each variable** for each subject and activity.

## Troubleshooting
### 1. "Error: Dataset files not found."
- Ensure the dataset is extracted properly.
- Run `list.files(getwd(), recursive = TRUE)` to check if files exist.

### 2. "Error: No matching features found for mean/std."
- Ensure that `features.txt` is correctly loaded.

### 3. "File has size 0. Returning NULL data.table."
- The dataset might be corrupt. Try re-downloading it.
