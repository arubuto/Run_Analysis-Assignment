#load the necessry packages for Run_analysis.R
library(dplyr)
library(reshape2)

#Read data and create tables

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

x_train <- read.table("X_train.txt", col.names = features$V2) #read data and assing column names from festures (STEP4)
subject_train <- read.table("subject_train.txt", col.names = "subject")
y_train <- read.table("y_train.txt", col.names = "activity")

x_test <- read.table("X_test.txt", col.names = features$V2) #read data and assing column names from festures (STEP 4)
subject_test <- read.table("subject_test.txt", col.names = "subject") 
y_test <- read.table("y_test.txt", col.names = "activity")

# STEP 1: merge the training and test data
mergeddata <- rbind(cbind(x_train, subject_train, y_train), cbind(x_test, subject_test, y_test))

# STEP 2: extract only the measurements on mean and std deviation for each measurements
needed_measurements <- grepl("subject|activity|mean|std", names(mergeddata)) #keeping activity and subject columns
extracted_data = mergeddata[, needed_measurements]

# STEP 3: use descriptive activity  names to name the activities
extracted_data$activity <- gsub("1", "walking", extracted_data$activity)
extracted_data$activity <- gsub("2", "going_up_stairs", extracted_data$activity)
extracted_data$activity <- gsub("3", "going_down_stairs", extracted_data$activity)
extracted_data$activity <- gsub("4", "sitting", extracted_data$activity)
extracted_data$activity <- gsub("5", "standing", extracted_data$activity)
extracted_data$activity <- gsub("6", "lying_down", extracted_data$activity)

# STEP 4:Appropriately labels the data set with descriptive variable name already done 
# while importing the data

#STEP 5

act_sub <- melt(extracted_data, id=c("subject","activity"))
tidy_data <- dcast(act_sub, subject+activity ~ variable, mean)


#write the tidy
write.table(tidy_data, "tidy_data.txt", row.names=FALSE)
