#############################
# Betsy Cannon
# STAT W4240 
# Homework 3, Problem 4
# March 5, 2013
#
# The following code loads the eigenfaces data and
# performs a set of simple loading and plotting functions
#############################

#################
# Setup
#################

# make sure R is in the proper working directory
# note that this will be a different path for every machine

## Cropped Yale data set
#setwd("~/Documents/academic/teaching/STAT_W4240_2014_SPRG/hw/hw01")

# first include the relevant libraries
# note that a loading error might mean that you have to
# install the package into your R distribution.  
library(pixmap)
library(class)

#################
# Problem 4a
#################

views_4a = c('P00A+000E+00', 'P00A+005E+10', 'P00A+005E-10', 'P00A+010E+00' )

# load the data and save it as a matrix with the name face_matrix_4a

#----- START YOUR CODE BLOCK HERE -----#

# get directory structure
dir_list_1 = dir(path="CroppedYale/",all.files=FALSE)
dir_list_2 = dir(path="CroppedYale/",all.files=FALSE,recursive=TRUE)

# Initalize face_matrix_4a. Note that it will be a matrix after binding
face_matrix_4a = vector()

# Initialize name data frame
subjects = data.frame()
names = vector()
views = vector()

# loop through the desired subjects and views to find all of the needed files
for(i in dir_list_1) {
	for(j in 1:length(views_4a)) {
		filename = sprintf("CroppedYale/%s/%s_%s.pgm",
	        i , i , views_4a[j])

		# read file and add to pic_data list
		photo = read.pnm(file = filename)
		face_matrix_4a = rbind(face_matrix_4a, as.vector(getChannels(photo)))
		names = append(names, substr(i, 6, 7))
		views = append(views, views_4a[j])
	}
}

subjects = data.frame(names, views)

#----- END YOUR CODE BLOCK HERE -----#

# Get the size of the matrix for use later
fm_4a_size = dim(face_matrix_4a)
# Use 4/5 of the data for training, 1/5 for testing
ntrain_4a = floor(fm_4a_size[1]*4/5) # Number of training obs
ntest_4a = fm_4a_size[1]-ntrain_4a # Number of testing obs
set.seed(1) # Set pseudo-random numbers so everyone gets the same output
ind_train_4a = sample(1:fm_4a_size[1],ntrain_4a) # Training indices
ind_test_4a = c(1:fm_4a_size[1])[-ind_train_4a] # Testing indices

#----- START YOUR CODE BLOCK HERE -----#

# First 5 files of the training set
print(subjects[ind_train_4a[1:5],])

# First 5 files of the testing set
print(subjects[ind_test_4a[1:5],])

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 4b
#################

#----- START YOUR CODE BLOCK HERE -----#

# function to find nearest neighbor and predict level of test data
# returns matrix with first column being the predicted level and the second being the neighbor matched
oneNN <- function(training_data, test_data, levels) {

	# add test point to set and take transpose so every point is a row
	neighborhood = t(cbind(training_data, test_data))
 	neighbor_dist = as.matrix(dist(neighborhood))

 	neighbors = mat.or.vec(dim(test_data)[2],1)
 	predicted_level = mat.or.vec(dim(test_data)[2],1)

 	for (test in 1:dim(test_data)[2]) {
		# neighbor is argmin of neighbor_distances for training_data and given test point
	 	neighbor = which.min(neighbor_dist[dim(training_data)[2]+test,1:dim(training_data)[2]])
	 	neighbors[test] = neighbor
	 	predicted_level[test] = levels[neighbor]
	 }

 	return(cbind(predicted_level, neighbors))
}

# Function to prep data by running pca and then call oneNN to get a prediction
classify_tests <- function(face_matrix, subjects, ind_train, ind_test, ntrain, ntest) {
	# Find the mean face of training set
	mean_face = colMeans(face_matrix[ind_train,])

	# Subtract mean_face from training matrix
	centered_face_matrix = apply(face_matrix[ind_train,], 1, '-', mean_face)
	# apply switches the orientation of my matrix, so need to transpose
	centered_face_matrix = t(centered_face_matrix)

	# Run PCA on centered matrix
	train_pca = prcomp(centered_face_matrix)

	# Project training data onto first 25 loadings
	train_scores = mat.or.vec(25, ntrain)
	for (j in 1:length(ind_train)) {
		for (i in 1:25){
			train_scores[i,j] = train_pca$rotation[,i] %*% (face_matrix[ind_train[j],] - mean_face)
		}
	}

	# Project tests onto first 25 loadings
	test_scores = mat.or.vec(25, ntest)
	for (j in 1:length(ind_test)) {
		for (i in 1:25){
			test_scores[i,j] = train_pca$rotation[,i] %*% (face_matrix[ind_test[j],] - mean_face)
		}
	}

	# Use knn for k=1 to classify the testing scores
	# predictions = knn(t(train_scores), t(test_scores), subjects[ind_train,1], 1)
	predictions = oneNN(train_scores, test_scores, subjects[ind_train,1])

	# Compare predictions to actual classifications
	actual = subjects[ind_test,1]

	return(cbind(actual, predictions))
}

