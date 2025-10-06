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

ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios_VR.xlsx")

# ABT$COD_MUN <- as.character(ABT$COD_MUN)

ABT_target <- ABT %>% select(c(COD_MUN,
                                Municipio,
                                UF,
                                Regiao,
                                Nome_Mesorregiao,
                                Nome_Microrregiao,
                                Semi_Arido,
                                Amazonia_Legal,
                                Municipio_Costeiro,
                                Bioma1_predominante,
                                capital_s_n,
                                Populacao_censo2022,
                                Faixa_Populacional,
                               `area_do_municipio_km²`,
                                ICM_D_Total,
                                Lista_A_D_ICM,
                                Mun_Prioritario,
                                IDSC_br_2023,
                                ODS1_Score,
                                ODS2_Score,
                                ODS3_Score,
                                ODS4_Score,
                                ODS5_Score,
                                ODS6_Score,
                                ODS7_Score,
                                ODS8_Score,
                                ODS9_Score,
                                ODS10_Score,
                                ODS11_Score,
                                ODS12_Score,
                                ODS13_Score,
                                ODS14_Score,
                                ODS15_Score,
                                ODS16_Score,
                                ODS17_Score,
                                IPS_Brasil,
                                tem_S2ID_habilitado,
                                Qualidade_do_Meio_Ambiente,
                                Supressao_da_Vegetacao_Primaria_e_Secundaria,
                                Focos_de_Calor,
                                Emissoes_de_CO2e_por_Habitante,
                                areas_Verdes_Urbanas,
                                IVCM,
                                receitas_correntes_2023,
                                receitas_correntes_2023_PC,
                                Financas_Inv_per_Capita_Educacao_Dado_Bruto,
                                Financas_Inv_per_Capita_Saude_Dado_Bruto,
                                Pib_per_capita,
                                Pib_a_precos_correntes_1000,
                                Pop_com_abastecimento_de_agua_2022_PC,
                                Populacao_atendida_com_esgotamento_sanitario_PC,
                                IVS2010,
                                IVCAD,
                                IGM_CFA,
                                IVCM,
                                Gestao_Transparencia_Indicador,
                                Gestao_Dimensao,
                                IGM_CFA,
                                Total_empresas_inst_2022_PC,
                                Pessoal_ocupado_2022_PC,
                                Pessoal_Assalariado_2022_PC,
                                qtd_pes_pob_12_2023_PC,
                                qtd_pes_baixa_renda_12_2023_PC,
                                Quantidade_Leitos_1000h,
                                Quantidade_estabelec_saude_1000h,
                                IDHM_2010,
                                Gini_2010,
                                IPS_Brasil,
                                Cluster_cat_mun,
                                Danos_Humanos_total,
                                Danos_Materiais_total,
                                Num_total_mortes,
                                Total_perdas,
                                Num_ocorrencias,
                                Cod_Cobrade_mais,	
                                ncod_cobrad,
                                Total_pagmun_2012_2023,
                                pagmun_2023))



writexl::write_xlsx(ABT_target, "ABT_MDR_caracterizacao_municipios_target.xlsx")  #grava data frame em formato *.xlsx

# Seleciona indicadores da dimensao Desenvolvimento Economico
{
ABT <- read_xlsx("ABT_MDR_caracterizacao_municipios_VR.xlsx")

ABT_eco <-  ABT %>% select(c(COD_MUN,
            Municipio,
            Populacao_censo2022,
            ODS8_Score,
            ODS9_Score,
            ODS11_Score,
            Pib_per_capita,
            Total_empresas_inst_2022_PC,
            Pessoal_ocupado_2022_PC,
            Pessoal_Assalariado_2022_PC,
            qtd_pes_pob_12_2023_PC,
            qtd_pes_baixa_renda_12_2023_PC,
            receitas_correntes_2023_PC,
            Gini_2010))

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_economico.xlsx"
writexl::write_xlsx(ABT_eco, url)  #grava data frame em formato *.xlsx
}