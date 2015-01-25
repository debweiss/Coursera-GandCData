library(dplyr)

## Read in each of the needed .txt files 

subject_train <- read.table("train/subject_train.txt", header=FALSE)
X_train <- read.table("./train/X_train.txt", header=FALSE)
y_train <- read.table("./train/y_train.txt", header=FALSE)
subject_test <- read.table("test/subject_test.txt", header=FALSE)
X_test <- read.table("./test/X_test.txt", header=FALSE)
y_test <- read.table("./test/y_test.txt", header=FALSE)
features <- read.table("features.txt", header=FALSE, stringsAsFactors = FALSE)
activity_labels <- read.table("activity_labels.txt", header=FALSE)

## Create descriptive variable names for the Activity and Subject data in train and test files
## Criterion #4 for assignment (appropriately labels the data set with descriptive variable names)
## COMPLETE with this and features_row_names below

colnames(y_train) <- "Activity"
colnames(y_test) <- "Activity"
colnames(subject_train) <- "Subject"
colnames(subject_test) <- "Subject"

## Put all the feature names in a vector, use make.names to ensure that the feature names
## are R compliant, then use the features_row_names vector to name the columns in the
## X_train and X_test files (descriptive variable names) 

features_row_names <- features$V2
features_row_names <- make.names(features_row_names, unique=TRUE)
colnames(X_train) <- features_row_names
colnames(X_test) <- features_row_names

## Clip the data together, first for test, then for train

combined_test_data <- cbind(subject_test, y_test, X_test)
combined_train_data <- cbind(subject_train, y_train, X_train)

## Replace the activity numbers for train and test with their respective
## CRITERION #3 for the assignment (descriptive activity names to name the 
## activities in the data set) COMPLETE (although should really create a function for this)

combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "1", "Walking")
combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "2", "Walking_Upstairs")
combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "3", "Walking_Downstairs")
combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "4", "Sitting")
combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "5", "Standing")
combined_train_data$Activity <- replace(as.character(combined_train_data$Activity), combined_train_data$Activity == "6", "Laying")

combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "1", "Walking")
combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "2", "Walking_Upstairs")
combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "3", "Walking_Downstairs")
combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "4", "Sitting")
combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "5", "Standing")
combined_test_data$Activity <- replace(as.character(combined_test_data$Activity), combined_test_data$Activity == "6", "Laying")

## For train and test, select only the columns Subject, Activity, and any column that contains M/mean or std
## CRITERION #2 for assignment (Extracts only the measurements on the mean and standard deviation 
## for each measurement) COMPLETE 

combined_train_data <- select(combined_train_data, Subject, Activity, contains("mean"), contains("Mean"), contains("std"))
combined_test_data <- select(combined_test_data, Subject, Activity, contains("mean"), contains("Mean"), contains("std"))

## Now since each data set has exactly the same named columns, we can merge cleanly
## CRITERION #1 for assignment (merging the data) COMPLETE

combined_train_test <- merge(combined_train_data, combined_test_data, all.x=TRUE, all.y=TRUE)

## Now group by Subject then Activity

combined_train_test_group <- group_by(combined_train_test, Subject, Activity)

## Now to create our tidy data, we take the grouped data and use summarise_each to
## get the mean of each of the columns by group, which makes Criterion #5
## for the assignment COMPLETE

tidy_train_test <- summarise_each(combined_train_test_group, funs(mean))

## Last step is to write the tidy file out to a text file 

write.table(tidy_train_test, "tidy_data_DC.txt", row.names = FALSE)









