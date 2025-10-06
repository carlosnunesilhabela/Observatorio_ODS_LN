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

# DTB x Municipios de Interesse Turistico SP
{
  DTB <- read_xlsx("Tabelas/DTB_Divisao_Territorial_Brasileira_2022.xlsx")
  MunTur <- read_xlsx("Tabelas/Municípios de Interesses Turisticos - SP.xlsx")
  DTB <- rename(DTB, CD_MUN = `Código Município Completo` )
  DTB <- as_tibble(DTB) # transformando em tibble (não é necessário)
  MunTur <- as_tibble(MunTur) # transformando em tibble (não é necessário)
  MunTur2 <- dplyr::rigth_join(MunTur, DTB, by = "municipio")
  writexl::write_xlsx(MunTur2, "Municípios de Interesses Turisticos - SP.xlsx") #grava data frame em formato *.xlsx
}
          
# DTB x Municipios de Interesse Turistico SP
{
  DTB <- read_xlsx("Tabelas/DTB_Divisao_Territorial_Brasileira_2022.xlsx")
  MunTur <- read_xlsx("Tabelas/Municípios de Interesses Turisticos - SP.xlsx")
  DTB <- rename(DTB, CD_MUN = `Código Município Completo` )
  DTB <- as_tibble(DTB) # transformando em tibble (não é necessário)
  MunTur <- as_tibble(MunTur) # transformando em tibble (não é necessário)
  MunTur2 <- dplyr::rigth_join(MunTur, DTB, by = "municipio")
  writexl::write_xlsx(MunTur2, "Municípios de Interesses Turisticos - SP.xlsx") #grava data frame em formato *.xlsx
}

#Junta ICM com base de indicadores do IDSC-br
{
IDSC <- read_xlsx("IDSCbr_Base_de_Dados_MDR_PNUD.xlsx")
ICM <- read_xlsx("ICM_ListaABCD_junho2024.xlsx") 

# Full Join: cria um novo dataset contendo todas as informações de X e Y
# Ou seja, pode estar em X e não estar em Y e vice-versa

ABT <- sparklyr::full_join(ICM, IDSC, by = "cod_mun_ibge")
}

#Junta IPS - TemS2ID e MCR
{
IPS <- read_xlsx("IPS_Brasil_RMVALE.xlsx") 
ABT2 <- sparklyr::full_join(ABT, IPS, by = "cod_mun_ibge")

TEMS2ID <- read_xlsx("lista_S2iD.xlsx") 
ABT2<- read_xlsx("ABT_MDR_PNUD.xlsx")

ABT3 <- sparklyr::full_join(ABT2, TEMS2ID, by = "cod_mun_ibge")


MCR <- read.csv(file = "lista_mcr2030_junho.csv", sep = ";", header = T, encoding = "latin1")
ABT3<- read_xlsx("ABT_MDR_PNUD.xlsx")

ABT4 <- sparklyr::full_join(ABT3, MCR, by = "cod_mun_ibge")
}

# Coloca o codigo SIAFI
{
SIAFI <- read_xlsx("receita_siaf_2022.xlsx")
ABT4 <- read_xlsx("ABT_MDR_PNUD.xlsx")

ABT5 <- sparklyr::full_join(ABT4, SIAFI, by = "cod_mun_ibge")

MunTur$municipio <- tolower(MunTur$Município)       # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
MunTur$municipio <- rm_accent(MunTur$municipio)     # Remove todas acentuações 
MunTur$municipio <- str_replace_all(MunTur$municipio, "[^[:alnum:]]", "") # remove non alphanumeric characters

ABT5 <- read_xlsx("ABT_MDR_PNUD.xlsx")
SIAFI <- read_xlsx("Tabelas/Codigo_IBGE_SIAFI_Municipios.xlsx")

ABT5$CD_MUN <- as.character(ABT5$CD_MUN)

ABT <- read_xlsx("ABT_MDR_PNUD.xlsx")

ABT7 <- sparklyr::full_join(ABT5, SIAFI, by = "CD_MUN")
}

