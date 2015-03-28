#############################
# Betsy Cannon (eac2225)
# STAT W4240 Section 02
# Homework 04 
# April 2, 2014
#
# The following code analyzes the federalist papers
#############################

#################
# Setup
#################

# include prepared functions
source('hw04.R')

# List enhancement via Gabor Grothendieck (https://stat.ethz.ch/pipermail/r-help/2004-June/053343.html)
# to enable easily returning two values from a function
list <- structure(NA,class="result")
"[<-.result" <- function(x,...,value) {
   args <- as.list(match.call())
   args <- args[-c(1:2,length(args))]
   length(value) <- length(args)
   for(i in seq(along=args)) {
     a <- args[[i]]
     if(!missing(a)) eval.parent(substitute(a <- v,list(a=a,v=value[[i]])))
   }
   x
}


#################
# Problem 1a
#################

##########################################
# Clean all of the data by removing non-letter characters and stopwords 
# and by stemming words using prepared function
preprocess.directory('fp_hamilton_train')
preprocess.directory('fp_hamilton_test')
preprocess.directory('fp_madison_train')
preprocess.directory('fp_madison_test')

##########################################

#################
# Problem 1b
#################

##########################################
# read in data from cleaned directories using prepared function
hamilton.train = read.directory('fp_hamilton_train_clean')
hamilton.test  = read.directory('fp_hamilton_test_clean')
madison.train  = read.directory('fp_madison_train_clean')
madison.test   = read.directory('fp_madison_test_clean')

##########################################

#################
# Problem 1c
#################

##########################################
# create a list of all of the text files
full_infiles = c(hamilton.train, hamilton.test, madison.train, madison.test)

# use prepared function to create a sorted dictionary of all the occuring words
full_dictionary = make.sorted.dictionary.df(full_infiles)

##########################################

#################
# Problem 1d
#################

##########################################
# Make a document-term matrix for each testing and training set
dtm.hamilton.train = make.document.term.matrix(hamilton.train, full_dictionary)
dtm.hamilton.test  = make.document.term.matrix(hamilton.test, full_dictionary)
dtm.madison.train  = make.document.term.matrix(madison.train, full_dictionary)
dtm.madison.test   = make.document.term.matrix(madison.test, full_dictionary)

##########################################

#################
# Problem 1e
#################

##########################################
# compute mu as 1/(the size of the dictionary)
D = dim(full_dictionary)[1]
mu = 1/D

# Compute vectors of log probabilities for each training and test case
logp.hamilton.train = make.log.pvec(dtm.hamilton.train, mu)
logp.hamilton.test  = make.log.pvec(dtm.hamilton.test, mu)
logp.madison.train  = make.log.pvec(dtm.madison.train, mu)
logp.madison.test   = make.log.pvec(dtm.madison.test, mu)

##########################################


#################
# Problem 2
#################

##########################################
# calculate the probabilities that any one of our training corpuses 
# was written by Hamilton
prior.hamilton = length(hamilton.train)/(length(hamilton.train)+length(madison.train))
prior.madison  = 1 - prior.hamilton
log.prior.hamilton = log(prior.hamilton)
log.prior.madison  = log(prior.madison)

# construct Naive Bayes function to predict author of a given paper
naive.bayes = function(logp.hamilton.train, logp.madison.train, 
    log.prior.hamilton, log.prior.madison, dtm.test) {

    # list to store classification results
    classification = list()

    # classify every document
    for (document in 1:dim(dtm.test)[1]) {
        # sum the log probabilites of the occurring words
        # (equivalent to multiplying all of the probabilites and then taking the log)
        hamilton.word.cond = t(logp.hamilton.train) %*% dtm.test[document,]
        madison.word.cond = t(logp.madison.train) %*% dtm.test[document,]

        log.prob.hamilton = log.prior.hamilton + hamilton.word.cond
        log.prob.madison  = log.prior.madison + madison.word.cond 

        # TRUE for Hamilton, FALSE for Madison
        classification = append(classification, log.prob.hamilton > log.prob.madison)
    }

    return(classification)
}


##########################################

#################
# Problem 3
#################

##########################################
# leave mu the same as before
mu

hamilton.results = naive.bayes(logp.hamilton.train, logp.madison.train, log.prior.hamilton, log.prior.madison, dtm.hamilton.test)
madison.results  = naive.bayes(logp.hamilton.train, logp.madison.train, log.prior.hamilton, log.prior.madison, dtm.madison.test)

# Find the error rates
percentage.correct = (sum(hamilton.results == TRUE) + sum(madison.results = FALSE))/(length(hamilton.results)+ length(madison.results))*100

true.positives = sum(hamilton.results == TRUE)/length(hamilton.results)
true.negatives = sum(madison.results == FALSE)/length(madison.results)
false.positives = sum(madison.results == TRUE)/length(madison.results)
false.negatives = sum(hamilton.results == FALSE)/length(hamilton.results)

percentage.correct
true.positives
true.negatives
false.positives
false.negatives

##########################################


#################
# Problem 4a
#################

##########################################
# calculate mus and store in a list
mus = c(1/(10*D), 1/D, 10/D, 100/D, 1000/D)

# initialize matrices to store errors
cv.proportion.correct = matrix(nrow=5, ncol=5)
cv.false.negatives = matrix(nrow=5, ncol=5)
cv.false.positives = matrix(nrow=5, ncol=5)

# function to randomly choose a subset and remove them from the data set
# indices are the group to sample from and n is number to select
set.seed(1) 
select.fold = function(indices, n) {
    selection = sample(indices, n)
    return(list(selection, indices[!(indices %in% selection)]))
}

