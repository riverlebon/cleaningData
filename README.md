The run_analisys.R is an R script that creates a file with the averages of all the variables that correspond to the measurements of mean and standard deviations of some Samsung Data. The averages are calculated for each one of the 30 subjects who participated in the experiment aand for each one of six possible activities (such as standing, walking etc)

the script starts by reading both the training and test sets. Next, it selects only those columns that correspondo to "mean" and "std". When this is done, the script joins both sets into a large dataset.

Then, it substitutes in the dataset each code for the activities for its description.

Finally, for each one of the variables, the script calculates its average for each subject and for each activity. The results are kept in a data.frame which is later written to an external file named "averages.txt". 

the codebook.txt file shows the structure of the averages.txt file.
