## Assignment for Getting and Cleaning Data course
## by Michael Vaughn, 6/20/2014

## build a tidy data set according to the assignment instructions

## load the raw data...
features <- read.table("features.txt")
activitylabels <- read.table("activity_labels.txt")
subjecttest <- read.table("test/subject_test.txt")
subjecttrain <- read.table("train/subject_train.txt")
Xtest <- read.table("test/X_test.txt")
Xtrain <- read.table("train/X_train.txt")
ytest <- read.table("test/y_test.txt")
ytrain <- read.table("train/y_train.txt")

## combine the test and training data
subjectall <- rbind(subjecttest, subjecttrain)
Xall <- rbind(Xtest, Xtrain)
yall <- rbind(ytest, ytrain)

## add subject numbers and activity labels
tidy <- cbind(yall, Xall)
tidy <- cbind(subjectall, tidy)

## change column names (2nd column of features file contains names for the X data)
colnames(tidy) <- c("Subject", "Activity", as.character(features[,2]))

## replace activity codes with activity names by converting integer column to factor
##  and defining levels using activity_labels file
tidy$Activity <- as.factor(tidy$Activity)
levels(tidy$Activity) <- activitylabels[,2]

## remove all columns that do not include "-mean()" or "-std()" in the name
##   (this is my interpretation of the instructions, so some columns for example 
##    that contain the text "Mean" are left out)
tidy <- tidy[, c("Subject", "Activity", as.character(features$V2[grepl("-mean\\(|-std\\(",features$V2)]))]

## Make the column names syntactically valid (to avoid error with some R functions)
colnames(tidy) <- make.names(colnames(tidy), unique = TRUE)

## clean up excessive "." characters created by make.names
colnames(tidy) <- gsub("..", "", colnames(tidy), fixed=TRUE)

## Create a second tidy data set with the average of each variable for each activity
##   and each subject. Use reshape2 library.

library(reshape2)
tidymelt <- melt(tidy, id=c("Subject","Activity"))
tidy2 <-  dcast(tidymelt, Subject + Activity ~ variable, mean)

## write out the tidy data set
write.table(tidy2, "tidy2.txt")  