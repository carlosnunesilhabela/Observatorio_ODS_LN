########################################

configs()

# Carrega Pacotes
{ 
library(tidyverse)  #pacote para manipulacao de dados
library(cluster)    #algoritmo de cluster
library(dendextend) #compara dendogramas
library(factoextra) #algoritmo de cluster e visualizacao
library(fpc)        #algoritmo de cluster e visualizacao
library(gridExtra)  #para a funcao grid arrange
library(ggplot2)
library(stringr)
library(dplyr)
library(sparklyr)
library(writexl)
library(readxl)
library(stringr)
library("sf")
library("sp")
library("raster")
library("tmap")
library("broom")
library("knitr")
library("kableExtra")
library("RColorBrewer")
  
#install.packages("libproj-dev")
#install.packages("rgdal", repos="http://R-Forge.R-project.org")  
  
library("rgdal")
  
} # Carrega Pacotes

 
# Função escala Min-Max (Normalização)
f_minmax <- function(x){
  return((x - min(x))/(max(x)-min(x)))
}

# carrega ABT apenas dos municipios faixa 5 6 e 7

ABT  <- read_xlsx("ABT_MDR_caracterizacao_municipios_50000mais.xlsx")  
ABT$Cluster_s

SNIS <- read_xlsx("SNIS_todos_municipios_2022_apenas_residuos.xlsx")
SNIS$COD_MUN <- as.character(SNIS$COD_MUN) 


ABT_SNIS <- sparklyr::left_join(ABT, SNIS,  by = "COD_MUN")


# Carregando um shapefile ---------
shp_br_mun <- readOGR(dsn="BR_Municipios_2022") #, layer = "BR_Municipios_2022")

dplyr::glimpse(shp_br_mun)
class(shp_br_mun)
summary(shp_br_mun)

# Para acessar a base de dados e outros componentes de um shapefile, devemos utilizar o operador @:
shp_br_mun@data$CD_MU

# shp_mun@data <-  data.frame(shp_mun@data[,1:10]) manter apenas as primeiras 10 colunas
# shp_br_mun@data$CD_MUN <- as.character(shp_mun@data$CD_MU) # transfor cod Municipio em CHar (quando não está)


#shp_br_mun@data <- shp_br_mun@data  %>% 
  sparklyr::left_join(ABT, by = "CD_MUN")

  # Salvando nosso shapefile:
  writeOGR(obj = shp_br_mun, 
           layer = "Residuos_shp", 
           driver = "ESRI Shapefile", 
           dsn = "shp_br_residuos",
           overwrite_layer = TRUE)


writexl::write_xlsx(ABT_SNIS, "ABT_MDR_caracterizacao_municipios_50000mais(2).xlsx") #grava data frame em formato *.xlsx
