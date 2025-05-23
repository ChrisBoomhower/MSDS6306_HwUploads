##########################################################
## Author: Chris Boomhower                              ##
## MSDS 6306 - Homework 4                               ##
## 05/28/2016                                           ##
##                                                      ##
## Instructions: Write bootstrap code to                ##
## illustrate the central limit theorem in              ##
## R markdown and push the result to GitHub.            ##
## Use a normal distribution with two different         ##
## sample sizes and an exponential distribution         ##
## with two different sample sizes. Correct code        ##
## alone is insufficient. Please also comment on        ##
## the code and explain the results. For help,          ##
## see the lotsa.medians function in unit 2. The        ##
## deliverable is a link to a GitHub repo containing    ##
## the code.                                            ##
##########################################################

##########################################################
## Function: sampFunc()
## Inputs:   n == number of sample data to collect
##           nsim == number of bootstrap sample repeats
##           distType == distribution type specifier
## Outputs:  xbar == norm dist. sample mean
##           sdRSample == norm dist. sample standard deviation
##           bootmean == vector of bootstrap sample means
##           (print) --> random sample summary statistics
##           (plots) --> histogram of sample data
##
## Description: Receives number and type of samples to be 
##              generated and number of bootstrap samples to
##              collect, produces bootstrap samples, and
##              returns the sample mean, sample standard 
##              deviation, and bootstrap sample means.
###########################################################

sampFunc <- function(n, nsim, distType) {
    
    ## Run conditional statement to collect sample based on normal or exponential distribution
    ## and generate histogram of sample data with correct title
    if(distType == "n") {
        rsample <- rnorm(n, 50, 4)
        hist(rsample, main = paste("RNORM Sample Size of", n), col = "indianred1")
    }
    else if(distType == "e") {
        rsample <- rexp(n)
        hist(rsample, main = paste("REXP Sample Size of", n), col = "indianred1")
    }
    
    ## Assign sample standard deviation and mean to variables
    sdRSample <- sd(rsample)
    xbar <- mean(rsample)
    
    ## Print random sample summary results to screen
    cat("Random sample summary statistics:\n")
    print(summary(rsample))
    
    ## Initialize bootmean vector as numeric type of size 'nsim'
    bootmean <- numeric(nsim)
    
    ## Run bootstrap sequence and save bootsample means to bootmean vector
    for (i in 1:nsim){
        bootsample <- sample(rsample, size = length(rsample), replace = TRUE)
        bootmean[i] <- mean(bootsample)
    }
    
    ## Return sample mean, standard deviation, and vector of bootsrap means
    return(c(xbar,sdRSample,bootmean))
}

##########################################################
## Function: analyze()
## Inputs:   N == number of sample data to collect
##           repeats == number of bootstrap sample repeats
##           DistTYPE == distribution type specifier
## Outputs:  (print) --> random sample's summary statistics
##           (print) --> bootstrap sample's summary statistics
##           (print) --> bootstrap sample's standard deviation
##           (print) --> standard error of the sample mean
##           (plots) --> histogram of bootstrap means
##
## Description: Receives number and type of samples to be 
##              generated and number of bootstrap samples to
##              collect, and passes these values to the
##              sampFunc() function. Processes sampFunc()
##              returned values and produces bootstrap mean
##              summary statistics, and standard error of
##              the sample mean. Additionally, bootstrap mean
##              histograms are plotted for comparison to sample
##              histograms and random sample's and bootstrap 
##              sample's standard deviations are displayed.
###########################################################

analyze <- function(N, repeats, DistTYPE) {
    
    ## Obtain sample mean, sample sd, and bootstrap mean from random distribution
    funcReturn <- sampFunc(N, repeats, DistTYPE)
    sampleMean <- funcReturn[1]
    sampleSD <- funcReturn[2]
    BOOTMean <- funcReturn[-1:-2]
    
    ## Print bootstrap mean summary results to screen
    cat("Bootstrap sample's summary statistics:\n")
    print(summary(BOOTMean))
    
    ## Run conditional statement to print correct histogram
    ## title for normal vs. exponential distribution bootstrap mean data
    if(DistTYPE == distNorm) {
        hist(BOOTMean, main = paste("Bootstrapped RNORM Sample Size of", N),
             xlab = "Bootstrap sample", col = "darkolivegreen1")
    }
    else if(DistTYPE == distExp) {
        hist(BOOTMean, main = paste("Bootstrapped REXP Sample Size of", N),
             xlab = "Bootstrap sample", col = "darkolivegreen1")
    }
    ## Add sample mean and bootstrap mean of means lines for comparison in bootstrap histogram
    abline(v = sampleMean, col = "indianred1", lwd = 2)
    abline(v = mean(BOOTMean), col = "darkgreen", lwd = 2, lty = 3)
    
    # Print random sample and bootstrap standard deviations and standard error
    print(paste("Random sample's standard deviation =",round(sampleSD,4)))
    print(paste("Bootstrap means' standard deviation =",round(sd(BOOTMean),4)))
    print(paste("Standard error of the sample mean =",round((sampleSD/sqrt(N)),4)))
}

## Initialize variables
repeats <- 2000 # Number of bootstrap samples to collect
distNorm <- "n" # Normal distribution selection
distExp <- "e" # Exponential distribution selection
samp1 <- 100
samp2 <- 10

## Set graphical parameters for histograms
par(mfrow = c(1, 2), cex.main = 0.8)  # 2 rows and 2 columns with title text shrink by 20%

## Demonstration of Central Limit Theorem
analyze(samp1, repeats, distNorm) # Normal Distribution 100 Samples
analyze(samp2, repeats, distNorm) # Normal Distribution 10 Samples
analyze(samp1, repeats, distExp) # Exponential Distribution 100 Samples
analyze(samp2, repeats, distExp) # Exponential Distribution 10 Samples