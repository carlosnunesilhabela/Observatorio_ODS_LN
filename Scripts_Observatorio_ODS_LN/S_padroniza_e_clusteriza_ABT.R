# Padroniza e Normaliza
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

# 5.1 Dimensão de Desenvolvimento Econômico
{  
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_economico.xlsx"
ABT_eco <- readxl::read_xlsx(url)

ABT_eco$ODS8_Score                     <-  scale(ABT_eco$ODS8_Score)
ABT_eco$ODS9_Score                     <-  scale(ABT_eco$ODS9_Score)
ABT_eco$ODS11_Score                    <-  scale(ABT_eco$ODS11_Score)
ABT_eco$Pib_per_capita                 <-  scale(ABT_eco$Pib_per_capita) 
ABT_eco$Total_empresas_inst_2022_PC    <-  scale(ABT_eco$Total_empresas_inst_2022_PC) 
ABT_eco$Pessoal_ocupado_2022_PC        <-  scale(ABT_eco$Pessoal_ocupado_2022_PC)
ABT_eco$Pessoal_Assalariado_2022_PC    <-  scale(ABT_eco$Pessoal_Assalariado_2022_PC)
ABT_eco$qtd_pes_pob_12_2023_PC         <- -scale(ABT_eco$qtd_pes_pob_12_2023_PC) 
ABT_eco$qtd_pes_baixa_renda_12_2023_PC <- -scale(ABT_eco$qtd_pes_baixa_renda_12_2023_PC)
ABT_eco$receitas_correntes_2023_PC     <-  scale(ABT_eco$receitas_correntes_2023_PC)
ABT_eco$Gini_2010                      <- -scale(ABT_eco$Gini_2010)

ABT_eco$ODS8_Score                     <- f_minmax(ABT_eco$ODS8_Score)
ABT_eco$ODS9_Score                     <- f_minmax(ABT_eco$ODS9_Score)
ABT_eco$ODS11_Score                    <- f_minmax(ABT_eco$ODS11_Score)
ABT_eco$Pib_per_capita                 <- f_minmax(ABT_eco$Pib_per_capita) 
ABT_eco$Total_empresas_inst_2022_PC    <- f_minmax(ABT_eco$Total_empresas_inst_2022_PC) 
ABT_eco$Pessoal_ocupado_2022_PC        <- f_minmax(ABT_eco$Pessoal_ocupado_2022_PC)
ABT_eco$Pessoal_Assalariado_2022_PC    <- f_minmax(ABT_eco$Pessoal_Assalariado_2022_PC)
ABT_eco$qtd_pes_pob_12_2023_PC         <- f_minmaxn(ABT_eco$qtd_pes_pob_12_2023_PC) 
ABT_eco$qtd_pes_baixa_renda_12_2023_PC <- f_minmaxn(ABT_eco$qtd_pes_baixa_renda_12_2023_PC)
ABT_eco$receitas_correntes_2023_PC     <- f_minmax(ABT_eco$receitas_correntes_2023_PC)
ABT_eco$Gini_2010                      <- f_minmaxn(ABT_eco$Gini_2010)

# #mean()

ABT_eco$i_eco <-                       (
ABT_eco$ODS8_Score                     +                     
ABT_eco$ODS9_Score                     +                     
ABT_eco$ODS11_Score                    +
ABT_eco$Pib_per_capita                 +
ABT_eco$Total_empresas_inst_2022_PC    +
ABT_eco$Pessoal_ocupado_2022_PC        +
ABT_eco$Pessoal_Assalariado_2022_PC    +
ABT_eco$qtd_pes_pob_12_2023_PC         +
ABT_eco$qtd_pes_baixa_renda_12_2023_PC + 
ABT_eco$receitas_correntes_2023_PC     +
ABT_eco$Gini_2010                      ) / 11                      

dev_pad <- sd(ABT_eco$i_eco)
dev_pad

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_economico_std.xlsx"

writexl::write_xlsx(ABT_eco, url)

}


