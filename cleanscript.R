# load all data from both the train and test set

traindata <- read.table("UCI HAR Dataset/train/X_train.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainlabel <- read.table("UCI HAR Dataset/train/y_train.txt")
testdata <- read.table("UCI HAR Dataset/test/X_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testlabel <- read.table("UCI HAR Dataset/test/y_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# set headers
headers <- features$V2
names(traindata) <- headers
names(testdata) <- headers

# filter for mean and SD
filtered <- grepl("-mean\\(|-std\\(", headers)
trainfiltered <- traindata[,filtered]
testfiltered <- testdata[,filtered]

# Merge test and train data together
subject <- rbind(trainsubject, testsubject )
data <- rbind(trainfiltered, testfiltered)
label <- rbind(trainlabel, testlabel)
names(label) <- "Activity"
names(subject) <- "SubjectID"

combined <- cbind(subject,label, data)


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggdata <-aggregate(combined, by=list(combined$SubjectID,combined$Activity), 
                    FUN=mean)

df = subset(aggdata, select = -c(Group.1,Group.2) )
df$Activity <- as.factor(df$Activity)
levels(df$Activity) <- activitylabels$V2

# Save result dataset
write.table(df, file="./tidyset.txt", sep="\t", row.names=FALSE)