#SNIS - join dados de saneamento
{
ABT <- read_xlsx("ABT_MDR_PNUD.xlsx")
SNIS_2022 <- read_xlsx("SNIS_todosmunicipios_so_esgoto.xlsx")

SNIS_2022$CD_MUN <- as.character(SNIS_2022$CD_MUN)

ABT8 <- sparklyr::full_join(ABT, SNIS_2022, by = "CD_MUN")
}

# join IVS (IPEA) 2010
{
ABT <- read_xlsx("ABT_MDR_PNUD.xlsx")
IVS_2010 <- read_xlsx("IVS_dados2010.xlsx")

IVS_2010$CD_MUN <- as.character(IVS_2010$CD_MUN)

ABT9 <- sparklyr::full_join(ABT, IVS_2010, by = "CD_MUN")
}

# join Municipios prioritarios
{
  ABT <- read_xlsx("ABT_MDR_PNUD.xlsx")
  Mun_prio <- read_xlsx("lista_municipios_prioritarios_1972.xlsx")
  
  Mun_prio$CD_MUN <- as.character(Mun_prio$CD_MUN)
  
  ABT10 <- sparklyr::full_join(ABT, Mun_prio, by = "CD_MUN")
  
  writexl::write_xlsx(ABT, "ABT_MDR_PNUD10.xlsx") #grava data frame em formato *.xlsx
}

# Leitos e Numero de estabelecimentos saude
{
leitos <- read_xlsx("Qtde_leitos.xlsx")
  leitos$COD_MUN <- as.character(leitos$COD_MUN)
estabsaude <- read_xlsx("Cad_Nacional_Estabelecimentos_Saude.xlsx")
  estabsaude$COD_MUN <- as.character(estabsaude$COD_MUN)
  
ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")

ABT14 <- sparklyr::full_join(ABT, leitos, by = "COD_MUN")
ABT14 <- sparklyr::full_join(ABT14, estabsaude, by = "COD_MUN")
}

# Join ABT com dados sumarizados do Atlas de Desastres
{
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_MDR_caracterizacao_municipios.xlsx"

ABT <- read_xlsx(url)

#padrononiza nome da coluna para join
danos_sum_joined <- rename(danos_sum_joined, COD_MUN = Cod_IBGE_Mun)
danos_sum_joined$COD_MUN <- as.numeric(danos_sum_joined$COD_MUN)

ABT15 <- sparklyr::full_join(ABT, danos_sum_joined, by = "COD_MUN")
}

#Insere código SIAFI 
{
ABT5 <- read_xlsx("ABT_MDR_PNUD.xlsx")
SIAFI <- read_xlsx("Tabelas/Codigo_IBGE_SIAFI_Municipios.xlsx")

ABT5$CD_MUN <- as.character(ABT5$CD_MUN)

ABT <- read_xlsx("ABT_MDR_PNUD.xlsx")
}

# Join IDHM e GINI
{
ABT16 <- read_xlsx("Info_Mun.xlsx", sheet = "ABT")    
IDHM <- read_xlsx("IDHM_Municipios_2010.xlsx", sheet = "IDHM")
GINI  <- read_xlsx("ginibr.xlsx", sheet = "ginibr")   

IDHM$municipio_std <- tolower(IDHM$Municipio)       # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
IDHM$municipio_std <- rm_accent(IDHM$municipio_std)     # Remove todas acentuações 
IDHM$municipio_std <- str_replace_all(IDHM$municipio_std, "[^[:alnum:]]", "") # remove non alphanumeric characters

ABT17 <- sparklyr::full_join(ABT16, IDHM, by = "municipio_std") 

ABT17 <- sparklyr::full_join(ABT17, GINI, by = "COD_MUN6")

ABT17 <- read_xlsx("ABT_17.xlsx") 
ABT   <- read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")

ABT18 <- sparklyr::full_join(ABT, ABT17, by = "COD_MUN")
}

