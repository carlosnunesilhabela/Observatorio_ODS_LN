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

#junta receitas
{
dir  <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Orçamento/" 
arqr <- "Receitas_siconfi_finbra_municipios_2023.xlsx"
arq  <- paste(dir,arqr, sep="")

receitas <- read_xlsx(arq)
receitas <- dplyr::filter(receitas, Tipo_Receita == "Receitas Brutas Realizadas" &
                                    Conta        == "TOTAL DAS RECEITAS (III) = (I + II)")
receitas <- receitas %>% select(Cod_IBGE, Municipio, Valor) %>%
                         rename(Valor_rec_2023 = Valor, COD_MUN = Cod_IBGE)

receitas$COD_MUN <- as.character(receitas$COD_MUN)
ABT23 <- sparklyr::full_join(ABT22, receitas, by = "COD_MUN")

writexl::write_xlsx(ABT23, "ABT_MDR_caracterizacao_municipios.xlsx") #grava data frame em formato *.xlsx
}

# Junta Despesas
{
arqd <- "Desp_funcao_siconfi_finbra_municipios_2023.xlsx"
arq  <- paste(dir,arqd, sep="")

despesas <- read_xlsx(arq)

# 04 - Administração	gov
desp_04adm_2023 <- dplyr::filter(despesas, Conta == "04 - Administração" & Coluna == "Despesas Liquidadas")
desp_04adm_2023 <- desp_04adm_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_04adm_2023 = Valor)

# 06 - Segurança Pública	SEG
desp_06seg_2023 <- dplyr::filter(despesas, Conta == "06 - Segurança Pública" & Coluna == "Despesas Liquidadas")
desp_06seg_2023 <- desp_06seg_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_06seg_2023 = Valor)

# 06.182 - Defesa Civil	SEG
desp_06182dc_2023 <- dplyr::filter(despesas, Conta == "06.182 - Defesa Civil" & Coluna == "Despesas Liquidadas")
desp_06182dc_2023 <- desp_06182dc_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_06182dc_2023 = Valor)

# 10 - Saúde	SAU
desp_10sau_2023 <- dplyr::filter(despesas, Conta == "10 - Saúde" & Coluna == "Despesas Liquidadas")
desp_10sau_2023 <- desp_10sau_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_10sau_2023 = Valor)

# 12 - Educação	EDU
desp_12edu_2023 <- dplyr::filter(despesas, Conta == "12 - Educação" & Coluna == "Despesas Liquidadas")
desp_12edu_2023 <- desp_12edu_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_12edu_2023 = Valor)

# 17 - Saneamento	AMB
desp_17sab_2023 <- dplyr::filter(despesas, Conta == "17 - Saneamento" & Coluna == "Despesas Liquidadas")
desp_17sab_2023 <- desp_17sab_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_17sab_2023 = Valor)

# 18 - Gestão Ambiental	AMB
desp_18amb_2023 <- dplyr::filter(despesas, Conta == "18 - Gestão Ambiental" & Coluna == "Despesas Liquidadas")
desp_18amb_2023 <- desp_18amb_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_18amb_2023 = Valor)

# 23 - Comércio e Serviços	ECO
desp_23csv_2023 <- dplyr::filter(despesas, Conta == "23 - Comércio e Serviços" & Coluna == "Despesas Liquidadas")
desp_23csv_2023 <- desp_23csv_2023 %>% select(Cod_IBGE, Municipio, Valor) %>% rename(desp_23csv_2023 = Valor)

abt_orc <- desp_04adm_2023
abt_orc <- sparklyr::full_join(abt_orc, desp_06seg_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_06182dc_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_10sau_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_12edu_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_17sab_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_18amb_2023, by = "Cod_IBGE")
abt_orc <- sparklyr::full_join(abt_orc, desp_23csv_2023, by = "Cod_IBGE")

    
ABT21 <- read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")  

arq_orc <-  "ABT_orc_desp.xlsx"
arq  <- paste(dir,arq_orc, sep="")
abt_orc <- read_xlsx(arq)

abt_orc <- abt_orc %>% 
  rename(COD_MUN = Cod_IBGE)

abt_orc$COD_MUN <- as.character(abt_orc$COD_MUN)

ABT22 <- sparklyr::full_join(ABT21, abt_orc, by = "COD_MUN")

writexl::write_xlsx(ABT22, "ABT_MDR_caracterizacao_municipios.xlsx") #grava data frame em formato *.xlsx


}

ABT_parcial <- ABT %>% select(c(UF,
                                COD_MUN,
                                Municipio,
                                Regiao,
                                IDSC_br_2023,
                                IPS_Brasil,
                                tem_S2ID_habilitado,
                                Receitas_correntes_2022_PC,
                                Pop_com_abastecimento_de_agua_2022_PC,
                                Populacao_atendida_com_esgotamento_sanitario_PC,
                                IVS2010,
                                Pib_per_capita,
                                IGM_CFA,
                                IDHM_2010                                ,
                                Gini_2010,
                                Danos_Humanos_total,
                                Danos_Materiais_total,
                                Total_perdas,
                                Num_ocorrencias,
                                Total_pagmun_2012_2023,
                                pagmun_2023 ))

writexl::write_xlsx(ABT, "ABT_MDR_caracterizacao_municipios.xlsx") #grava data frame em formato *.xlsx
