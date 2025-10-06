
configs()       # executa função configurações 
{ 
  
  load_packages()
  
  install.packages("libproj-dev")
  install.packages("rgdal", repos="http://R-Forge.R-project.org") 
 
  library(geobr)
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
  library("magrittr")
  
  library("rgdal")
  
} # Carrega Pacotes

setores <- geobr::read_census_tract(35)

# Carrega dados por setor

arq_setores <- "C:/Users/carlo/Desktop/Observatório dos ODS/IBGE/Agregados_preliminares_por_setores_censitarios_RMVale.xlsx"
setores <- read_xlsx(arq_setores)
setores$CD_SETOR <- str_pad(setores$CD_SETOR,0)

shape <- "C:/Users/carlo/Desktop/Observatório dos ODS/IBGE/SP_Malha_Preliminar_2022/SP_Malha_Preliminar_2022.shp"

shp_mun2 <- sf::st_read(shape)

shp_mun21  <- dplyr::filter(shp_mun2, CD_MUN == "3520400") # CD_MESO == "3513")

shp_mun22 <- dplyr::left_join(
            x = shp_mun21, 
            y = setores, 
            by = "CD_SETOR")


writexl::write_xlsx(shp_mun22, "shp_mun22.xlsx") 
save(shp_mun22, file = "shp_mun22.RData") 

shp_mun22$geometry

shp_mun22$
  
  
  
  
  
  covid_sp <- covid_sp 

shp_mun22 <- shp_mun22 %>% 
  select(-c(NM_REGIAO.x))

  rename(CD_REGIAO$ = CD_REGIAO.x,
         AREA_KM2 = AREA_KM2.x)

#Grava
sf::st_write(shp_mun22, dsn = "RMVale_setores3", geom_name = "geometry",
    # overwrite = TRUE,
    driver="ESRI Shapefile") # ,layer="rmvale_setores2.shp") #, package="sf")

sf::st_join()

# Plotagem básica de um shapefile -----------------------------------------
plot(shp_mun22)


# Salvando nosso shapefile:
writeOGR(obj    = shp_mun22, 
         layer  = "setores.shp", 
         driver = "ESRI Shapefile", 
         dsn    = "RMVale_setores",
         overwrite_layer = TRUE)