# Join pagamentos efetuados aos municípios
{
ABT19 <- read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")  
ABT19$COD_MUN <- as.character(ABT19$COD_MUN)
  
pg2012_2023 <- read_xlsx("Pagamentos totalizados por Municipio2012_2023.xlsx")
pg2023 <- read_xlsx("Pagamentos totalizados por Municipio_2023.xlsx")

ABT20 <- sparklyr::full_join(ABT19, pg2012_2023, by = "COD_MUN") 

ABT20 <- sparklyr::full_join(ABT20, pg2023, by = "COD_MUN")
}

# Join royalties (fonte siconfi)
{
ABT20 <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale.xlsx")  
royalties <- read_xlsx("royalties_2023.xlsx")
royalties$COD_MUN <- as.character(royalties$COD_MUN)
ABT20r <- sparklyr::left_join(ABT20, royalties, by = "COD_MUN")
writexl::write_xlsx(ABT20r, "ABT_MDR_caracterizacao_municipios_RMVale(2).xlsx") #grava data frame em formato *.xlsx
}

# save(ABT, file = "ABT_MDR_PNUD.RData") # grava data frame em formato RData
# load("ABT_MDR_PNUD.RData")
# remove(ABT15)

# Seleção da RMVale (Trabalho disciplina SAS5712))
{
ABT20 <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale.xlsx")  
RMVale <- read_xlsx("Tabelas/Municipios_RMVale.xlsx")
RMVale$COD_MUN <- as.character(RMVale$COD_MUN)
ABT21 <- sparklyr::left_join(RMVale, ABT20,  by = "COD_MUN")
writexl::write_xlsx(ABT21, "ABT_MDR_caracterizacao_municipios_RMVale.xlsx") #grava data frame em formato *.xlsx
}

# Acrescenta informações de profissionais da saude
{
ABTRMVale <- read_xlsx("ABT_MDR_caracterizacao_municipios_RMVale.xlsx") 
ABTRMVale$`FN033 - Investimentos totais realizados pelo prestador de serviços`

med <- read_xlsx("saude_med_mun_ano.xlsx")
med$COD_MUN <- as.character(med$COD_MUN)
ABT22 <- sparklyr::left_join(ABTRMVale, med,  by = "COD_MUN")
enf <- read_xlsx("saude_enf_mun_ano.xlsx")
enf$COD_MUN <- as.character(enf$COD_MUN)
ABT23 <- sparklyr::left_join(ABT22, enf,  by = "COD_MUN")
}

# Acrescenta informações finaneiras SNIS
{
snis <- read_xlsx("SNIS_Financas_RMVale.xlsx")
ABT24 <- sparklyr::left_join(ABTRMVale, snis,  by = "COD_MUN")
writexl::write_xlsx(ABT24, "ABT_MDR_caracterizacao_municipios_RMVale(2).xlsx") #grava data frame em formato *.xlsx
}

# Acrescenta IPDM Seade
{
ipdm <- read_xlsx("IPDM2022.xlsx")
ipdm$COD_MUN <- as.character(ipdm$COD_MUN)
ABT25 <- sparklyr::left_join(ABTRMVale, ipdm,  by = "COD_MUN")
writexl::write_xlsx(ABT25, "ABT_MDR_caracterizacao_municipios_RMVale(2).xlsx") #grava data frame em formato *.xlsx


teste <- sparklyr::select(ipdm, 
                          IPDM_2022,
                          COD_MUN)

}

# Acrescenta IVCad 
{
ABT25 <- read_xlsx("ABT_MDR_caracterizacao_municipios_VR.xlsx")
ivcad <- read_xlsx("IVCad.xlsx")
ABT26 <- sparklyr::left_join(ABT25, ivcad,  by = "COD_MUN")
writexl::write_xlsx(ABT26, "ABT_MDR_caracterizacao_municipios_VR(2).xlsx")
}

