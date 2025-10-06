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

setwd("C:/Users/carlo/Desktop/")
getwd()

url <- "C:/Users/carlo/Desktop/Despesas-LN-2008-2024_caragua_ilhabela.xlsx"
arq1 <- read_xlsx(url)

url <- "C:/Users/carlo/Desktop/Despesas-LN-2008-2024_ssebastiao_ubatuba.xlsx"
arq2 <- read_xlsx(url)

arqjuntos <- bind_rows(arq1, arq2) 

#  Filtro de linhas
arqjuntos <- dplyr::filter(arqjuntos, `ano exercicio` == 2011 |
                                      `ano exercicio` == 2012 |
                                      `ano exercicio` == 2013 |
                                      `ano exercicio` == 2014 |
                                      `ano exercicio` == 2015 |
                                      `ano exercicio` == 2016 |
                                      `ano exercicio` == 2017 |
                                      `ano exercicio` == 2018 |
                                      `ano exercicio` == 2019 |
                                      `ano exercicio` == 2020 |
                                      `ano exercicio` == 2021 |
                                      `ano exercicio` == 2022 |
                                      `ano exercicio` == 2023 |
                                      `ano exercicio` == 2024 )


arqjuntos <- dplyr::filter(arqjuntos, municipio == "Caraguatatuba" |
                                      municipio == "Ilhabela"      |
                                      municipio == "São Sebastião" |
                                      municipio == "Ubatuba"       )

load("Despesas-LN-2011-2024.RData")

arqjuntos <- dplyr::filter(arqjuntos, `tipo despesa` == "Valor Liquidado" )

save(despesas_ln_2011_2024, file = url) # xlsx format does not support tables with 1M+ rows

# url <- "C:/Users/carlo/Desktop/Despesas-LN-2011-2024.xlsx"
# writexl::write_xlsx(arqjuntos, url)
