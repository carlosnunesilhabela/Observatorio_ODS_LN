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
library(magrittr)
}
 
# Ler Tabela de códigos

url <- "C:/Users/carlo/Desktop/Municipios_cod_ibge.xlsx"
tab_ibge <- read_xlsx(url)
tab_ibge$Municipio
tab_ibge$UF
tab_ibge$municipiouf <- std_str(tab_ibge$municipiouf)

writexl::write_xlsx(tab_ibge, url)

url1 <- "C:/Users/carlo/Desktop/B2_Pagamentos_Municípios_2012_2024_(V31012025).xlsx"
tab_pagtos <- read_xlsx(url1)
tab_pagtos$municipiouf <- std_str(tab_pagtos$municipiouf) # padroniza (minusculo sem caracter especial)


tab_pagtos <- sparklyr::left_join(tab_pagtos, tab_ibge,  by = "municipiouf")


############## sumarização dos valores pagos por municipio ##############
{
tab_pagtos$Cod_Mun_IBGE <- stringr::str_pad(tab_pagtos$Cod_Mun_IBGE,0) # transforma cod ibge em char

tab_sum <- tab_pagtos %>% dplyr::group_by(Cod_Mun_IBGE) %>%
           dplyr::summarise(Valor_pago_2012_2024  = sum(Valor_Pago))

url2 <- "C:/Users/carlo/Desktop/Pagamentos_Municípios_2012_2024_sum_por_codibge.xlsx"
writexl::write_xlsx(tab_sum, url2)
}