# split data into 5 folds
# I've chosen to have the same number of Hamilton and Madison data points in each fold
# this will keep the log priors the same
selection.size = dim(dtm.hamilton.train)[1]/5
hamilton.indices = 1:dim(dtm.hamilton.train)[1]

hamilton = matrix(nrow=5, ncol=selection.size)
list[hamilton[1,], hamilton.indices] = select.fold(hamilton.indices, selection.size)
list[hamilton[2,], hamilton.indices] = select.fold(hamilton.indices, selection.size)
list[hamilton[3,], hamilton.indices] = select.fold(hamilton.indices, selection.size)
list[hamilton[4,], hamilton.indices] = select.fold(hamilton.indices, selection.size)
hamilton[5,] = hamilton.indices

selection.size = dim(dtm.madison.train)[1]/5
madison.indices = 1:dim(dtm.madison.train)[1]

madison = matrix(nrow=5, ncol=selection.size)
list[madison[1,], madison.indices] = select.fold(madison.indices, selection.size)
list[madison[2,], madison.indices] = select.fold(madison.indices, selection.size)
list[madison[3,], madison.indices] = select.fold(madison.indices, selection.size)
list[madison[4,], madison.indices] = select.fold(madison.indices, selection.size)
madison[5,] = madison.indices

# loop over the five different folds and run classifier for each
for (fold in 1:5){
    # limit dtm to selected documents
    dtm.hamilton = dtm.hamilton.train[hamilton[fold,],]
    dtm.madison = dtm.madison.train[madison[fold,],]

    dtm.hamilton.rest = dtm.hamilton.train[!(1:35 %in% hamilton[fold,]),]
    dtm.madison.rest = dtm.madison.train[!(1:15 %in% madison[fold,]),]

    for (j in 1:length(mus)) {
        mu = mus[j]

        # create log probability vectors with selected mu
        logp.hamilton = make.log.pvec(dtm.hamilton.rest, mu)
        logp.madison = make.log.pvec(dtm.madison.rest, mu)

        #run naive bayes classifier
        hamilton.results = naive.bayes(logp.hamilton, logp.madison, log.prior.hamilton, log.prior.madison, dtm.hamilton)
        madison.results  = naive.bayes(logp.hamilton, logp.madison, log.prior.hamilton, log.prior.madison, dtm.madison)

        # calculate and store errors
        cv.proportion.correct[fold,j] = (sum(hamilton.results == TRUE) + sum(madison.results == FALSE))/(length(hamilton.results)+ length(madison.results))
        cv.false.negatives[fold,j] = sum(hamilton.results == FALSE)/length(hamilton.results)
        cv.false.positives[fold,j] = sum(madison.results == TRUE)/length(madison.results)
    }
}


#Plot and save proportion correct
plot(log(mus), colMeans(cv.proportion.correct), main="5-fold CV Proportion Correct",
    xlab="log(mu)", ylab="Proportion Correct")
filename = 'hw04_04a-pc.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

#Plot and save false negatives
plot(log(mus), colMeans(cv.false.negatives), main="5-fold CV False Negatives",
    xlab="log(mu)", ylab="False Negatives")
filename = 'hw04_04a-fn.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

#Plot and save false postives
plot(log(mus), colMeans(cv.false.positives), main="5-fold CV False Positives",
    xlab="log(mu)", ylab="False Positives")
filename = 'hw04_04a-fp.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

##########################################

#################
# Problem 4c
#################

##########################################
#initialize lists to store true errors
nb.proportion.correct = list()
nb.false.negatives = list()
nb.false.positives = list()

# Find the naive bayes results for the testing sets and each mu

for (mu in mus) {
    logp.hamilton.train = make.log.pvec(dtm.hamilton.train, mu)
    logp.hamilton.test  = make.log.pvec(dtm.hamilton.test, mu)
    logp.madison.train  = make.log.pvec(dtm.madison.train, mu)
    logp.madison.test   = make.log.pvec(dtm.madison.test, mu)

    hamilton.results = naive.bayes(logp.hamilton.train, logp.madison.train, log.prior.hamilton, log.prior.madison, dtm.hamilton.test)
    madison.results  = naive.bayes(logp.hamilton.train, logp.madison.train, log.prior.hamilton, log.prior.madison, dtm.madison.test)

    nb.proportion.correct = append((sum(hamilton.results == TRUE) + sum(madison.results == FALSE))/
        (length(hamilton.results)+ length(madison.results)), nb.proportion.correct)
    nb.false.negatives = append(sum(hamilton.results == FALSE)/length(hamilton.results), nb.false.negatives)
    nb.false.positives = append(sum(madison.results == TRUE)/length(madison.results), nb.false.positives)
}


#Plot and save proportion correct
plot(log(mus), nb.proportion.correct, main="Testing Set Proportion Correct",
    xlab="log(mu)", ylab="Proportion Correct")
filename = 'hw04_04d-pc.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

#Plot and save false negatives
plot(log(mus), nb.false.negatives, main="Testing Set False Negatives",
    xlab="log(mu)", ylab="False Negatives")
filename = 'hw04_04d-fn.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()

#Plot and save false postives
plot(log(mus), nb.false.positives, main="Testing Set False Positives",
    xlab="log(mu)", ylab="False Positives")
filename = 'hw04_04d-fp.png'
dev.copy(device=png, file=filename, height=600, width=800)
dev.off()



##########################################

#################
# End of Script
#################


