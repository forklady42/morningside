#############################
# Betsy Cannon
# STAT W4240 
# Homework 3, Problem 3
# March 5, 2014
#
# The following code loads the eigenfaces data and
# performs a set of simple loading and plotting functions
#############################

#################
# Setup
#################

# make sure R is in the proper working directory
# note that this will be a different path for every machine
#### Yale cropped data set
setwd("~/Documents/academic/teaching/STAT_W4240_2014_SPRG/hw/hw01")

# first include the relevant libraries
# note that a loading error might mean that you have to
# install the package into your R distribution.  

#################
# Problem 3a
#################

# load the data and use dist() to get a distance matrix

#----- START YOUR CODE BLOCK HERE -----#

generic.data = read.csv(file = "hw03_q3.csv")

# Find the distance between points only using x1, x2
distances = dist(generic.data[1:2])
distances = as.matrix(distances)
print(distances)

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 3b
#################

#----- START YOUR CODE BLOCK HERE -----#

# recursive function for k nearest neighbors (kNN)
kNN <- function(k, data, neighbor_dist, test) {

	# Don't want to match on self, so set distance to infinity
 	neighbor_dist[test] = Inf

	#argmin of neighbor_distances
 	minimum = which.min(neighbor_dist)

 	# Base case
 	if (k == 1) {
 		return(array(data$y[minimum]))
 	}

 	return(append(kNN(k-1, data, neighbor_dist, minimum), data$y[minimum]))
}


# Matrices to store mean square error
MSE_test = matrix(-1,10,20)
MSE_train = matrix(-1,10,20)

# Find the mean square errors
for (k in 1:10) {
	MSE_sum = 0
	for (point in 1:20) {
		# distances for only this point
		point_distances = distances[point,]

		y_predicted = mean(kNN(k, generic.data, point_distances, 1))
		y_actual = generic.data$y[point]

		# Calculate the mean squared error for each point
		if (point == 1) {
			MSE_test[k, 1] = (y_actual - y_predicted)^2
		} else {
			MSE_sum = MSE_sum + (y_actual - y_predicted)^2
		}
	}
	MSE_train[k, 1] = 1/20 * MSE_sum
}

print(MSE_test[,1])
print(MSE_train[,1])

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 3c
#################

#----- START YOUR CODE BLOCK HERE -----#

# Use the kNN() function written in 3b to test all points and calculate MSE as we go
for (k in 1:10) {
	for (test in 2:dim(generic.data)[1]) {
		MSE_sum = 0
		for (point in 1:20) {
			# distances for only this point
			point_distances = distances[point,]

			y_predicted = mean(kNN(k, generic.data, point_distances, test))
			y_actual = generic.data$y[point]

			# Calculate the mean squared error for each point
			if (point == test) {
				MSE_test[k, test] = (y_actual - y_predicted)^2
			} else {
				MSE_sum = MSE_sum + (y_actual - y_predicted)^2
			}
		}
		MSE_train[k, test] = 1/20 * MSE_sum
	}
}

print(MSE_test)
print(MSE_train)

# Mean MSE_test for each k, just so we can compare them
for (k in 1:10) {
	print(mean(MSE_test[k,]))
}

#----- END YOUR CODE BLOCK HERE -----#

#################
# End of Script
#################