#5.2 Dimensão de Vulnerabilidade Social
{

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_social.xlsx"
ABT_soc <- readxl::read_xlsx(url)

ABT_soc$ODS1_Score                                         <-  scale(ABT_soc$ODS1_Score)
ABT_soc$ODS2_Score                                         <-  scale(ABT_soc$ODS2_Score)
ABT_soc$ODS3_Score                                         <-  scale(ABT_soc$ODS3_Score)
ABT_soc$ODS4_Score                                         <-  scale(ABT_soc$ODS4_Score)
ABT_soc$ODS5_Score                                         <-  scale(ABT_soc$ODS5_Score)
ABT_soc$ODS10_Score                                        <-  scale(ABT_soc$ODS10_Score)
ABT_soc$IPS_Brasil                                         <-  scale(ABT_soc$IPS_Brasil)
ABT_soc$Pop_com_abastecimento_de_agua_2022_PC              <-  scale(ABT_soc$Pop_com_abastecimento_de_agua_2022_PC) 
ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC    <-  scale(ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC) 
#ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto <-  as.numeric(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)
ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto <-  scale(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)
#ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto    <-  as.numeric(ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto) 
ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto    <-  scale(ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto) 
ABT_soc$Desempenho_Seguranca_Indicador                     <-  scale(ABT_soc$Desempenho_Seguranca_Indicador)
ABT_soc$Quantidade_Leitos_1000h                            <-  scale(ABT_soc$Quantidade_Leitos_1000h)
ABT_soc$Quantidade_estabelec_saude_1000h                   <-  scale(ABT_soc$Quantidade_estabelec_saude_1000h)
ABT_soc$IVS2010                                            <-  scale(-ABT_soc$IVS2010)
ABT_soc$IDHM_2010                                          <-  scale(ABT_soc$IDHM_2010)

ABT_soc$ODS1_Score                                         <- f_minmax(ABT_soc$ODS1_Score)
ABT_soc$ODS2_Score                                         <- f_minmax(ABT_soc$ODS2_Score)
ABT_soc$ODS3_Score                                         <- f_minmax(ABT_soc$ODS3_Score)
ABT_soc$ODS4_Score                                         <- f_minmax(ABT_soc$ODS4_Score)
ABT_soc$ODS5_Score                                         <- f_minmax(ABT_soc$ODS5_Score)
ABT_soc$ODS10_Score                                        <- f_minmax(ABT_soc$ODS10_Score)
ABT_soc$IPS_Brasil                                         <- f_minmax(ABT_soc$IPS_Brasil)
ABT_soc$Pop_com_abastecimento_de_agua_2022_PC              <- f_minmax(ABT_soc$Pop_com_abastecimento_de_agua_2022_PC) 
ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC    <- f_minmax(ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC) 
ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto <- f_minmax(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)
ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto    <- f_minmax(ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto) 
ABT_soc$Desempenho_Seguranca_Indicador                     <- f_minmax(ABT_soc$Desempenho_Seguranca_Indicador)
ABT_soc$Quantidade_Leitos_1000h                            <- f_minmax(ABT_soc$Quantidade_Leitos_1000h)
ABT_soc$Quantidade_estabelec_saude_1000h                   <- f_minmax(ABT_soc$Quantidade_estabelec_saude_1000h)
ABT_soc$IVS2010                                            <- f_minmaxn(ABT_soc$IVS2010)
ABT_soc$IDHM_2010                                          <- f_minmax(ABT_soc$IDHM_2010)

#mean()

ABT_soc$i_soc <-                                             (
  ABT_soc$ODS1_Score                                         +
  ABT_soc$ODS2_Score                                         +
  ABT_soc$ODS3_Score                                         + 
  ABT_soc$ODS4_Score                                         +
  ABT_soc$ODS5_Score                                         +
  ABT_soc$ODS10_Score                                        + 
  ABT_soc$IPS_Brasil                                         +
  ABT_soc$Pop_com_abastecimento_de_agua_2022_PC              +
  ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC    + 
  ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto +
  ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto    + 
  ABT_soc$Desempenho_Seguranca_Indicador                     + 
  ABT_soc$Quantidade_Leitos_1000h                            + 
  ABT_soc$Quantidade_estabelec_saude_1000h                   + 
  ABT_soc$IVS2010                                            + 
  ABT_soc$IDHM_2010                                          ) / 16


dev_pad <- sd(ABT_soc$i_soc)
dev_pad

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_social_std.xlsx"

writexl::write_xlsx(ABT_soc, url)
}


