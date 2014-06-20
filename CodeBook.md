## Code Book

## Original data source
The project represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description of dataset is available at the site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment. 

The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Code
To prepare a tidy data set to satisfy the requirements of a course project, an R script called "run_analysis.R" was created. 
The script does the following.

1. Load row data from working directory.
```r
features <- read.table("features.txt")
activitylabels <- read.table("activity_labels.txt")
subjecttest <- read.table("test/subject_test.txt")
subjecttrain <- read.table("train/subject_train.txt")
Xtest <- read.table("test/X_test.txt")
Xtrain <- read.table("train/X_train.txt")
ytest <- read.table("test/y_test.txt")
ytrain <- read.table("train/y_train.txt")
```

2. Combine the test and training data.
```r
subjectall <- rbind(subjecttest, subjecttrain)
Xall <- rbind(Xtest, Xtrain)
yall <- rbind(ytest, ytrain)
```

3. Add subject numbers and activity labels
```r
tidy <- cbind(yall, Xall)
tidy <- cbind(subjectall, tidy)
```

4. Change column names (2nd column of features file contains names for the X data)
```r
colnames(tidy) <- c("Subject", "Activity", as.character(features[,2]))
```

5. Replace activity codes with activity names by converting integer column to factor and defining levels using activity_labels file
```r
tidy$Activity <- as.factor(tidy$Activity)
levels(tidy$Activity) <- activitylabels[,2]
```

6. Remove all columns that do not include "-mean()" or "-std()" in the name (this is my interpretation of the instructions, so some columns for example that contain the text "Mean" are left out)
```r
tidy <- tidy[, c("Subject", "Activity", as.character(features$V2[grepl("-mean\\(|-std\\(",features$V2)]))]
```

7. Make the column names syntactically valid (to avoid error with some R functions)
```r
colnames(tidy) <- make.names(colnames(tidy), unique = TRUE)
```

8. Clean up excessive "." characters created by make.names
```r
colnames(tidy) <- gsub("..", "", colnames(tidy), fixed=TRUE)
```

9. Create a second tidy data set with the average of each variable for each activity and each subject. Use reshape2 library.
```r
library(reshape2)
tidymelt <- melt(tidy, id=c("Subject","Activity"))
tidy2 <-  dcast(tidymelt, Subject + Activity ~ variable, mean)
```

10. write out the tidy data set
```r
write.table(tidy2, "tidy2.txt")  
```

## Variables in result dataset
Below is the full list of variables in the result data set.

1, 2 - Subject and Activity used to aggregate data.

3 - 68 - Average mean and standard deviation of data collected from the accelerometers.

1. subject
2. activity
3. tBodyAcc.mean.X	
4. tBodyAcc.mean.Y	
5. tBodyAcc.mean.Z	
6. tBodyAcc.std.X	
7. tBodyAcc.std.Y	
8. tBodyAcc.std.Z	
9. tGravityAcc.mean.X	
10. tGravityAcc.mean.Y	
11. tGravityAcc.mean.Z	
12. tGravityAcc.std.X	
13. tGravityAcc.std.Y	
14. tGravityAcc.std.Z	
15. tBodyAccJerk.mean.X	
16. tBodyAccJerk.mean.Y	
17. tBodyAccJerk.mean.Z	
18. tBodyAccJerk.std.X	
19. tBodyAccJerk.std.Y	
20. tBodyAccJerk.std.Z	
21. tBodyGyro.mean.X	
22. tBodyGyro.mean.Y	
23. tBodyGyro.mean.Z	
24. tBodyGyro.std.X	
25. tBodyGyro.std.Y	
26. tBodyGyro.std.Z	
27. tBodyGyroJerk.mean.X	
28. tBodyGyroJerk.mean.Y	
29. tBodyGyroJerk.mean.Z	
30. tBodyGyroJerk.std.X	
31. tBodyGyroJerk.std.Y	
32. tBodyGyroJerk.std.Z	
33. tBodyAccMag.mean	
34. tBodyAccMag.std	
35. tGravityAccMag.mean	
36. tGravityAccMag.std	
37. tBodyAccJerkMag.mean	
38. tBodyAccJerkMag.std	
39. tBodyGyroMag.mean	
40. tBodyGyroMag.std	
41. tBodyGyroJerkMag.mean	
42. tBodyGyroJerkMag.std	
43. fBodyAcc.mean.X	
44. fBodyAcc.mean.Y	
45. fBodyAcc.mean.Z	
46. fBodyAcc.std.X	
47. fBodyAcc.std.Y	
48. fBodyAcc.std.Z	
49. fBodyAccJerk.mean.X	
50. fBodyAccJerk.mean.Y	
51. fBodyAccJerk.mean.Z	
52. fBodyAccJerk.std.X	
53. fBodyAccJerk.std.Y	
54. fBodyAccJerk.std.Z	
55. fBodyGyro.mean.X	
56. fBodyGyro.mean.Y	
57. fBodyGyro.mean.Z	
58. fBodyGyro.std.X	
59. fBodyGyro.std.Y	
60. fBodyGyro.std.Z	
61. fBodyAccMag.mean	
62. fBodyAccMag.std	
63. fBodyBodyAccJerkMag.mean	
64. fBodyBodyAccJerkMag.std	
65. fBodyBodyGyroMag.mean	
66. fBodyBodyGyroMag.std	
67. fBodyBodyGyroJerkMag.mean	
68. fBodyBodyGyroJerkMag.std	