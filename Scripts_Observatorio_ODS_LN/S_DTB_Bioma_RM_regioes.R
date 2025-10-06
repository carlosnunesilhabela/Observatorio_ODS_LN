########################################

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
 
# Ler DTB

DTB <- read_xlsx("DTB_Divisao_Territorial_Brasileira_2022.xlsx")  

# Junta coluna SemiArido
SemiArido <- read_xlsx("lista_municipios_Semiarido_2022.xlsx") 
SemiArido$COD_MUN <- as.character(SemiArido$COD_MUN)
DTB <- sparklyr::left_join(DTB, SemiArido,  by = "COD_MUN")

# Junta coluna Amazônia Legal
AmazoniaLegal <- read_xlsx("Amazonia_Legal.xlsx") 
DTB <- sparklyr::left_join(DTB, AmazoniaLegal,  by = "COD_MUN")

# Junta coluna Municipios Costeiros
MunCosteiros <- read_xlsx("Municipios_Costeiros_2021.xlsx") 
MunCosteiros$COD_MUN <- as.character(MunCosteiros$COD_MUN)
DTB <- sparklyr::left_join(DTB, MunCosteiros,  by = "COD_MUN")

# Junta coluna Bioma
Bioma <- read_xlsx("Bioma_Predominante_por_Municipio_2024.xlsx") 
Bioma$COD_MUN <- as.character(Bioma$COD_MUN)
DTB <- sparklyr::left_join(DTB, Bioma,  by = "COD_MUN")

# Junta coluna segundo Bioma 
Bioma2 <- read_xlsx("Lista_Municipios_com mais que_1_Bioma.xlsx") 
Bioma2$COD_MUN <- as.character(Bioma2$COD_MUN)
DTB <- sparklyr::left_join(DTB, Bioma2,  by = "COD_MUN")

# Junta coluna Cod Sub Região RMVale
RMVale <- read_xlsx("Municipios_RMVale.xlsx") 
RMVale$COD_MUN <- as.character(RMVale$COD_MUN)
DTB <- sparklyr::left_join(DTB, RMVale,  by = "COD_MUN")

ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")
ABT <- sparklyr::left_join(ABT, DTB,  by = "COD_MUN")

writexl::write_xlsx(DTB, "DTB_Divisao_Territorial_Brasileira_2022.xlsx") #grava data frame em formato *.xlsx

writexl::write_xlsx(ABT, "ABT_MDR_caracterizacao_municipios.xlsx") #grava data frame em formato *.xlsx

ssp <- read_xlsx("Segurança_RMVale.xlsx") 
ssp2 = as.data.frame(sapply(ssp,as.numeric)) #transforma todas colunas em numericas


writexl::write_xlsx(ssp2, "Segurança_RMVale(2).xlsx")
