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

## Variables in tidy dataset
Below is the full list of variables in the tidy data set.

1, 2 - Subject and Activity used to aggregate data.

3 - 70 - Average mean and standard deviation of data collected from the accelerometers.

3. subject
4. activity
5. tBodyAcc.mean.X	
6. tBodyAcc.mean.Y	
7. tBodyAcc.mean.Z	
8. tBodyAcc.std.X	
9. tBodyAcc.std.Y	
10. tBodyAcc.std.Z	
11. tGravityAcc.mean.X	
12. tGravityAcc.mean.Y	
13. tGravityAcc.mean.Z	
14. tGravityAcc.std.X	
15. tGravityAcc.std.Y	
16. tGravityAcc.std.Z	
17. tBodyAccJerk.mean.X	
18. tBodyAccJerk.mean.Y	
19. tBodyAccJerk.mean.Z	
20. tBodyAccJerk.std.X	
21. tBodyAccJerk.std.Y	
22. tBodyAccJerk.std.Z	
23. tBodyGyro.mean.X	
24. tBodyGyro.mean.Y	
25. tBodyGyro.mean.Z	
26. tBodyGyro.std.X	
27. tBodyGyro.std.Y	
28. tBodyGyro.std.Z	
29. tBodyGyroJerk.mean.X	
30. tBodyGyroJerk.mean.Y	
31. tBodyGyroJerk.mean.Z	
32. tBodyGyroJerk.std.X	
33. tBodyGyroJerk.std.Y	
34. tBodyGyroJerk.std.Z	
35. tBodyAccMag.mean	
36. tBodyAccMag.std	
37. tGravityAccMag.mean	
38. tGravityAccMag.std	
39. tBodyAccJerkMag.mean	
40. tBodyAccJerkMag.std	
41. tBodyGyroMag.mean	
42. tBodyGyroMag.std	
43. tBodyGyroJerkMag.mean	
44. tBodyGyroJerkMag.std	
45. fBodyAcc.mean.X	
46. fBodyAcc.mean.Y	
47. fBodyAcc.mean.Z	
48. fBodyAcc.std.X	
49. fBodyAcc.std.Y	
50. fBodyAcc.std.Z	
51. fBodyAccJerk.mean.X	
52. fBodyAccJerk.mean.Y	
53. fBodyAccJerk.mean.Z	
54. fBodyAccJerk.std.X	
55. fBodyAccJerk.std.Y	
56. fBodyAccJerk.std.Z	
57. fBodyGyro.mean.X	
58. fBodyGyro.mean.Y	
59. fBodyGyro.mean.Z	
60. fBodyGyro.std.X	
61. fBodyGyro.std.Y	
62. fBodyGyro.std.Z	
63. fBodyAccMag.mean	
64. fBodyAccMag.std	
65. fBodyBodyAccJerkMag.mean	
66. fBodyBodyAccJerkMag.std	
67. fBodyBodyGyroMag.mean	
68. fBodyBodyGyroMag.std	
69. fBodyBodyGyroJerkMag.mean	
70. fBodyBodyGyroJerkMag.std	