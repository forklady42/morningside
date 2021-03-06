#############################
# Betsy Cannon, eac2225
# STAT W4240 
# Homework 01 , Problem 4
# 2014/02/05
#
# The following code loads the eigenfaces data and
# performs a set of simple loading and plotting functions
#############################

#################
# Setup
#################

#### This is the cropped yale data set
setwd("~/Documents/academic/teaching/STAT_W4240_2014_SPRG/hw/hw01")

# first include the relevant libraries
# note that a loading error might mean that you have to
# install the package into your R distribution.  From the
# command line, type install.packages("pixmap")
library(pixmap)

#################
# Problem 1a
#################

# paste or type in the given code here
face_01 = read.pnm(file = "CroppedYale/yaleB01/yaleB01_P00A-005E+10.pgm")

# now plot the data
plot(face_01)
# give it a nice title
title('hw01_01a: the first face')
# save the result
filename = 'hw01_01a.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

# extract the class and size

#----- START YOUR CODE BLOCK HERE -----#

#class of face_01
class(face_01)
face_01

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 1b
#################

# make face_01 into a matrix with the given command
face_01_matrix = getChannels(face_01)

# load a second face
face_02 = read.pnm(file = "CroppedYale/yaleB02/yaleB02_P00A-005E+10.pgm")
face_02_matrix = getChannels(face_02)

# combine two faces into a single data matrix and make that a pixmap
faces_matrix = cbind( face_01_matrix , face_02_matrix )
faces = pixmapGrey( faces_matrix )

# plot to verify
plot(faces)

# find min and max values 

#----- START YOUR CODE BLOCK HERE -----#

min(faces_matrix)
max(faces_matrix)


#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 1c
#################

# get directory structure
dir_list_1 = dir(path="CroppedYale/",all.files=FALSE)
dir_list_2 = dir(path="CroppedYale/",all.files=FALSE,recursive=TRUE)

# find lengths

#----- START YOUR CODE BLOCK HERE -----#

length(dir_list_1)
length(dir_list_2)

# dir_list_1 examples
dir_list_1[1:5]

#dir_list_2 examples
list(dir_list_2[10], dir_list_2[77], dir_list_2[2520])

#----- END YOUR CODE BLOCK HERE -----#

#################
# Problem 1d
#################

# the list of pictures (note the absence of 14 means that 31 corresponds to yaleB32)
pic_list = c( 05 , 11 , 31 )
view_list = c(  'P00A-005E+10' , 'P00A-005E-10' , 'P00A-010E+00')

# preallocate an empty list
pic_data = vector("list",length(pic_list)*length(view_list))
# initialize an empty matrix of faces data
faces_matrix = vector()

#----- START YOUR CODE BLOCK HERE -----#

# loop through the desired subjects and views to find all of the needed files
for(i in 1:length(pic_list)) {
	for(j in 1:length(view_list)) {
		filename = sprintf("CroppedYale/%s/%s_%s.pgm",
	        dir_list_1[pic_list[i]] , dir_list_1[pic_list[i]] , view_list[j])

		# read file and add to pic_data list
		pic_data[3*(i-1)+j] = read.pnm(file = filename)
	}
}

# convert to matrices and bind pic_data into the faces_matrix
faces_matrix = rbind(cbind(getChannels(pic_data[[1]]), getChannels(pic_data[[2]]), getChannels(pic_data[[3]])),
	cbind(getChannels(pic_data[[4]]), getChannels(pic_data[[5]]), getChannels(pic_data[[6]])),
	cbind(getChannels(pic_data[[7]]), getChannels(pic_data[[8]]), getChannels(pic_data[[9]]))
	)

#----- END YOUR CODE BLOCK HERE -----#

# now faces_matrix has been built properly.  plot and save it.
faces = pixmapGrey(faces_matrix)
plot(faces)
title('hw01_01d: 3x3 grid of faces')
# save the result
filename = 'hw01_01d.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

#################
# End of Script
#################


