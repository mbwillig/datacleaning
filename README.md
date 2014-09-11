datacleaning
============

The run_analysis.r script works by loading all data and labels as tables, namely:

y_test.txt, y_train.txt, subject_train.txt, subject_test.txt, X_test.txt, X_train.txt features.txt, activity_labels.txt.

Items from features.txt are added as columnnames to the X test and training set.

Subject numbers and activity numbers are added as extra columns from the y_train and y_test files to the x_train and x_test files.

The completed test and training data is stacked to form one dataframe.

The dataset is then filtered to only contain the columns containing "[Mm]ean" and/or "std" and the columns relating the to subject and activity .

Next a dummy variable is made such that each combination of subject and activity yields a unique value. This dummy variable is used to obtain a mean for all parameters per subject per activity.

further ajustments are cosmetic:

-rownames are in the format of "row#th measurement"
-the activity column is reworked to contain the activities written out instead of as number
-columnnames are updated to reflect that they now contain averages
-subjectnumbers are mae positive

The output is a size 180 * 88 dataframe listing each combination of subject and activity (a measurement) on a row.
With the exception of the subject and activity avariable all other columns contain averages of the input data for that combinaton of subject and activity.