# Acrescenta informaçaos do Cad Unico
{
ABT26 <- read_xlsx("ABT_MDR_caracterizacao_municipios_VR(2).xlsx")
cadunico <- read_xlsx("CadUnico.xlsx")
cadunico$amd <- ymd(cadunico$Referência)
cadunico2 <- dplyr::filter(cadunico, amd == "2023-12-01") 
cadunico2 <- cadunico2 %>% 
  rename(COD_MUN = Código)
cadunico2$COD_MUN <- as.character(cadunico2$COD_MUN)
ABT27 <- sparklyr::left_join(ABT26, cadunico2,  by = "COD_MUN")
writexl::write_xlsx(ABT27, "ABT_MDR_caracterizacao_municipios_VR(2).xlsx")
}

# Junta IPRS do Sead]
{
iprs<- read_xlsx("Seade_IPRS_municipios.xlsx")
ABT27 <- sparklyr::left_join(ABT20r, iprs,  by = "COD_MUN")
writexl::write_xlsx(ABT27, "ABT_MDR_caracterizacao_municipios_RMVale(3).xlsx")
}

# JUNTA ISLU Indide de Sustentabilidade da Limpeza Urbana
{
islu <- read_xlsx("ISLU.xlsx")

islu$Municipio_std <- tolower(islu$Municipio)    # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
islu$Municipio_std  <- rm_accent(islu$Municipio_std)      # Remove todas acentuações                           
islu$Municipio_std<- str_replace_all(islu$Municipio_std, "[^[:alnum:]]", "")  # remove non alphanumeric characters                 

colnames(islu)[5] <- "municipio_std"
islu <- read_xlsx("ISLU.xlsx")
ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios_50000mais.xlsx")
ABT28 <- sparklyr::full_join(ABT, islu,  by = "municipio_std")
writexl::write_xlsx(ABT28, "ABT_MDR_caracterizacao_municipios_50000mais(2).xlsx")
}

# Junta Despesas totais
{
url <- "C:/Users/carlo/Desktop/despesas_2023.xlsx"

despesas <- read_xlsx(url) 
despesas$Cod_IBGE <- as.character(despesas$Cod_IBGE)

despmun <- despesas %>% group_by(Cod_IBGE) %>%
summarise(desp_total          = sum (Valor)) 

despmun <- rename(despmun, COD_MUN = Cod_IBGE)

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_MDR_caracterizacao_municipios_VR.xlsx"

ABT <- read_xlsx(url) 

ABT28 <- sparklyr::left_join(ABT, despmun,  by = "COD_MUN")

}


# JUNTA o IRQ
{
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/Atlas_Danos_sumarizados_IRQ_todascolunas.xlsx"

IRQ <- read_xlsx(url) 
IRQ  <- rename(IRQ, COD_MUN = Cod_IBGE_Mun)

ABT29 <- sparklyr::left_join(ABT28, IRQ,  by = "COD_MUN")

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/B1_ABT_caracterizacao_municipios.xlsx"

writexl::write_xlsx(ABT29, url)
}

# Junta valores 2024 (atualizado em fev2024) 
{
url <- "C:/Users/carlo/Desktop/ABT_MDR_caracterizacao_municipios_target_ed30012025.xlsx"
ABT <- read_xlsx(url) 

url3 <- "C:/Users/carlo/Desktop/Pagamentos_Municípios_2012_2024_sum_por_codibge.xlsx"
tab_sum <- read_xlsx(url3) 


ABT30 <- sparklyr::left_join(ABT, tab_sum,   by = "COD_MUN")

url4 <- "C:/Users/carlo/Desktop/B1_ABT_MDR_caracterizacao_municipios_target_ed20250201.xlsx"
writexl::write_xlsx(ABT30, url4)
}