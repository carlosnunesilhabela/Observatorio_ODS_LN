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
 
# Função escala Min-Max (Normalização)
f_minmax <- function(x){
  return((x - min(x))/(max(x)-min(x)))
}

# Seleção da RMVale (Trabalho disciplina SAS5712))

ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std.xlsx")  


RMVale <- read_xlsx("Tabelas/Municipios_RMVale.xlsx")
RMVale$COD_MUN <- as.character(RMVale$COD_MUN)
ABT21 <- sparklyr::left_join(RMVale, ABT20,  by = "COD_MUN")
writexl::write_xlsx(ABT21, "ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std.xlsx") #grava data frame em formato *.xlsx

#ABT limpa com apenas indicadores de interesse
ABT5712 <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std.xlsx")

# Pontuacao_ICM	
f_minmax20 <- function(x){
  return((x - min(x))/(20-min(x)))
}

ABT5712$Pontuacao_ICM_z		<- scale(ABT5712$Pontuacao_ICM)
ABT5712$Pontuacao_ICM_z	<- -ABT5712$Pontuacao_ICM_z	
ABT5712$Pontuacao_ICM_n		<- f_minmax(ABT5712$Pontuacao_ICM_z)
#ABT5712$Pontuacao_ICM_n		<- ABT5712$Pontuacao_ICM/20  #pontuação maxima

#ODS13_Score
ABT5712$ODS13_Score_z		<- scale(ABT5712$ODS13_Score)
ABT5712$ODS13_Score_z	  <- -ABT5712$ODS13_Score_z	
ABT5712$ODS13_Score_n		<- f_minmax(ABT5712$ODS13_Score_z)
#ABT5712$ODS13_Score_n		<- ABT5712$ODS13_Score/100

#IPS_Brasil	
ABT5712$IPS_Brasil_z		<- scale(ABT5712$IPS_Brasil)
ABT5712$IPS_Brasil_n		<- f_minmax(ABT5712$IPS_Brasil_z)

#receitas_correntes_2023_PC
ABT5712$receitas_correntes_2023_PC_z		<- scale(ABT5712$receitas_correntes_2023_PC)
ABT5712$receitas_correntes_2023_PC_n		<- f_minmax(ABT5712$receitas_correntes_2023_PC_z)
	
#Pib_per_capita
ABT5712$Pib_per_capita_z		<- scale(ABT5712$Pib_per_capita)
ABT5712$Pib_per_capita_n		<- f_minmax(ABT5712$Pib_per_capita_z)

ABT5712$ind_finan		<- (ABT5712$Pib_per_capita_n + ABT5712$receitas_correntes_2023_PC_n)/2

#Indicadores Negativos

#Emissoes_de_CO2_Habitante
ABT5712$Emissoes_de_CO2_Habitante_z		<- scale(ABT5712$Emissoes_de_CO2_Habitante)
#
#for (i in 1:39) {
#    if(ABT5712$Emissoes_de_CO2_Habitante_z[i]	> 2.5){
#       ABT5712$Emissoes_de_CO2_Habitante_z[i] <-2.5}
#}


ABT5712$Emissoes_de_CO2_Habitante_zn	<- -ABT5712$Emissoes_de_CO2_Habitante_z	
ABT5712$Emissoes_de_CO2_Habitante_n		<- f_minmax(ABT5712$Emissoes_de_CO2_Habitante_zn)

#Danos_Humanos_total	
ABT5712$Danos_Humanos_total_z		<- scale(ABT5712$Danos_Humanos_total)
ABT5712$Danos_Humanos_total_zn  <- ABT5712$Danos_Humanos_total_z	
ABT5712$Danos_Humanos_total_n		<- f_minmax(ABT5712$Danos_Humanos_total_zn)

#Danos_Materiais_total		
ABT5712$Danos_Materiais_total_z		<- scale(ABT5712$Danos_Materiais_total)
ABT5712$Danos_Materiais_total_zn	<- scale(ABT5712$Danos_Materiais_total_z)
ABT5712$Danos_Materiais_total_n		<- f_minmax(ABT5712$Danos_Materiais_total_zn)

#Num_total_mortes
ABT5712$Num_total_mortes_z		<- scale(ABT5712$Num_total_mortes)
ABT5712$Num_total_mortes_zn		<- scale(ABT5712$Num_total_mortes_z)
ABT5712$Num_total_mortes_n		<- f_minmax(ABT5712$Num_total_mortes_zn)

#Perdas_Total	
ABT5712$Perdas_Total_z		<- scale(ABT5712$Perdas_Total)
ABT5712$Perdas_Total_zn		<- scale(ABT5712$Perdas_Total_z)
ABT5712$Perdas_Total_n		<- f_minmax(ABT5712$Perdas_Total_zn)
	
#Num_ocorrencias	
ABT5712$Num_ocorrencias_z		<- scale(ABT5712$Num_ocorrencias)
ABT5712$Num_ocorrencias_zn	<- scale(ABT5712$Num_ocorrencias_z)
ABT5712$Num_ocorrencias_n		<- f_minmax(ABT5712$Num_ocorrencias_zn)

#IVCM	
ABT5712$IVCM_z		<- scale(ABT5712$IVCM)
ABT5712$IVCM_zn		<- scale(ABT5712$IVCM_z)
ABT5712$IVCM_n		<- f_minmax(ABT5712$IVCM_zn)	
	
ABT5712$ind_cap_mud_clim <- 
   (ABT5712$Pontuacao_ICM_n +
    ABT5712$ODS13_Score_n +
#    ABT5712$IPS_Brasil_n +
#   ABT5712$Emissoes_de_CO2_Habitante_n	+
    ABT5712$Danos_Humanos_total_n	+
    ABT5712$Danos_Materiais_total_n	+
    (ABT5712$Num_total_mortes_n * 2) +
    ABT5712$Perdas_Total_n +
    ABT5712$Num_ocorrencias_n) / 8
#    ABT5712$IVCM_n) / 11

ABT5712$IRMC <- 
  (ABT5712$Pontuacao_ICM_n +
     ABT5712$ODS13_Score_n +
     #    ABT5712$IPS_Brasil_n +
     #   ABT5712$Emissoes_de_CO2_Habitante_n	+
     ABT5712$Danos_Humanos_total_n	+
     ABT5712$Danos_Materiais_total_n	+
     (ABT5712$Num_total_mortes_n * 2) +
     ABT5712$Perdas_Total_n +
     ABT5712$Num_ocorrencias_n) / 8
#    ABT5712$IVCM_n) / 11

writexl::write_xlsx(ABT5712, "ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std(3).xlsx") #grava data frame em formato *.xlsx

ABT5712 <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale_SAS5712_std.xlsx")  
