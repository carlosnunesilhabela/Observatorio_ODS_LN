########################################

configs()

# Carrega Pacotes
{ load_packages()

install.packages("sqldf")

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
library(data.table)
library(sqldf)
}

setwd("C:/Users/carlo/Desktop/")
getwd()

# Executa a query SQL no dataframe 'df'
df_sample <- data.frame(var1 = 1:10, var2=55:64)

resultado <-
sqldf("
SELECT var1, var2 FROM df_sample WHERE var1 > 8
      ")



# Para acesso do SQLite
drv <- dbDriver("SQLite") 
con <- dbConnect(drv, "basequalquer.db") 
dbWriteTable(con, "TabelaA", A) 