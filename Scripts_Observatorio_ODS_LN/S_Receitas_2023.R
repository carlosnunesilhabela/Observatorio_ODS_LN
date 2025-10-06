# Receitas 2023

# Carrega Pacotes
{ 
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
  library(readxl)
  library(magrittr)
}

url <- "C:/Users/carlo/Desktop/TransferenciaMensalMunicipios2023.xlsx"

transf_mun <- read_xlsx(url)

transf_mun$valor <- transf_mun$`1º Decêndio` + transf_mun$`2º Decêndio`+ transf_mun$`3º Decêndio`
# Sumarização por municipio

transf_mun_sum <- transf_mun %>% group_by(Município) %>% # , Transferência
    summarise(Valor_transf_ano = sum(valor))
              
    
tot <- transf_mun %>% group_by() %>% # , Transferência
  summarise(Valor_transf_ano = sum(valor))

     
    danos_sum_joined <- sparklyr::left_join(danos_sum, cod2, by = "Cod_IBGE_Mun")
  
    writexl::write_xlsx(danos_sum_joined, "Atlas_Danos_sumarizados_2012_2023.xlsx") #grava data frame em formato *.xlsx
  