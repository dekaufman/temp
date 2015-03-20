setwd("~/Admin/Training/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset")
library(dplyr)

# Read data
names <- read.table("features.txt")
x.train <- read.table("train/X_train.txt", col.names=names$V2)
x.test <- read.table("test/X_test.txt", col.names=names$V2)
act.names <- read.table("activity_labels.txt", col.names=c("ActID", "Activity"))
actIDs.train <- read.table("train/y_train.txt", col.names=c("ActID"))
actIDs.test <- read.table("test/y_test.txt", col.names=c("ActID"))

who.train <- read.table("train/subject_train.txt", col.names=c("Who"))
who.test <- read.table("test/subject_test.txt", col.names=c("Who"))

x.trainD <- tbl_df(x.train)
x.testD <- tbl_df(x.test)

# Put side-by-side data together
train <- cbind(x.train, actIDs.train, who.train)
# Merge with labels
train <- merge(train, act.names)
# Same for test set
test <- cbind(x.test, actIDs.test, who.test)
test <- merge(test, act.names)

# Combine test and training data sets
fulldata <- rbind(train, test)
statcols <- grep('mean|std', names(fulldata))
statcols <- c(1,statcols,563,564)
fullstats <- fulldata[,statcols]

# Get averages grouped by test subject and test activity
output <- aggregate(.~Who + Activity, fullstats, mean)
write.table(output,"AvgByActivityandSubject.txt",row.names = FALSE)
