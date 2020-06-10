library(readr)
library(dplyr)

#aquire data
test.X <- read.table("./UCI HAR Dataset/test/X_test.txt")
train.X <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.Y <- read.table("./UCI HAR Dataset/train/Y_train.txt")
test.Y <- read.table("./UCI HAR Dataset/test/Y_test.txt")

#merge data into one df
df <- rbind(test.X,train.X)
df.Y <- rbind(test.Y,train.Y)
names(df.Y) <- c("Activity")

#pull in list of features
features <- read.table("./UCI HAR Dataset/features.txt")

#define helpful function to say if string contains values in meanstd
mean.std <- function(string) {
  meanstd <- c("mean()","std()")
  x <- FALSE
  for (i in meanstd) {
    if (grepl(i,string)){
      if (!grepl("meanFreq()",string)){
        x <- TRUE
        break
      }
    }
  }
  x
}

#create mask for features I want to include
mask <- c()
for (i in features$V2) {
  mask <- append(mask,mean.std(i))
}

#select columns with values TRUE in mask
df <- df[,mask]
names(df) <- features$V2[mask]
df <- cbind(df,df.Y)

#pull in list of activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Change activity from number to more decriptive value
df$Activity <- activities$V2[df$Activity]

#create table of mean by activity for each feature
mean.by.activity <- aggregate(df[,1:66], list(df$Activity), mean)