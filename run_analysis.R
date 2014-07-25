## STEP 0 - DOWNLOAD FILES

## dowload activity zip file
## require(downloader)
## fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download(fileurl, destfile = "./data/activity.zip", mode = "wb")
## unzip("./data/activity.zip", exdir = "./data/uzacity")


## STEP 1 - MERGE TRAINING AND TEST SETS TO CREATE ONE DATA SET WITH COLUMN LABELS

## Read the training, subject, and activity data from the training data set
setwd("../datasciencecoursera/data/uzacity/UCI HAR Dataset/train/")

## read the training files from excel  ?? try read.table from text later
traindf <- read.csv("./X_train.csv", colClasses = "numeric", header = FALSE)
subjtrain <- read.table("./subject_train.txt", header=FALSE, colClasses = "numeric")
ytrain <- read.table("./y_train.txt", header=FALSE, colClasses = "numeric")

## column bind subject, activity, and traing into a single training df
traindf <- cbind(subjtrain, ytrain, traindf)

## Read the training, subject, and activity data from the training data set

setwd("../test/")
testdf <- read.csv("./X_test.csv", colClasses = "numeric", header = FALSE)
subjtest <- read.table("./subject_test.txt", header=FALSE, colClasses = "numeric")
ytest <- read.table("./y_test.txt", header=FALSE, colClasses = "numeric")
testdf <- cbind(subjtest, ytest, testdf)

## merge the train and test data sets
merged_df <- rbind(traindf, testdf)

## Create Column names by c("subject", "activity", features)
## read features first, delete first column, and transpose it to make it
## a row vector; then pre-pend "subject" and "activity"

f <- read.table("../features.txt", header=FALSE, colClasses = "character")
f <-f[2]

##  t() function transposes a matrix or a data frame.
features <- t(f)
colLabels <- c("subject", "activity",features)
colnames(merged_df) <-colLabels

# merged_df should now have 10299 rows and563 columns with column names as "subject, "activity" and the 561 features
## from the features.txt

## STEP 2 - EXTRACT ONLY MEASUREMENTS ON MEAN AND STD DEVIATION FOR EACH OBSERVATION

## Get mean and standard deviation column indices for the merged df
meanFeatureIndices <- grep("mean\\(", features)
meanIndices <- meanFeatureIndices + 2

stdFeatureIndices <- grep("std\\(", features)
stdIndices <- stdFeatureIndices + 2

## meanIndices <- c(3,4,5,43,44,45,83,84,85,123,124,125,163,164,165, 203,216,229,242,255,268,269,270,347,348,349,426,427,428,505,518,531,544)
## stdIndices <- c(6,7,8,46,47,48,86,87,88,126,127,128,166,167,168,204,217,230,243,256,271,272,273,350,351,352,429,430,431,506,519,532,545)

mstd_df <- subset(merged_df, select = c(1,2,meanIndices,stdIndices))

## STEP 3 - USE DESCRIPTIVE ACTIVITY NAMES TO NAME ACTIVITIES IN THE DATA SET

al <- read.table("../activity_labels.txt", header=FALSE, colClasses = "character")
observation <- 1:nrow(mstd_df)

for (i in observation) { mstd_df[i,2] <- al[mstd_df[i,2],2] }

## STEP 4 - APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES

## Column names are pretty descriptive. Just removed "()" and "-" from the names

tidynames <- gsub("\\()","", colnames(mstd_df))
tidynames <- gsub("-", "", tidynames)
colnames(mstd_df) <- tidynames

## STEP 5 - CREATE A SECOND, INDEPENDENT, TIDY DATA SET WITH THE AVERAGE OF
## EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT

## get a feel for what activities each subject performed and how many times, and
## total number of observations of each type of activity
## table(mstd_df$subject, mstd_df$activity)
## sum(table(mstd_df$subject, mstd_df$activity))  ## must equal all observations
## colSums(table(mstd_df$subject, mstd_df$activity)) ## num of obs of each activity
## all subjects participated in all activities; so, the final tidt data set should
## have 30*6 = 180 rows and 66 variable + 2?
## Load the reshape2 library
library(reshape2)
tidy_df <- aggregate(. ~ activity + subject, data = mstd_df, mean)
write.table(tidy_df, "../tidy_df.txt", sep="\t")








