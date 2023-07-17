library(ggplot2)
library(Metrics)
library(ggpubr)
library(MASS)
library(viridis)

setwd('BSU/diss/ch2/data/plotData')

waterRF = read.csv('dryWater.csv') 
mesicRF = read.csv('dryMesic.csv') 

## Water RF
waterRFcor = round(cor(waterRF$waterVal, waterRF$waterWRP, method = "pearson"), 2)
waterRFmae = round(mae(waterRF$waterVal, waterRF$waterWRP), 2)
waterRFrmse = round(rmse(waterRF$waterVal, waterRF$waterWRP), 2)

waterRFplot = ggplot(waterRF, aes(waterVal, waterWRP)) +
  geom_hex(bins = 10) +
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c(option = 'plasma') +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m surface water proportions", y="WRP surface water estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0( "MAE = ", waterRFmae, "\nRMSE = ", waterRFrmse))

waterRFplot

## Mesic RF
mesicRFcor = round(cor(mesicRF$mesicVal, mesicRF$mesicWRP, method = "pearson"), 2)
mesicRFmae = round(mae(mesicRF$mesicVal, mesicRF$mesicWRP) , 2)
mesicRFrmse = round(rmse(mesicRF$mesicVal, mesicRF$mesicWRP), 2)

mesicRFplot = ggplot(data = mesicRF, aes(mesicVal, mesicWRP)) +
  geom_hex(bins = 10) + 
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c() +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m mesic veg proportions", y="WRP mesic veg estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", mesicRFmae, "\nRMSE = ", mesicRFrmse))

mesicRFplot


## arrange onto single page
## http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
ggarrange(waterRFplot, mesicRFplot,
          labels = c("A", "B"),
          ncol = 2, nrow = 1)
