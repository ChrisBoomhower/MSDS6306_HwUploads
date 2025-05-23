library(tseries)

agioData <- get.hist.quote('AGIO',quote = "Close") #Import AGIO ticker data
length(agioData) #Check length od imported data
head(agioData)   #Check first few rows of imported data

agioLog <- log(lag(agioData)) - log(agioData) #Calculate the log returns of this data set
length(agioLog)  #log return calculation expected to reduce length of data by 1 due to subtraction
head(agioLog)    #Check first few rows of log return data

agioVol <- sd(agioLog) * sqrt(250) * 100 #Calculate the volatility (estimate for overall volatility of AGIO); roughly 250 trading days in a year and multiply by 100 for percentage
agioVol

## #Function to calculate volatility in continuous lookback (Courtesy of Dr. McGee)
Vol <- function(d, logrets){ #d is number of values back in time
    var = 0
    lam = 0 #exponential weight that is multiplied to each return
    varlist <- c()
    for(r in logrets){
        lam = lam*(1-1/d)+1
        var = (1-1/lam)*var+(1/lam)*r^2
        varlist <- c(varlist, var)
    }
    sqrt(varlist)
}

#Calculate estimated volatility with different weights
volest <- Vol(10,agioLog)
summary(volest)

volest2 <- Vol(30,agioLog)
summary(volest2)

volest3 <- Vol(100, agioLog)
summary(volest3)

plot(volest, type = "l") #High peaks correspond to significant fluctuations in AGIO at that time
lines(volest2, type = "l",col = "red")
lines(volest3, type = "l",col = "blue")
