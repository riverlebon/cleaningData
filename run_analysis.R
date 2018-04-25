# project
# Riv on Apr 24, 2018

# loading libraries
library(dplyr)
library(reshape2)

# 2. Extract only the measurements on the mean and standard deviation 
# for each measurement
# columns with mean and standard deviation
means_stds<-c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,
              122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,
              227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,
              348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,
              542,543)
# 4. Appropriately labels the data set with descriptive variable names.
labels<-c("subject_ID",
          "BodyAcc_mean_X","BodyAcc_mean_Y","BodyAcc_mean_Z","BodyAcc_std_X",
          "BodyAcc_std_Y","BodyAcc_std_Z","tGravityAcc_mean_X","tGravityAcc_mean_Y",
          "tGravityAcc_mean_Z","tGravityAcc_std_X","tGravityAcc_std_Y","tGravityAcc_std_Z",
          "tBodyAccJerk_mean_X","tBodyAccJerk_mean_Y","tBodyAccJerk_mean_Z","tBodyAccJerk_std_X",
          "tBodyAccJerk_std_Y","tBodyAccJerk_std_Z","tBodyGyro_mean_X","tBodyGyro_mean_Y",
          "tBodyGyro_mean_Z","tBodyGyro_std_X","tBodyGyro_std_Y","tBodyGyro_std_Z",
          "tBodyGyroJerk_mean_X","tBodyGyroJerk_mean_Y","tBodyGyroJerk_mean_Z","tBodyGyroJerk_std_X",
          "tBodyGyroJerk_std_Y","tBodyGyroJerk_std_Z","tBodyAccMag_mean","tBodyAccMag_std",
          "tGravityAccMag_mean","tGravityAccMag_std","tBodyAccJerkMag_mean","tBodyAccJerkMag_std",
          "tBodyGyroMag_mean","tBodyGyroMag_std","tBodyGyroJerkMag_mean","tBodyGyroJerkMag_std",
          "fBodyAcc_mean_X","fBodyAcc_mean_Y","fBodyAcc_mean_Z","fBodyAcc_std_X","fBodyAcc_std_Y",
          "fBodyAcc_std_Z","fBodyAccJerk_mean_X","fBodyAccJerk_mean_Y","fBodyAccJerk_mean_Z",
          "fBodyAccJerk_std_X","fBodyAccJerk_std_Y","fBodyAccJerk_std_Z","fBodyGyro_mean_X",
          "fBodyGyro_mean_Y","fBodyGyro_mean_Z","fBodyGyro_std_X","fBodyGyro_std_Y",
          "fBodyGyro_std_Z","fBodyAccMag_mean","fBodyAccMag_std","fBodyBodyAccJerkMag_mean",
          "fBodyBodyAccJerkMag_std","fBodyBodyGyroMag_mean","fBodyBodyGyroMag_std","fBodyBodyGyroJerkMag_mean",
          "fBodyBodyGyroJerkMag_std",
          "activity")

##---reading training data
tr_subject <- read.fwf("subject_train.txt",width=c(2))
#tr_x <- read.csv("project/train/X_train.txt",
tr_x <- read.csv("X_train.txt",header=F,sep="")
tr_y <- read.csv("y_train.txt",header=F,sep="")
# joining the three files
training_set <- data.frame(tr_subject[1],tr_x[means_stds],tr_y[1])
names(training_set)<-labels

##---reading testing data
te_subject <- read.fwf("subject_test.txt",width=c(2))
#tr_x <- read.csv("project/train/X_train.txt",
te_x <- read.csv("X_test.txt",header=F,sep="")
te_y <- read.csv("y_test.txt",header=F,sep="")
# joining the three files
testing_set <- data.frame(te_subject[1],te_x[means_stds],te_y[1])
names(testing_set)<-labels

# 1. Merges the training and the test sets to create one data set.
dataset<-rbind(training_set,testing_set)
rm(training_set)                # save room for new variables
rm(testing_set)

# 3. Use descriptive activity names to name the activities in the data set
act<-read.csv("activity_labels.txt",header=F,sep="")
dataset<-mutate(dataset,activity=factor(dataset$activity,act$V1,act$V2))

# 5. From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

# initialize resulting dataset
averages<-data.frame("",999,0,0,0,0,0,0)    # dummy first row
names(averages)<-c("variable","subject_ID",as.character(act$V2[1:6]))

for (i in 1:(length(labels)-2)) {      # for each variable (omit subj & activ)
    print(i)
    vindx  <-i+1
    vname<-labels[vindx]
    subds<-dataset[c(1,68,vindx)]      # select only subject,activity,variable
    # find mean of each subject x activity for current variable
    vmean<-dcast(subds,subject_ID ~ activity,mean,value.var=vname)
    variable <-rep(vname,length(vmean$subject_ID))    # repeat variable name
    # add rows for this variable to the resulting dataset
    averages<-rbind(averages,data.frame(variable,vmean))
}
# remove first (dummy) row
averages<-filter(averages,subject_ID!=999)

# Finally, save the averages 
write.table(averages,"averages.txt",row.names=FALSE)

