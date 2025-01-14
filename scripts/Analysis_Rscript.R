
## Gagan Atreya
## Workshop: Factor Analysis in R
## Workshops for Ukraine
## February 1, 2024

#### Section 1. Introduction ####

## - See presentation html document

#### Section 2. Introduction to the data/ EDA ####

## Clear R environment:
rm(list=ls())

## Set digit options:
options(digits = 2)

## Set the working directory
## Use the project directory (downloaded from GitHub) as the working directory:
## [This is going to be different depending on your system]:
setwd("~/Desktop/factor_analysis_R_workshop/")

## Install/load R libraries using the "pacman" R package:
## This is easier than library(package1), library(package2), etc..
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, lavaan, vtable, 
               psych, scales, corrplot, 
               ggthemes, ggcharts, patchwork)

## Import the dataset that we will be using for the workshop:
ds <- read_csv("data/fa_dataset.csv", show_col_types = F)

## Briefly go over the dataset, variables, codebook, etc. 
vtable(ds)

## Variable: Sample size by Country
tbl01 <- table(ds$country)
tbl01

## Filter individual country datasets:
dsgmb <- ds %>% filter(country == "Gambia")
dspak <- ds %>% filter(country == "Pakistan")
dstza <- ds %>% filter(country == "Tanzania")
dsuga <- ds %>% filter(country == "Uganda")

