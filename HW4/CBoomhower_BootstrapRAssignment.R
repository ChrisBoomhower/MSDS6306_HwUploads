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
## Function: normFunc
## Inputs:   n == number of samples
##           nsim == number of bootstrap sample repeats
## Outputs:  xbar == norm dist. sample mean
##           sdRSample == norm dist. sample std. dev.
##           bootmean == bootstrap sample means
##
## Description: Receives number of samples to be generated
##              and number of bootstrap samples to collect,
##              produces bootstrap samples, and returns the
##              sample mean, sample std. dev., and bootstrap
##              sample means.
###########################################################

normFunc <- function(n, nsim, distType) {
    if(distType == "n") {
        rsample <- rnorm(n, 50, 4)
        hist(rsample, main = paste("Histogram of RNORM Sample Size of", n))
    }
    else if(distType == "e") {
        rsample <- rexp(n)
        hist(rsample, main = paste("Histogram of REXP Sample Size of", n))
    }
    
    sdRSample <- sd(rsample)
    xbar <- mean(rsample)
    bootmean <- numeric(nsim)
    for (i in 1:nsim){
        bootsample <- sample(rsample, size = length(rsample), replace = TRUE)
        bootmean[i] <- mean(bootsample)
    }
    return(c(xbar,sdRSample,bootmean))
}

analyze <- function(N, repeats, DistTYPE) {
    funcReturn <- normFunc(N, repeats, DistTYPE)
    sampleMean <- funcReturn[1]
    sampleSD <- funcReturn[2]
    BOOTMean <- funcReturn[-1:-2]
    
    cat("Summary results\n")
    print(summary(BOOTMean))
    if(DistTYPE == distNorm) {
        hist(BOOTMean, main = paste("Histogram of Bootstrapped RNORM Sample Size of", N),
             xlab = "Bootstrap sample")
    }
    else if(DistTYPE == distExp) {
        hist(BOOTMean, main = paste("Histogram of Bootstrapped REXP Sample Size of", N),
             xlab = "Bootstrap sample")
    }
    print(paste("Bootmean sd =",sd(BOOTMean)))
    print(paste("Population sd/sqrt of sample size =",sampleSD/sqrt(N)))
    #return(NULL)
}

## Initialize variables
repeats <- 2000
distNorm <- "n"
distExp <- "e"
#xBAR <- numeric(1)
#bootMEAN <- numeric(repeats)
par(mfrow = c(2, 2))  # 2 rows and 2 columns

## Normal Distribution Sample 1 - Demonstration of Central Limit Theorem
analyze(100, repeats, distNorm)
analyze(30, repeats, distNorm)
analyze(100, repeats, distExp)
analyze(30, repeats, distExp)

