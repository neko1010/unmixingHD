library(ggplot2)
library(Metrics)
library(MetricsWeighted)
library(ggpubr)
library(dplyr)

setwd('BSU/diss/ch2/data/plotData')

##water
water = read.csv('waterptsVB.csv')

## mesic
mesic = read.csv('mesicptsVB.csv') 

buckets = seq(0,9)

## Variance for each porportional 'bucket'
get_CI_water = function(i){
  sd = sd(filter(water, waterBuckets == i)$waterDiff)
  mean = mean(filter(water, waterBuckets == i)$waterDiff)
  z = sd*1.96
  return(c(mean - z, mean + z, sd))
}

get_CI_mesic = function(i){
  sd = sd(filter(mesic, mesicBuckets == i)$mesicDiff)
  mean = mean(filter(mesic, mesicBuckets == i)$mesicDiff)
  z = sd*1.96
  return(c(mean - z, mean + z, sd))
}

waterCIs = sapply(buckets, get_CI_water)

mesicCIs = sapply(buckets, get_CI_mesic)

## weights
waterW = data.frame(cbind(buckets, c(0.90030734,
           0.07454551845,
           0.01861225773,
           0.003832606545,
           0.001276113386,
           0.0004881052297,
           0.0003954078247,
           0.0003025900986,
           0.0002112036926,
           0.00002885701801)))
colnames(waterW) = c('waterBuckets', 'weight')

mesicW = data.frame(cbind(buckets, c(0.599815312,
           0.1387964738,
           0.082824864,
           0.04589356023,
           0.02811699074,
           0.01178773814,
           0.01482030626,
           0.0152389896,
           0.02633083345,
           0.03637493184)))
colnames(mesicW) = c('mesicBuckets', 'weight')

## join the dataframes
water = merge(water, waterW, by = "waterBuckets")
mesic = merge(mesic, mesicW, by = "mesicBuckets")

## unweighted vs weighted metrics
waterMAE = mean(water$waterDiffabs)
waterMAEw = mae(water$waterVal, water$waterWRP, water$weight)

waterSD = sd(water$waterDiffabs)
waterSDw = sqrt(weighted_var(water$waterDiffabs, water$weight))

mesicMAE = mean(mesic$mesicDiffabs)
mesicMAEw = mae(mesic$mesicVal, mesic$mesicWRP, mesic$weight)

mesicSD = sd(mesic$mesicDiffabs)
mesicSDw = sqrt(weighted_var(mesic$mesicDiffabs, mesic$weight))

pre = 0.29
post = 0.46
mesicCIpre = c(pre - 1.96*mesicSDw, pre + 1.96*mesicSDw)
mesicCIpre
z = 1.96*mesicSDw
z
mesicCIpost = c(post - 1.96*mesicSDw, post + 1.96*mesicSDw)
mesicCIpost

totalArea = 59432.53
preArea = pre*totalArea
postArea = post*totalArea
preCIarea = mesicCIpre * totalArea
postCIarea = mesicCIpost * totalArea
mesicSDwArea = mesicSDw*totalArea
zArea = 1.96*mesicSDwArea
zArea90 = 1.65*mesicSDwArea
z90 = 1.65*mesicSDw
