library(ggplot2)
library(doBy)

## Data obtained in zipped form from GitHub at https://github.com/oreillymedia/doing_data_science
ClickDa <- read.csv("nyt15.csv") # Import data
str(ClickDa)

## Create age_group category
ClickDa$age_group <- cut(ClickDa$Age,c(-Inf,18,24,34,44,54,64,Inf)) # Categorize users by "<18","18-24","25-34","35-44","45-54","55-64", and "65+"
head(ClickDa) # Check to see that age_group categories added
levels(ClickDa$age_group) <- c("<18","18-24","25-34","35-44","45-54","55-64","65+") # Update category names (cut() created factor so we need to change the factor levels)
levels(ClickDa$age_group) # Confirm change
head(ClickDa)

## Explore Impressions by age_group
ggplot(data = ClickDa, aes(x=age_group, y=Impressions, fill=age_group)) +
    geom_boxplot() + stat_summary(fun.y=mean, geom="point", shape=23, size=3, fill="blue") +     # Add blue mean diamond marker to boxplot
    xlab("Age Group") + ylab("Number of Impressions") + ggtitle("Number of Impressions by Age Group")

## Add CTR column
ClickDb <- ClickDa
ClickDb$CTR <- ifelse(ClickDb$Impressions == 0, NA, ClickDb$Clicks/ClickDb$Impressions) # If Impressions value is 0, mark the CTR value as NA, otherwise calculate CTR

## Explore CTR by age_group
ggplot(data = na.omit(ClickDb), aes(x=age_group, y=CTR, fill=age_group)) +
    geom_boxplot() + stat_summary(fun.y=mean, geom="point", shape=23, size=3, fill="blue") +     # Add blue mean diamond marker to boxplot
    xlab("Age Group") + ylab("CTR (Clicks/Impressions)") + ggtitle("Click-Through-Rate by Age Group")

## Explore log of CTR by age_group for better distribution comparison (boxplot)
ggplot(data = na.omit(ClickDb), aes(x=age_group, y=log(CTR), fill=age_group)) +
    geom_boxplot() + stat_summary(fun.y=mean, geom="point", shape=23, size=3, fill="blue") +     # Add blue mean diamond marker to boxplot
    xlab("Age Group") + ylab("Logarithmic CTR (Clicks/Impressions)") + ggtitle("Logarithmic Click-Through-Rate by Age Group") # Provide labels

## Explore log of CTR by age_group for better distribution comparison (density plot)
ggplot(data = na.omit(ClickDb), aes(x=log(CTR), fill=age_group, color=age_group)) +
    geom_density(alpha = 0.1) +
    xlab("CTR (Clicks/Impressions") + ylab("Density") + ggtitle("Click-Through-Rate by Age Group") # Provide labels

## Create User segments based on click behaviour
ClickDc <- ClickDb
ClickDc$User.Seg[ClickDc$Impressions == 0] <- "NoImps"
ClickDc$User.Seg[ClickDc$Impressions > 0] <- "Imps"
ClickDc$User.Seg[ClickDc$Clicks > 0] <- "Clicks"

## Additional exploratory analysis
ggplot( subset( ClickDc, User.Seg == "Imps"), aes( x = CTR, colour = age_group)) + geom_density() # Look at CTR density for users with impressions but no clicks
ggplot( subset( ClickDc, User.Seg == "Clicks"), aes( x = CTR, colour = age_group)) + geom_density() # Look at CTR density for users with clicks
ggplot( subset( ClickDc, User.Seg == "Clicks"), aes( x = age_group, y = Clicks, colour = age_group)) + geom_boxplot() # Look at Clicks by age_group for users with clicks
ggplot( subset( ClickDc, User.Seg == "Clicks"), aes( x = Clicks, colour = age_group)) + geom_density() # Look at Clicks density for users with clicks

## Convert User.Seg column to factor and compare user click behaviour by demographics
ClickDc$User.Seg <- factor(ClickDc$User.Seg)
summaryBy( Impressions ~ User.Seg + Gender + age_group, data = ClickDc, FUN = c(length,mean,median)) # Provide Impression statistics by demographics (length denotes how many users from each demographic fall in each user segment)

## Additional summary statistics of interest
tapply(ClickDc$Impressions, ClickDc$age_group, summary) # Overall Impressions summary stats by age_group
tapply(ClickDc$Clicks, ClickDc$age_group, summary) # Overall Clicks summary stats by age_group
tapply(ClickDc$CTR, ClickDc$age_group, summary) # Overal CTR summary stats by age_group
