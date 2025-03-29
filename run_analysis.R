packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip("dataFiles.zip", exdir = path)

dataset_path <- file.path(getwd(), "UCI HAR Dataset")
dir.exists(dataset_path)

activity_labels_path <- file.path(dataset_path, "activity_labels.txt")
features_path <- file.path(dataset_path, "features.txt")

if (!file.exists(activity_labels_path) | !file.exists(features_path)) {
  stop("Error: Required dataset files not found. Please check extraction.")
}

activityLabels <- fread(activity_labels_path, col.names = c("classLabels", "activityName"))
features <- fread(features_path, col.names = c("index", "featureNames"))

featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
if (length(featuresWanted) == 0) stop("Error: No matching features found for mean/std.")

measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)

train_X_path <- file.path(dataset_path, "train/X_train.txt")
train_Y_path <- file.path(dataset_path, "train/y_train.txt")
train_subject_path <- file.path(dataset_path, "train/subject_train.txt")


if (!file.exists(train_X_path) | !file.exists(train_Y_path) | !file.exists(train_subject_path)) {
  stop("Error: Training data files not found.")
}

train <- fread(train_X_path)[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)

trainActivities <- fread(train_Y_path, col.names = c("Activity"))
trainSubjects <- fread(train_subject_path, col.names = c("SubjectNum"))

if (nrow(trainActivities) == 0 | nrow(trainSubjects) == 0) stop("Error: Empty training data.")

train <- cbind(trainSubjects, trainActivities, train)

# Load and process test data
test_X_path <- file.path(dataset_path, "test/X_test.txt")
test_Y_path <- file.path(dataset_path, "test/y_test.txt")
test_subject_path <- file.path(dataset_path, "test/subject_test.txt")

if (!file.exists(test_X_path) | !file.exists(test_Y_path) | !file.exists(test_subject_path)) {
  stop("Error: Test data files not found.")
}

test <- fread(test_X_path)[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)

testActivities <- fread(test_Y_path, col.names = c("Activity"))
testSubjects <- fread(test_subject_path, col.names = c("SubjectNum"))

if (nrow(testActivities) == 0 | nrow(testSubjects) == 0) stop("Error: Empty test data.")

test <- cbind(testSubjects, testActivities, test)

# Merge train and test datasets
combined <- rbind(train, test)

# Convert activity labels to factors
combined[["Activity"]] <- factor(combined[, Activity], 
                                 levels = activityLabels[["classLabels"]], 
                                 labels = activityLabels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

# Reshape data
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

# Save the tidy dataset
data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)

print("Data processing complete. File saved as 'tidyData.txt'.")
