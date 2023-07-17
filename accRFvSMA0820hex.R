library(ggplot2)
library(ggpubr)
library(Metrics)
library(MASS)
library(viridis)

setwd('~/BSU/diss/ch2/data/plotData')

waterRF = read.csv('040029_0820water.csv') 
waterSMA = read.csv('040029_0820waterSMA.csv') 
mesicRF = read.csv('040029_0820mesic.csv') 
mesicSMA = read.csv('040029_0820mesicSMA.csv')

## Water RF
waterRFcor = round(cor(waterRF$prop, waterRF$classification, method = "pearson"), 2)
waterRFnse = 1 - (sum(abs(waterRF$prop - waterRF$classification))**2/sum(abs(waterRF$prop - mean(waterRF$prop)))**2)
waterRFmae = round(mae(waterRF$prop, waterRF$classification) , 2)
waterRFrmse = round(rmse(waterRF$prop, waterRF$classification), 2)

waterRFplot = ggplot(waterRF, aes(prop, classification)) +
  geom_hex(bins = 10) +
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c(option = 'plasma') +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m surface water proportions", y="WRP surface water estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0( "MAE = ", waterRFmae, "\nRMSE = ", waterRFrmse))

waterRFplot

## Water SMA
waterSMAcor = round(cor(waterSMA$prop, waterSMA$band_0, method = "pearson"), 2)
waterSMAnse = 1 - (sum(abs(waterSMA$prop - waterSMA$band_0))**2/sum(abs(waterSMA$prop - mean(waterSMA$prop)))**2)
waterSMAmae = round(mae(waterSMA$prop, waterSMA$band_0) , 2)
waterSMArmse = round(rmse(waterSMA$prop, waterSMA$band_0), 2)

waterSMAplot = ggplot(data = waterSMA, aes(prop, band_0)) +
  geom_hex(bins = 10) +
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c(option = 'plasma') +
  scale_y_continuous(limits = c(0,1)) +
  labs(x="10 m surface water proportions", y="SMA surface water estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", waterSMAmae, "\nRMSE = ", waterSMArmse))

waterSMAplot  

## Mesic RF
mesicRFcor = round(cor(mesicRF$prop, mesicRF$classification, method = "pearson"), 2)
mesicRFmae = round(mae(mesicRF$prop, mesicRF$classification) , 2)
mesicRFrmse = round(rmse(mesicRF$prop, mesicRF$classification), 2)

mesicRFplot = ggplot(data = mesicRF, aes(prop, classification)) +
  geom_hex(bins = 10) + 
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c() +
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m mesic veg proportions", y="WRP mesic veg estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", mesicRFmae, "\nRMSE = ", mesicRFrmse))

mesicRFplot

## mesic SMA
mesicSMAcor = round(cor(mesicSMA$prop, mesicSMA$band_1, method = "pearson"), 2)
mesicSMAmae = round(mae(mesicSMA$prop, mesicSMA$band_1) , 2)
mesicSMArmse = round(rmse(mesicSMA$prop, mesicSMA$band_1), 2)

mesicSMAplot = ggplot(data = mesicSMA, aes(prop, band_1)) +
  geom_hex(bins = 10) + 
  guides(fill = guide_colourbar(label = FALSE, ticks = FALSE, title = "Density"))+
  scale_fill_viridis_c()+
  scale_y_continuous( limits = c(0,1)) +
  labs(x="10 m mesic veg proportions", y="SMA mesic veg estimate") +
  theme(axis.line = element_line(size = 0.5, colour = "black"))+
  geom_abline (slope=1, linetype = "dashed", color="Red", size = 2) +
  annotate("label", x = 0.1, y = 0.9, label = paste0("MAE = ", mesicSMAmae, "\nRMSE = ", mesicSMArmse))

mesicSMAplot

## arrange onto single page
## http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
ggarrange(waterRFplot, waterSMAplot, mesicRFplot, mesicSMAplot,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)
