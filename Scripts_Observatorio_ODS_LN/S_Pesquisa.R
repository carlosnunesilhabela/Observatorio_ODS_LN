configs()

# Carrega Pacotes
{ load_packages()
  
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
  library(readxl)
}

pesq <- read_xlsx("C:/Users/carlo/Desktop/PT_Data_481961 600_.xlsx", sheet = 1) #, skip = 1, col_names = columns); 

utils::write.csv(pesq, file = "C:/Users/carlo/Desktop/PT_Data_481961 600_.csv",  sep = ";", dec = ",")

remove(pesq)
