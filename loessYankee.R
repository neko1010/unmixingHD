setwd("~/BSU/diss/ch2/data/plotData")

## data
#mesicYankee <- read.csv("./yankeeArea.csv")
mesicYankee <- read.csv("./yankee.csv")

mesicYankee$year = format(as.Date(mesicYankee$system.time_start, format = "%b %e, %Y"), "%Y")
mesicYankee = na.omit(mesicYankee)
#mesicYankee$mesicArea = as.numeric(gsub(",", "", mesicYankee$mesicArea))
mesicYankee = na.omit(mesicYankee)
#mesicYankee = subset(mesicYankee, mesicArea>0)
mesicYankee = subset(mesicYankee, mesic>0)

## make the date string a date object where %b is abbrev month, %d is decimal date, and %Y is 4 digit year
mesicYankee$date <- as.Date(mesicYankee$system.time_start, format = "%b %d , %Y")


## adding index variable column for loess
mesicYankee$index <- 1:nrow(mesicYankee)

mesicYankee.loess <- loess(mesic~index, data = mesicYankee, span = 0.4)
#mesicYankee.loess <- loess(mesicArea~index, data = mesicYankee, span = 0.70)
                      
## smooth it out
mesicYankee.smooth <- predict(mesicYankee.loess)

## plot
## set outer margins to make room for legend
#par(oma = c(2, 1, 1, 1))
plot(mesicYankee$mesic, x = mesicYankee$date, type = "p", xlab = "Date", ylab = "Mesic Area", pch = 16, col = "red")
#plot(mesicYankee$mesicArea, x = mesicYankee$date, type = "p", xlab = "Date", ylab = "Mesic Area", pch = 16, col = "red")
title("Yankee Fork mesic ecosystems dynamics", adj = 0.5)

lines(mesicYankee.smooth, x = mesicYankee$date, col = "red", lw = 2)

################ SPEI ####################

spei = read.csv("./speiYankee.csv")
spei$year = format(as.Date(spei$system.time_start, format = "%b %e, %Y"), "%Y")
spei = na.omit(spei)
## make the date string a date object where %b is abbrev month, %d is decimal date, and %Y is 4 digit year
spei$date <- as.Date(spei$system.time_start, format = "%b %d , %Y")

## adding index variable column for loess
spei$index <- 1:nrow(spei)

spei.loess <- loess(spei1y~index, data = spei, span = 0.4)

## smooth it out
spei.smooth <- predict(spei.loess)

### plot
### set outer margins to make room for legend
#par(oma = c(2, 1, 1, 1))
#plot(spei$spei1y, x = spei$date, type = "p", xlab = "Date", ylab = "SPEI value", pch = 16, col = "red")
#
#title("Yankee Fork Standardized Precipitation Evapotranspiration Index", adj = 0.5)

lines(spei.smooth, x = spei$date, col = "purple", lw = 2)

## ggplot
library(ggplot2)

mesicYankee$smooth = mesicYankee.smooth
spei$smooth = spei.smooth

## transformation to scale from 0-1 and the reverse
trnsfrm = function(x){
  z = (x - min(x)) / (max(x) - min(x))
  return(z)
}

reverse = function(z,x){
  y = z * (max(x) - (min(x))) + min(x) 
  return(y)
}

#spei$trns = trnsfrm(spei$smooth)
spei$trns = trnsfrm(spei$spei)

ggplot(data = mesicYankee, aes(x = date, y=mesic)) +
  geom_point(color = "red") +

  geom_line(aes(y = smooth, color="Mesic vegetation"), linewidth=1) + 
  geom_line(data = spei,  aes(x = date, y=trns, color = "SPEI"), linewidth=1) +
  geom_vline(aes(xintercept = as.Date("2012-06-01"), color = "Channel reconstruction"))+
  geom_vline(aes(xintercept = as.Date("2013-06-01"), color = "Riparian planting"))+
  geom_vline(aes(xintercept = as.Date("2015-06-01"), color = "Beavers establish"))+
  geom_vline(aes(xintercept = as.Date("2017-06-01"), color = "Flood event"))+
  
  scale_y_continuous(
    
    #limits = c(0,0.7),
    # Features of the first axis
    name = "Mesic Area (% of Valley Bottom)",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~reverse(., spei$smooth), name="SPEI value")
  ) + 


  scale_colour_manual(name  ="",
              breaks =c("Mesic vegetation", "SPEI", "Channel reconstruction", "Riparian planting", "Beavers establish", "Flood event"),
              values = c("Mesic vegetation" = "red", "SPEI" = "purple", "Channel reconstruction" = "black",
                         "Riparian planting" = "green", "Beavers establish" = "brown", "Flood event" = "blue")) 
  
  #ggtitle("Yankee Fork mesic ecosystem dynamics")
