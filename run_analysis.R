#script for reworking and tidying the UCI HAR Dataset. Outputs "resultDF" dataframe

#read data and labels
y_test<-read.table("y_test.txt")
y_train<-read.table("y_train.txt")
subject_train<--read.table("subject_train.txt")
subject_test<--read.table("subject_test.txt")
x_test<-read.table("X_test.txt")
x_train<-read.table("X_train.txt")
features<-read.table("features.txt")
activities<-read.table("activity_labels.txt")

#matches variable labels to data
colnames(x_test)<-features$V2
colnames(x_train)<-features$V2


#stores the subject number as an additional col (nr 1) in the datasets
x_test<-cbind(subject_test,x_test)
names(x_test)[1]="subject"
x_train<-cbind(subject_train,x_train)
names(x_train)[1]="subject"


#stores the activity number as an additional col (last col) in the datasets
x_test<-cbind(x_test,y_test[,1])
names(x_test)[ncol(x_test)]="activity"
x_train<-cbind(x_train,y_train[,1])
names(x_train)[ncol(x_train)]="activity"

#stacks train and test data
alldata<-rbind(x_train,x_test)

#gets col index list with "mean" in the name, "std" in the name
colnumbers<-grep("[Mm]ean|std",colnames(alldata))

#add the first col (subjectnr) and last col (activity)
colnumbers<-c(1,colnumbers,ncol(alldata))

#reduce cols
colreduced<-alldata[,colnumbers]

#add new col (dummy variable) which is unique for each subject and activity combination
colreduced<-cbind(colreduced,(as.numeric(colreduced$subject)*10)+colreduced$activity)

# we produce the means per subject and activity
means<-by(colreduced[1:ncol(colreduced)-1], colreduced[ncol(colreduced)], colMeans,simplify = TRUE)

# reconstruct as DF
meansDF<-as.data.frame(do.call(rbind, means))

# move activity to col 2
resultDF<-meansDF[c(1,ncol(meansDF),2:(ncol(meansDF)-1))]

# rename measurements to not be the dummy variable
newnames<-lapply(1:nrow(resultDF),paste0,"th measurement")
rownames(resultDF)<-newnames

# make subjectnumber positive
resultDF$subject<-resultDF$subject*-1

#make activities named instead of numbered
activitylist<- activities[resultDF$activity,2]
resultDF$activity<-activitylist

#update colnames 3 to end to reflect that the averages are represented
newcolnames<-lapply(colnames(resultDF)[3:length(colnames(resultDF))],paste0," averaged")
colnames(resultDF)[3:length(colnames(resultDF))]<-newcolnames
