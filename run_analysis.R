library(plyr)
# 1. Merges the training and the test sets to create one data set.
xTrain <- read.table("train/X_train.txt")   
yTrain <- read.table("train/y_train.txt") 
subTrain <- read.table("train/subject_train.txt")  

xTest <- read.table("test/X_test.txt") 
yTest <- read.table("test/y_test.txt") 
subTest <- read.table("test/subject_test.txt") 

xData <- rbind(xTrain, xTest) 
yData <- rbind(yTrain, yTest) 
subjectData <- rbind(subTrain, subTest) 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")

wantedFeatures <- grep("(-(mean)\\(\\))|(-(std)\\(\\))", features[, 2])

xData <- xData[, wantedFeatures]

names(xData) <- features[wantedFeatures, 2]
# 3. Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt")

yData[, 1] <- activityLabels[yData[, 1], 2]

names(yData) <- "activity"
# 4. Appropriately labels the data set with descriptive variable names. 
names(subjectData) <- "subject"

mergedData <- cbind(subjectData,xData, yData)
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
finalData <- ddply(mergedData, .(subject, activity),function(x) c(colMeans(x[, 2:67])))

write.table(finalData, "averData.txt", row.name=FALSE)