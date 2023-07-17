library(ggplot2)
library(Metrics)
library(ggpubr)

setwd('BSU/diss/ch2/data/plotData')

## PRE
waterPre = read.csv('preWaterpts.csv') 
mesicPre = read.csv('preMesicpts.csv') 

## Water RF
waterPrecor = round(cor(waterPre$waterVal, waterPre$waterWRP, method = "pearson"), 2)
waterPremae = round(mae(waterPre$waterVal, waterPre$waterWRP), 2)
waterPrermse = round(rmse(waterPre$waterVal, waterPre$waterWRP), 2)

waterPreplot = ggplot(waterPre, aes(waterVal, waterWRP)) +
  geom_hex(bins = 10) +
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c(option = 'plasma') +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m surface water proportions", y="WRP surface water estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0( "MAE = ", waterPremae, "\nRMSE = ", waterPrermse))

waterPreplot

## Mesic RF
mesicPrecor = round(cor(mesicPre$mesicVal, mesicPre$mesicWRP, method = "pearson"), 2)
mesicPremae = round(mae(mesicPre$mesicVal, mesicPre$mesicWRP) , 2)
mesicPrermse = round(rmse(mesicPre$mesicVal, mesicPre$mesicWRP), 2)

mesicPreplot = ggplot(data = mesicPre, aes(mesicVal, mesicWRP)) +
  geom_hex(bins = 10) + 
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c() +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m mesic veg proportions", y="WRP mesic veg estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", mesicPremae, "\nRMSE = ", mesicPrermse))

mesicPreplot


## arrange onto single page
## http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
ggarrange(waterPreplot, mesicPreplot,
          labels = c("A", "B"),
          ncol = 2, nrow = 1)

## POST
waterPost = read.csv('postWaterpts.csv') 
mesicPost = read.csv('postMesicpts.csv') 

## Water RF
waterPostcor = round(cor(waterPost$waterVal, waterPost$waterWRP, method = "pearson"), 2)
waterPostmae = round(mae(waterPost$waterVal, waterPost$waterWRP), 2)
waterPostrmse = round(rmse(waterPost$waterVal, waterPost$waterWRP), 2)

waterPostplot = ggplot(waterPost, aes(waterVal, waterWRP)) +
  geom_hex(bins = 10) +
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c(option = 'plasma') +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m surface water proportions", y="WRP surface water estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0( "MAE = ", waterPostmae, "\nRMSE = ", waterPostrmse))

waterPostplot

## Mesic RF
mesicPostcor = round(cor(mesicPost$mesicVal, mesicPost$mesicWRP, method = "pearson"), 2)
mesicPostmae = round(mae(mesicPost$mesicVal, mesicPost$mesicWRP) , 2)
mesicPostrmse = round(rmse(mesicPost$mesicVal, mesicPost$mesicWRP), 2)

mesicPostplot = ggplot(data = mesicPost, aes(mesicVal, mesicWRP)) +
  geom_hex(bins = 10) + 
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c() +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m mesic veg proportions", y="WRP mesic veg estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", mesicPostmae, "\nRMSE = ", mesicPostrmse))

mesicPostplot


## arrange onto single page
## http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
ggarrange(waterPostplot, mesicPostplot,
          labels = c("A", "B"),
          ncol = 2, nrow = 1)

