
{ 
  
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
  library(readxl)
  library("sf")
  library("sp")
  library("raster")
  library("tmap")
  library("maptools") #nao carregado
  library("broom")
  library("knitr")
  library("kableExtra")
  library("RColorBrewer")

  install.packages("libproj-dev")
  install.packages("rgdal", repos="http://R-Forge.R-project.org")  
  
  library("rgdal")
  
} # Carrega Pacotes

configs()

# Carrega ABT_MDR_caracterizacao_municipios.xlsx
ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std.xlsx")
ABT$rnk_ind_cap_mud_clin

# Carregando um shapefile ---------
shp_mun <- readOGR(dsn="RMVale")  #, layer = "RMVale_shp")

list.files(shp_mun)

dplyr::glimpse(shp_mun)
class(shp_mun)
summary(shp_mun)

# Para acessar a base de dados e outros componentes de um shapefile, devemos utilizar o operador @:
shp_mun@data$CD_MU

shp_mun@data <-  data.frame(shp_mun@data[,1:10]) 

shp_mun@data$CD_MU <- as.character(shp_mun@data$CD_MU)


shp_mun@data  <- shp_mun@data  %>% 
  sparklyr::left_join(ABT, by = "CD_MU")


shp_mun@polygons  #Posições geográficas dos polígonos
shp_mun@plotOrder #Ordem de plotagem dos polígonos
shp_mun@bbox      #Eixo X (Longitude Oeste e Leste; Latitude Norte e Sul)
shp_mun@proj4string@projargs #Sistema de projeção geográfica do shapefile

# Plotagem básica de um shapefile -----------------------------------------
plot(shp_mun)

# Para combinar os dados do objeto dados_sp com a base de dados de nosso 
# shapefile, podemos utilizar a função merge():
shp_mun_ABT <- merge(x = shp_mun,
                     y = ABT,
                     by.x = "CD_MUN",
                     by.y = "CD_MUN")

# Salvando nosso shapefile:
writeOGR(obj = shp_mun, 
         layer = "RMVale_shp", 
         driver = "ESRI Shapefile", 
         dsn = "RMVale",
         overwrite_layer = TRUE)