predictions_4a = classify_tests(face_matrix_4a, subjects, ind_train_4a, ind_test_4a, ntrain_4a, ntest_4a)
print(predictions_4a)

# Number of mispredictions
length(which(predictions_4a[,1] != predictions_4a[,2]))

# All agree, so no images to plot

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 4c
#################

# Use different lighting conditions

views_4c = c('P00A-035E+15', 'P00A-050E+00', 'P00A+035E+15', 'P00A+050E+00')

# load your data and save the images as face_matrix_4c

#----- START YOUR CODE BLOCK HERE -----#

# Initalize face_matrix_4c. Note that it will be a matrix after binding
face_matrix_4c = vector()

# Initialize name data frame
subjects_4c = data.frame()
names_4c = vector()
views_c = vector()

# loop through the desired subjects and views to find all of the needed files
for(i in dir_list_1) {
	for(j in 1:length(views_4c)) {
		filename = sprintf("CroppedYale/%s/%s_%s.pgm",
	        i , i , views_4c[j])

		# read file and add to pic_data list
		photo = read.pnm(file = filename)
		face_matrix_4c = rbind(face_matrix_4c, as.vector(getChannels(photo)))
		names_4c = append(names_4c, substr(i, 6, 7))
		views_c = append(views_c, views_4c[j])
	}
}

subjects_4c = data.frame(names, views)

#----- END YOUR CODE BLOCK HERE -----#

fm_4c_size = dim(face_matrix_4c)
# Use 4/5 of the data for training, 1/5 for testing
ntrain_4c = floor(fm_4c_size[1]*4/5)
ntest_4c = fm_4c_size[1]-ntrain_4c
set.seed(2) # Set pseudo-random numbers
# You are resetting so that if you have used a random number in between the last use of sample(), you will still get the same output
ind_train_4c = sample(1:fm_4c_size[1],ntrain_4c)
ind_test_4c = c(1:fm_4c_size[1])[-ind_train_4c]

#----- START YOUR CODE BLOCK HERE -----#

# Predict test results using function from 4b
predictions_4c = classify_tests(face_matrix_4c, subjects_4c, ind_train_4c, ind_test_4c, ntrain_4c, ntest_4c)

print(predictions_4c)
# Number of mispredictions
length(which(predictions_4c[,1] != predictions_4c[,2]))

#save plots of misidentified pairs
for (i in which(predictions_4c[,1] != predictions_4c[,2])) {
	# Adapted from side by side plotting in hw02_solutions.R
	misprediction = face_matrix_4c[ind_train_4c[predictions_4c[i,3]],]
	actual_face = face_matrix_4c[ind_test_4c[i],]
	dim(misprediction) = c(192,168)
	dim(actual_face) = c(192,168)
	side_by_side = cbind(misprediction, actual_face)
	side_by_side_pm = pixmapGrey(side_by_side)
	plot(side_by_side_pm)
	filename = sprintf('hw03_04c_%s.png', i)
	dev.copy(device=png, file=filename, height=600, width=800)
	dev.off()
}

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 4d
#################

#----- START YOUR CODE BLOCK HERE -----#

# Try 10 more random samples using the same seed and check their results
for (sample in 1:10) {

	print(c("Random sample #", sample))

	# keep sizes the same as in 4c and don't reset seed
	ind_train_4d = sample(1:fm_4c_size[1],ntrain_4c)
	ind_test_4d = c(1:fm_4c_size[1])[-ind_train_4c]

	predictions_4d = classify_tests(face_matrix_4c, subjects_4c, ind_train_4d, ind_test_4d, ntrain_4c, ntest_4c)
	print(c("Correctly identified: " , length(which(predictions_4d[,1] == predictions_4d[,2]))))
	print(c("Misidentified: " , length(which(predictions_4d[,1] != predictions_4d[,2]))))

}


#----- END YOUR CODE BLOCK HERE -----#

#################
# End of Script
#################