# 5.3 Dimensão de Capacidade de Governança Municipal
{

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_Gov.xlsx"
ABT_Gov <- readxl::read_xlsx(url)

ABT_Gov$ODS17_Score                    <- scale(ABT_Gov$ODS17_Score)
ABT_Gov$receitas_correntes_2023_PC     <- scale(ABT_Gov$receitas_correntes_2023_PC)
ABT_Gov$Gestao_Transparencia_Indicador <- scale(ABT_Gov$Gestao_Transparencia_Indicador)
ABT_Gov$Gestao_Dimensao                <- scale(ABT_Gov$Gestao_Dimensao)
ABT_Gov$IGM_CFA                        <- scale(ABT_Gov$IGM_CFA)
ABT_Gov$ICM_D_Total	                   <- scale(ABT_Gov$ICM_D_Total)
ABT_Gov$tem_S2ID_habilitado            <- scale(ABT_Gov$tem_S2ID_habilitado)

ABT_Gov$ODS17_Score                    <- f_minmax(ABT_Gov$ODS17_Score)
ABT_Gov$receitas_correntes_2023_PC     <- f_minmax(ABT_Gov$receitas_correntes_2023_PC)
ABT_Gov$Gestao_Transparencia_Indicador <- f_minmax(ABT_Gov$Gestao_Transparencia_Indicador)
ABT_Gov$Gestao_Dimensao                <- f_minmax(ABT_Gov$Gestao_Dimensao)
ABT_Gov$IGM_CFA                        <- f_minmax(ABT_Gov$IGM_CFA)
ABT_Gov$ICM_D_Total	                   <- f_minmax(ABT_Gov$ICM_D_Total)
ABT_Gov$tem_S2ID_habilitado            <- f_minmax(ABT_Gov$tem_S2ID_habilitado)


#mean()

ABT_Gov$i_gov <-                                             (
ABT_Gov$ODS17_Score                    +
ABT_Gov$receitas_correntes_2023_PC     +
ABT_Gov$Gestao_Transparencia_Indicador +
ABT_Gov$Gestao_Dimensao                +
ABT_Gov$IGM_CFA                        +
ABT_Gov$ICM_D_Total	                   +
ABT_Gov$tem_S2ID_habilitado            ) / 7
  
dev_pad <- sd(ABT_Gov$i_gov)
dev_pad

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_Gov_std.xlsx"

writexl::write_xlsx(ABT_Gov, url)

}