## Plot: Sample size by country:
lp01 <- ds %>% 
  lollipop_chart(x = country,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Sample size by country")+
  theme_bw()

lp01

## Demographic variables for EDA:

# Country
# Age
# Gender
# Socio-economic status
# Religious affiliation
# Marital status
# Education

## Variable: Age
summary(ds$age)

ds %>% drop_na(age)%>%
ggplot(aes(x = age))+
  geom_histogram(color = "black",
                 fill = "gray",
                 bins = 50)+
  labs(x = "Age", 
       y = "Frequency", 
       title = "Age distribution (full sample)")+
  theme_bw()

ds %>% drop_na(age)%>%
ggplot(aes(x = age))+
  geom_histogram(color = "black",
                 fill = "gray",
                 bins = 50)+
  labs(x = "Age", 
       y = "Frequency", 
       title = "Age distribution by country")+
  facet_wrap(~country, nrow = 2)+
  theme_bw()

## Gender distribution by country
lp02 <- ds %>% 
  drop_na(gender, age) %>%
lollipop_chart(x = gender,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Gender distribution (full sample)")+
  theme_bw()

lp02

## Age and gender by country:
bp01 <- ds %>% drop_na(gender, age) %>% 
  ggplot(aes(y = age, 
             x = gender))+
geom_boxplot(fill = "grey")+
  labs(y = "Age",
       x = "",
       title = "Age and gender distribution by country")+
  facet_wrap(~country, nrow = 2)+
  coord_flip()+
  theme_bw()

bp01

## Variable: Socio-economic status
ds %>% drop_na(ses) %>%
lollipop_chart(x = ses,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Socioeconomic status (full sample)")+
  theme_bw()

sesgmb <- dsgmb %>% drop_na(ses) %>%
lollipop_chart(x = ses,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Gambia")+
  theme_bw()

sespak <- dspak %>% drop_na(ses) %>%
lollipop_chart(x = ses,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Pakistan")+
  theme_bw()


sestza <- dstza %>% drop_na(ses) %>%
lollipop_chart(x = ses,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Tanzania")+
  theme_bw()

sesuga <- dsuga %>% drop_na(ses) %>%
lollipop_chart(x = ses,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Uganda")+
  theme_bw()

## All four plots together:
sesplot <- (sesgmb | sespak) / (sestza | sesuga) 
sesplot + plot_annotation("Socio-economic status by country")

## Variable: Marital status
ds %>% drop_na(married) %>%
lollipop_chart(x = married,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Marital status (full sample)")+
  theme_bw()

maritalgmb <- dsgmb %>% drop_na(married) %>%
lollipop_chart(x = married,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Gambia")+
  theme_bw()

maritalpak <- dspak %>% drop_na(married) %>%
lollipop_chart(x = married,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Pakistan")+
  theme_bw()

maritaltza <- dstza %>% drop_na(married) %>%
lollipop_chart(x = married,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Tanzania")+
  theme_bw()

maritaluga <- dsuga %>% drop_na(married) %>%
lollipop_chart(x = married,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Uganda")+
  theme_bw()

## All four plots together:
maritalplot <- (maritalgmb | maritalpak) / (maritaltza | maritaluga) 
maritalplot + plot_annotation("Marital status by country")

## Variable: Religious affiliation
lp05 <- ds %>% drop_na(religion) %>%
lollipop_chart(x = religion,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Religious distribution (full sample)")+
  theme_bw()

lp05

religiongmb <- dsgmb %>% drop_na(religion) %>%
lollipop_chart(x = religion,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Gambia")+
  theme_bw()

religionpak <- dspak %>% drop_na(religion) %>%
lollipop_chart(x = religion,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Pakistan")+
  theme_bw()

religiontza <- dstza %>% drop_na(religion) %>%
lollipop_chart(x = religion,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Tanzania")+
  theme_bw()

religionuga <- dsuga %>% drop_na(religion) %>%
lollipop_chart(x = religion,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Uganda")+
  theme_bw()

## All four plots together:
religionplot <- (religiongmb | religionpak) / (religiontza | religionuga) 
religionplot + plot_annotation("Religious affiliation by country")

## Variable: Education
table(ds$education)

ds$education <- factor(ds$education, 
                       levels = c("No schooling", "High school or less",
                                   "Diploma", "Certificate", "Bachelors", 
                                   "Masters or above", "Other/unknown"))
table(ds$education)

lp05 <- ds %>% drop_na(education) %>%
lollipop_chart(x = education,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Education (full sample)")+
  theme_bw()

lp05

educationgmb <- dsgmb %>% drop_na(education) %>%
lollipop_chart(x = education,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Gambia")+
  theme_bw()

educationpak <- dspak %>% drop_na(education) %>%
lollipop_chart(x = education,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Pakistan")+
  theme_bw()

educationtza <- dstza %>% drop_na(education) %>%
lollipop_chart(x = education,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Tanzania")+
  theme_bw()

educationuga <- dsuga %>% drop_na(education) %>%
lollipop_chart(x = education,
               line_color = "black",
               point_color = "black")+
  labs(y = "Frequency",
       x = "",
       title = "Uganda")+
  theme_bw()

## All four plots together:
educationplot <- (educationgmb | educationpak) / (educationtza | educationuga) 
educationplot + plot_annotation("Education by country")

#### **Section 3. Exploratory Factor Analysis** ####

vtable(ds)

# To what extent do you agree with the following statements? 
# (1- Strongly Disagree to 7- Strongly Agree)
  
# Good leaders should:

## Leadership item 01:
# Seek out opportunities to bridge social divisions with their opponents, 
# enemies, opposition groups, or other relevant outgroups.
summary(ds$leadership01)

# Visualize with histogram using functions in R 
# We can use the same function for subsequent items

histfx01 <- function(data,
                     x_variable) {
  ggplot(data, 
         aes(x = !!sym(x_variable))) +
    geom_histogram(fill = "gray", 
                   color = "black", 
                   bins = 7) +
    labs(title = paste("Histogram of", x_variable),
         x = x_variable,
         y = "Count")+
    theme_bw()
}

histfx02 <- function(data,
                     x_variable) {
  ggplot(data, 
         aes(x = !!sym(x_variable))) +
    geom_histogram(fill = "gray", 
                   color = "black", 
                   bins = 7) +
    labs(title = paste("Histogram of", x_variable, "by Country"),
         x = x_variable,
         y = "Count")+
    facet_wrap(~country, nrow = 2)+
    theme_bw()
}

histfx01(ds, "leadership01")
histfx02(ds, "leadership01")

## Leadership item 02:
# Demonstrate willingness to compromise with their opponents, enemies, 
# opposition groups, or other relevant outgroups.  
summary(ds$leadership02)
histfx01(ds, "leadership02")
histfx02(ds, "leadership02")

## Leadership item 03:
# Try to understand and empathize with their opponents, enemies, 
# opposition groups, or other relevant outgroups.  
summary(ds$leadership03)
histfx01(ds, "leadership03")
histfx02(ds, "leadership03")

## Leadership item 04:
# Try to accurately represent the interests of the communities and groups 
# that they belong to. 
summary(ds$leadership04)
histfx01(ds, "leadership04")
histfx02(ds, "leadership04")

## Leadership item 05:
# Seek out opportunities to build stronger connections within the 
# communities and groups they belong to.
summary(ds$leadership05)
histfx01(ds, "leadership05")
histfx02(ds, "leadership05")

## Leadership item 06:
# Promote the interests of the communities and groups they belong to 
# even at the expense of other competing groups.
summary(ds$leadership06)
histfx01(ds, "leadership06")
histfx02(ds, "leadership06")

## Factor Analysis of group leadership endorsement ### 

## Create a "leadership" dataframe:
## Which has all 6 leadership items:
leadership <- cbind.data.frame(ds$leadership01, ds$leadership02, 
                               ds$leadership03, ds$leadership04, 
                               ds$leadership05, ds$leadership06)
names(leadership)

## Remove "ds$" from the column names:
names(leadership) <- sub('ds\\$', '', names(leadership))
names(leadership)

## Omit NA or missing values:
leadership <- na.omit(leadership)

## Examine correlation matrix:
mtx01 <- cor(leadership[, c(1:6)])
mtx01

## Visualize correlation matrix:

corrplot(mtx01, 
         method = "number", 
         number.cex = 0.7,
         col=c("white", "darkred", "red",
               "darkgrey", "blue", "darkblue"))

## Examine if factor analysis is appropriate

## The general criteria is that overall MSO for the KMO test needs to be greater than 0.60. 
## Based on the results (overall MSA = 0.69), factor analysis is appropriate.

## Bartlett's test of sphericity:
cortest.bartlett(leadership)

## The test is significant, again suggesting that factor analysis is appropriate.


## Kaiser-Meyer-Olkin factor adequacy test
KMO(r=cor(leadership))

## Parallel test
parallel <- fa.parallel(leadership)

## Based on the scree plot, factor analysis with two factors is the most appropriate. 
## We will proceed with promax rotation, which assumes that the items are inter-correlated 
## (that is, not independent from each other).

## Two factor model:
fit01 <- factanal(leadership, 2, rotation="promax")
fit01

# p-value > 0.05 suggests that two factors is sufficient 
# we cannot reject the null hypothesis that two factors captures
# "full dimensionality" in the dataset

#plot loadings for each factor
plot(
  fit01$loadings[, 1], 
  fit01$loadings[, 2],
  xlab = "Factor 1", 
  ylab = "Factor 2", 
  ylim = c(-1, 1),
  xlim = c(-1, 1),
  main = "Factor analysis of prostate data"
)
abline(h = 0, v = 0)

#add column names to each point
text(
  fit01$loadings[, 1] - 0.128, 
  fit01$loadings[, 2] + 0.128,
  colnames(leadership),
  col = "blue"
)


## We can observe a two factor structure 

## Factor 1: leadership01, leadership02, leadership03
## Factor 2: leadership04, leadership05, leadership06

## Refer to codebook to see if these factors are "coherent"

## Factor 01:

# item 1:
# Seek out opportunities to bridge social divisions with their opponents, 
# enemies, opposition groups, or other relevant outgroups.

# item 2:
# Demonstrate willingness to compromise with their opponents, enemies, 
# opposition groups, or other relevant outgroups. 

# item 3:
# Try to understand and empathize with their opponents, enemies, 
# opposition groups, or other relevant outgroups.  

## Call this factor: "Barrier Crossing Leadership"

## Factor 02:

# item 1:
# Try to accurately represent the interests of the communities and groups 
# that they belong to. 

# item 2:
# Seek out opportunities to build stronger connections within the 
# communities and groups they belong to.

# item 3:
# Promote the interests of the communities and groups they belong to 
# even at the expense of other competing groups.

## Call this factor: "Barrier bound leadership"

# The promax rotated FA output suggests that there are two factors:

# Factor 1 = Barrier Crossing Leadeship (BCL)"
# Factor 2 = Barrier Bound Leadership (BBL)"

# The two factors cumulatively explain 53% of the variance in the data. 
# Factor 1 explains 29% of the variance, Factor 2 explains 24%

#### Section 4. Confirmatory Factor Analysis #### 

# correlated two factor solution, marker method
names(leadership)

## Create two factor structure:
twofacs <- 'BCL =~ leadership01+leadership02+leadership03
            BBL =~ leadership04+leadership05+leadership06' 

## Fit the model:
cfa01 <- cfa(twofacs, 
             data = leadership, 
             std.lv = TRUE) 

summary(cfa01,
        fit.measures = TRUE,
        standardized = TRUE)


### Section 5. Reliability Analysis / Visualization ####

## Now, we can examine the "reliability" of each constructs represented by two factors:
BCL <- cbind.data.frame(ds$leadership01, ds$leadership02, ds$leadership03)

alph01 <- psych::alpha(BCL)
alph01
summary(alph01)

BBL <- cbind.data.frame(ds$leadership04, ds$leadership05, ds$leadership06)
alph02 <- psych::alpha(BBL)
alph02
summary(alph02)

## We can also visualize the two constructs and how they differ across countries:

## Create the actual construct, which is the average of three items:
ds$BCL <- (ds$leadership01+ds$leadership02+ds$leadership03)/3
ds$BBL <- (ds$leadership04+ds$leadership05+ds$leadership06)/3

## Visualize barrier crossing leadership:
summary(ds$BCL)
histfx01(ds, "BCL")
histfx02(ds, "BCL")

## Visualize barrier bound leadership:
summary(ds$BBL)
histfx01(ds, "BBL")
histfx02(ds, "BBL")

## We can also examine how BCL and BBL vary by country and gender
## (or any other variable that we might be curious about)

bp02 <- ds %>% drop_na(BCL, BBL, gender) %>% 
  ggplot(aes(y = BCL, 
             x = country))+
geom_boxplot(fill = "grey")+
  labs(y = "BCL",
       x = "",
       title = "Endorsement of BCL by country")+
  coord_flip()+
  theme_bw()

bp02

bp03 <- ds %>% drop_na(BCL, BBL, gender) %>% 
  ggplot(aes(y = BCL, 
             x = gender))+
geom_boxplot(fill = "grey")+
  labs(y = "BCL",
       x = "",
       title = "Gender differences in endorsement of BCL by country")+
  facet_wrap(~country, nrow = 2)+
  coord_flip()+
  theme_bw()

bp03

bp04 <- ds %>% drop_na(BCL, BBL, gender) %>% 
  ggplot(aes(y = BBL, 
             x = country))+
geom_boxplot(fill = "grey")+
  labs(y = "BBL",
       x = "",
       title = "Endorsement of BBL by country")+
  coord_flip()+
  theme_bw()

bp04

bp05 <- ds %>% drop_na(BCL, BBL, gender) %>% 
  ggplot(aes(y = BBL, 
             x = gender))+
geom_boxplot(fill = "grey")+
  labs(y = "BBL",
       x = "",
       title = "Gender differences in endorsement of BBL by country")+
  facet_wrap(~country, nrow = 2)+
  coord_flip()+
  theme_bw()

bp05

#### End of File ####

