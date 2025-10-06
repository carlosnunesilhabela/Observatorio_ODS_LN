########################################

configs()

load_packages()

library(tidyverse)  #pacote para manipulacao de dados
library(cluster)    #algoritmo de cluster
library(dendextend) #compara dendogramas
library(factoextra) #algoritmo de cluster e visualizacao
library(fpc)        #algoritmo de cluster e visualizacao
library(gridExtra)  #para a funcao grid arrange
library(readxl)
library(ggplot2)
library(stringr)
library(dplyr)
library(sparklyr)
library(writexl)

BCP <- read.csv(file = "202312_BPC.csv", sep = ";", header = T, encoding = "latin1")

# Sumarizar  (contagem simples) por Mes e municipio

BCP_sum <- BCP %>% group_by(MÊS.COMPETÊNCIA, CÓDIGO.MUNICÍPIO.SIAFI) %>% 
  summarise(quantidade = n())

BCP_sum <- rename(BCP_sum, "CD_MUN_SIAFI" = "CÓDIGO.MUNICÍPIO.SIAFI")

writexl::write_xlsx(BCP_sum, "BCP202312_sum_mun.xlsx") #grava data frame em formato *.xlsx

ABT7 <- dplyr:::full_join.data.frame(ABT, BCP_sum, by = "CD_MUN_SIAFI") #Join de tabelas


library(readxl)
ABT <- readxl::read_xlsx("ABT_MDR_PNUD.xlsx")
writexl::write_xlsx(ABT, "ABT_MDR_PNUD.xlsx") #grava data frame em formato *.xlsx

save(ABT, file = "ABT_MDR_PNUD.RData") # grava data frame em formato RData
  