# 5.4 Dimensão de Meio Ambiente e Mudanças Climáticas
{
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_Amb.xlsx"
ABT_Amb <- readxl::read_xlsx(url)

ABT_Amb$ODS6_Score                                         <- scale(ABT_Amb$ODS6_Score)
ABT_Amb$ODS7_Score                                         <- scale(ABT_Amb$ODS7_Score)	
ABT_Amb$ODS12_Score	                                       <- scale(ABT_Amb$ODS12_Score)	
ABT_Amb$ODS13_Score	                                       <- scale(ABT_Amb$ODS13_Score)	
ABT_Amb$ODS14_Score	                                       <- scale(ABT_Amb$ODS14_Score)	
ABT_Amb$ODS15_Score	                                       <- scale(ABT_Amb$ODS15_Score)	
ABT_Amb$Qualidade_do_Meio_Ambiente                         <- scale(ABT_Amb$Qualidade_do_Meio_Ambiente)	
ABT_Amb$indice_de_Vulnerabilidade_Climatica_dos_Municipios <- scale(ABT_Amb$indice_de_Vulnerabilidade_Climatica_dos_Municipios)	
ABT_Amb$Supressao_da_Vegetacao_Primaria_e_Secundaria       <- scale(ABT_Amb$Supressao_da_Vegetacao_Primaria_e_Secundaria)	
ABT_Amb$Focos_de_Calor                                     <- scale(ABT_Amb$Focos_de_Calor)
ABT_Amb$Emissoes_de_CO2e_por_Habitante                     <- scale(ABT_Amb$Emissoes_de_CO2e_por_Habitante)
ABT_Amb$areas_Verdes_Urbanas	                             <- scale(ABT_Amb$areas_Verdes_Urbanas)

ABT_Amb$ODS6_Score                                         <- f_minmax(ABT_Amb$ODS6_Score)
ABT_Amb$ODS7_Score                                         <- f_minmax(ABT_Amb$ODS7_Score)	
ABT_Amb$ODS12_Score	                                       <- f_minmax(ABT_Amb$ODS12_Score)	
ABT_Amb$ODS13_Score	                                       <- f_minmax(ABT_Amb$ODS13_Score)	
ABT_Amb$ODS14_Score	                                       <- f_minmax(ABT_Amb$ODS14_Score)	
ABT_Amb$ODS15_Score	                                       <- f_minmax(ABT_Amb$ODS15_Score)	
ABT_Amb$Qualidade_do_Meio_Ambiente                         <- f_minmax(ABT_Amb$Qualidade_do_Meio_Ambiente)	
ABT_Amb$indice_de_Vulnerabilidade_Climatica_dos_Municipios <- f_minmaxn(ABT_Amb$indice_de_Vulnerabilidade_Climatica_dos_Municipios)	
ABT_Amb$Supressao_da_Vegetacao_Primaria_e_Secundaria       <- f_minmaxn(ABT_Amb$Supressao_da_Vegetacao_Primaria_e_Secundaria)	
ABT_Amb$Focos_de_Calor                                     <- f_minmaxn(ABT_Amb$Focos_de_Calor)
ABT_Amb$Emissoes_de_CO2e_por_Habitante                     <- f_minmaxn(ABT_Amb$Emissoes_de_CO2e_por_Habitante)
ABT_Amb$areas_Verdes_Urbanas	                             <- f_minmax(ABT_Amb$areas_Verdes_Urbanas)

# Mean

ABT_Amb$i_amb <-                                             (
ABT_Amb$ODS6_Score                                         +
ABT_Amb$ODS7_Score                                         +	
ABT_Amb$ODS12_Score	                                       +
ABT_Amb$ODS13_Score	                                       +
ABT_Amb$ODS14_Score	                                       +	
ABT_Amb$ODS15_Score	                                       +	
ABT_Amb$Qualidade_do_Meio_Ambiente                         +	
ABT_Amb$indice_de_Vulnerabilidade_Climatica_dos_Municipios +
ABT_Amb$Supressao_da_Vegetacao_Primaria_e_Secundaria       +	
ABT_Amb$Focos_de_Calor                                     +
ABT_Amb$Emissoes_de_CO2e_por_Habitante                     +
ABT_Amb$areas_Verdes_Urbanas	                             ) / 12

dev_pad <- sd(ABT_Amb$i_amb)
dev_pad

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT_municipios_Amb_std.xlsx"

writexl::write_xlsx(ABT_Amb, url)
}
  
# Padroniza para separar em cluster
{
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/ABT__Indice_geral_std.xlsx"
ABT_indices <- readxl::read_xlsx(url)

ABT_indices$i_geral_std  <- scale(ABT_indices$i_geral)

ABT_indices$cluster <- ""

# Divide em clusters

for(i in 1:nrow(ABT_indices)) {
  if (ABT_indices$i_geral_std[i] > 1.5) {ABT_indices$cluster[i] <- "A"}
  else {
    if (ABT_indices$i_geral_std[i] > 0.5) {ABT_indices$cluster[i] <- "B"}
    else
      if (ABT_indices$i_geral_std[i] > -0.5) {ABT_indices$cluster[i] <- "C"}
      else
        if (ABT_indices$i_geral_std[i] > -1.5) {ABT_indices$cluster[i] <- "D"}
        else
        {ABT_indices$cluster[i] <- "E"}}}
          

writexl::write_xlsx(ABT_indices, url)
}