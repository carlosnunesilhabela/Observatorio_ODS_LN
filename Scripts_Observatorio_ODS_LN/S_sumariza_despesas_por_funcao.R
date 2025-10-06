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
  #library( readr#
  
}

url <- "C:/Users/carlo/Desktop/Observatório dos ODS/Orçamentos_LN _2008_2023/Litoral Norte/Despesas-LN-2011-2024.RData"
load(url)

# arqjuntos <- bind_rows(arq1, arq2) 


tot_por_funcao <- despesas_ln_2011_2024 %>% 
                  group_by( `ano exercicio`, municipio,`funcao de governo`) %>% 
                  summarise(Tot_func = sum(Valor), .groups = "drop")

url1 <- "C:/Users/carlo/Desktop/Observatório dos ODS/Orçamentos_LN _2008_2023/Litoral Norte/Despesas-LN-2011-2024_funcao.xlsx"
writexl::write_xlsx(tot_por_funcao, url1)
