# Atlas_Danos - Sumarização

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
  library(purrr)
  library(tidyr)
  }

# Fórmula de calculo 
# IRQ =(((mortes*6)/100000)+((danos_humanos*3)/100000)+((prejuizoz_totais*1)/100000))/10  

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/BD_Atlas_1991_2023_v1.0_2024.04.29.xlsx"
sheet_a_ler <- "Atlas Correção Monetária"

mapa_danos <- read_xlsx(url,  sheet = sheet_a_ler)

mapa_danos$Cod_IBGE_Mun <- as.character(mapa_danos$Cod_IBGE_Mun)

mapa_danos_2012_2023 <- dplyr::filter(mapa_danos, year(Data_Registro) >= "2012")

# Filtro por grupo de tipologia de desastres
{
mapa_danos_ou <- dplyr::filter(mapa_danos, grupo_tipologia == "Outros")
mapa_danos_mm <- dplyr::filter(mapa_danos, grupo_tipologia == "Movimento de Massa")
mapa_danos_er <- dplyr::filter(mapa_danos, grupo_tipologia == "Erosão")
mapa_danos_cv <- dplyr::filter(mapa_danos, grupo_tipologia == "Chuvas e Vendavais")
mapa_danos_se <- dplyr::filter(mapa_danos, grupo_tipologia == "Seca")
}

# Sumarização por grupo de tipologia


# Sumarização por municipio - sem filtro (total)  
  {  
danos_sum <- mapa_danos %>% group_by(Cod_IBGE_Mun)%>%
  summarise(Num_mortes_total           = sum (DH_MORTOS),
            Danos_Humanos_total        = sum(DH_total_danos_humanos),
            Danos_Materiais_total      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total = sum (PEPL_total_publico),
            Perdas_setor_privado_total = sum (PEPR_total_privado),
            Perdas_total               = sum(PE_PLePR),
            Num_ocorrencias_total      = n(),
            num_anos_rep_total         = n_distinct(year(Data_Registro)))
  
danos_sum$IRQ =(((danos_sum$Num_mortes_total                               *6)/100000) +
                ((danos_sum$Danos_Humanos_total                            *3)/100000) +
               (((danos_sum$Danos_Materiais_total + danos_sum$Perdas_total)*1)/100000))/10 
  }
  
#Apenas 2012-2023  
{  
danos_sum_2012_2023 <- mapa_danos_2012_2023 %>% group_by(Cod_IBGE_Mun)%>%
    summarise(Num_mortes_total_12_23           = sum(DH_MORTOS),
              Danos_Humanos_total_12_23        = sum(DH_total_danos_humanos),
              Danos_Materiais_total_12_23      = sum(DM_total_danos_materiais),
              Perdas_setor_publico_total_12_23 = sum (PEPL_total_publico),
              Perdas_setor_privado_total_12_23 = sum (PEPR_total_privado),
              Perdas_total_12_23               = sum(PE_PLePR),
              Num_ocorrencias_total_12_23      = n(),
              num_anos_rep_total_12_23         = n_distinct(year(Data_Registro)))
}

# Outros (ou)
  {  
danos_sum_ou <- mapa_danos_ou %>% group_by(Cod_IBGE_Mun) %>% 
  summarise(Num_mortes_total_ou           = sum (DH_MORTOS),
            Danos_Humanos_total_ou        = sum(DH_total_danos_humanos),
            Danos_Materiais_total_ou      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total_ou = sum (PEPL_total_publico),
            Perdas_setor_privado_total_ou = sum (PEPR_total_privado),
            Perdas_total_ou               = sum(PE_PLePR),
            Num_ocorrencias_total_ou      = n(),
            num_anos_rep_total_ou         = n_distinct(year(Data_Registro)))

danos_sum_ou$IRQ_ou =(((danos_sum_ou$Num_mortes_total_ou                                     *6)/100000) +
                      ((danos_sum_ou$Danos_Humanos_total_ou                                  *3)/100000) +
                     (((danos_sum_ou$Danos_Materiais_total_ou + danos_sum_ou$Perdas_total_ou)*1)/100000))/10 
  }
  
# Movimentação de massa (mm)
{
danos_sum_mm <- mapa_danos_mm %>% group_by(Cod_IBGE_Mun) %>% 
  summarise(Num_mortes_total_mm           = sum (DH_MORTOS),
            Danos_Humanos_total_mm        = sum(DH_total_danos_humanos),
            Danos_Materiais_total_mm      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total_mm = sum (PEPL_total_publico),
            Perdas_setor_privado_total_mm = sum (PEPR_total_privado),
            Perdas_total_mm               = sum(PE_PLePR),
            Num_ocorrencias_total_mm      = n(),
            num_anos_rep_total_mm         = n_distinct(year(Data_Registro)))

danos_sum_mm$IRQ_mm =(((danos_sum_mm$Num_mortes_total_mm                                     *6)/100000) +
                      ((danos_sum_mm$Danos_Humanos_total_mm                                  *3)/100000) +
                     (((danos_sum_mm$Danos_Materiais_total_mm + danos_sum_mm$Perdas_total_mm)*1)/100000))/10 
}
  
# Erosão (er)
{
danos_sum_er <- mapa_danos_er %>% group_by(Cod_IBGE_Mun) %>% 
  summarise(Num_mortes_total_er           = sum (DH_MORTOS),
            Danos_Humanos_total_er        = sum(DH_total_danos_humanos),
            Danos_Materiais_total_er      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total_er = sum (PEPL_total_publico),
            Perdas_setor_privado_total_er = sum (PEPR_total_privado),
            Perdas_total_er               = sum(PE_PLePR),
            Num_ocorrencias_total_er      = n(),
            num_anos_rep_total_er         = n_distinct(year(Data_Registro)))

danos_sum_er$IRQ_er =(((danos_sum_er$Num_mortes_total_er                                     *6)/100000) +
                      ((danos_sum_er$Danos_Humanos_total_er                                  *3)/100000) +
                     (((danos_sum_er$Danos_Materiais_total_er + danos_sum_er$Perdas_total_er)*1)/100000))/10 
}
  
# Chuvas e Vendavais (cv)
{
danos_sum_cv <- mapa_danos_cv %>% group_by(Cod_IBGE_Mun) %>% 
  summarise(Num_mortes_total_cv           = sum (DH_MORTOS),
            Danos_Humanos_total_cv        = sum(DH_total_danos_humanos),
            Danos_Materiais_total_cv      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total_cv = sum (PEPL_total_publico),
            Perdas_setor_privado_total_cv = sum (PEPR_total_privado),
            Perdas_total_cv               = sum(PE_PLePR),
            Num_ocorrencias_total_cv      = n(),
            num_anos_rep_total_cv         = n_distinct(year(Data_Registro)))

danos_sum_cv$IRQ_cv =(((danos_sum_cv$Num_mortes_total_cv                                     *6)/100000) +
                      ((danos_sum_cv$Danos_Humanos_total_cv                                  *3)/100000) +
                     (((danos_sum_cv$Danos_Materiais_total_cv + danos_sum_cv$Perdas_total_cv)*1)/100000))/10 
}
  
# Seca (se)
  {  
danos_sum_se <- mapa_danos_se %>% group_by(Cod_IBGE_Mun) %>% 
  summarise(Num_mortes_total_se           = sum (DH_MORTOS),
            Danos_Humanos_total_se        = sum(DH_total_danos_humanos),
            Danos_Materiais_total_se      = sum(DM_total_danos_materiais),
            Perdas_setor_publico_total_se = sum (PEPL_total_publico),
            Perdas_setor_privado_total_se = sum (PEPR_total_privado),
            Perdas_total_se               = sum(PE_PLePR),
            Num_ocorrencias_total_se      = n(),
            num_anos_rep_total_se         = n_distinct(year(Data_Registro)))

danos_sum_se$IRQ_se =(((danos_sum_se$Num_mortes_total_se                                     *6)/100000) +
                      ((danos_sum_se$Danos_Humanos_total_se                                  *3)/100000) +
                     (((danos_sum_se$Danos_Materiais_total_se + danos_sum_se$Perdas_total_se)*1)/100000))/10
  }
  

# Junta todos em uma mesma Planilha
{
url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/Planilha_todos_municipios.xlsx"

danos_IRQ <-  read_xlsx(url)

danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum,           by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_2012_2023, by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_cv,        by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_er,        by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_mm,        by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_ou,        by = "Cod_IBGE_Mun")
danos_IRQ <- sparklyr::left_join(danos_IRQ, danos_sum_se,        by = "Cod_IBGE_Mun")



url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/Atlas_Danos_sumarizados_IRQ.xlsx"
writexl::write_xlsx(danos_IRQ, url)

}

# Pesos (formula proposta - rejeitada)
{  
{
  # Óbitos (Motes por habitante)                 Peso 5
  # Danos Humanos                                Peso 2
  # Danos materiais                              Peso 1
  # Prejuízos Totais (Perdas Publico + Privado)  Peso 1
  # Número de ocorrência desde o inicio da  série (1991) - Peso 1
}


##### Chuvas e Vendavais #####
{
danos_sum_iqr$Num_total_mortes_cv_z      <- f_minmax(scale(danos_sum_iqr$Num_total_mortes_cv          /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_cv_z   <- f_minmax(scale(danos_sum_iqr$Danos_Humanos_total_cv       /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_cv_z <- f_minmax(scale(danos_sum_iqr$Danos_Materiais_total_cv     /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_cv_z          <- f_minmax(scale(danos_sum_iqr$Total_perdas_cv              /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_cv_z       <- f_minmax(scale(danos_sum_iqr$Num_ocorrencias_cv))

danos_sum_iqr$i_cv <- ((danos_sum_iqr$Num_total_mortes_cv_z * 5) +
                       (danos_sum_iqr$Danos_Humanos_total_cv_z * 1) +
                       (danos_sum_iqr$Danos_Materiais_total_cv_z * 1) +
                       (danos_sum_iqr$Total_perdas_cv_z  * 1) +
                       (danos_sum_iqr$Num_ocorrencias_cv_z * 2)) / 10

danos_sum_iqr$iqr_cv <- f_minmax(danos_sum_iqr$i_cv)
}

##### Erosões ###
{
danos_sum_iqr$Num_total_mortes_er_z      <- f_minmax(scale(danos_sum_iqr$Num_total_mortes_er        /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_er_z   <- f_minmax(scale(danos_sum_iqr$Danos_Humanos_total_er     /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_er_z <- f_minmax(scale(danos_sum_iqr$Danos_Materiais_total_er   /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_er_z          <- f_minmax(scale(danos_sum_iqr$Total_perdas_er            /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_er_z       <- f_minmax(scale(danos_sum_iqr$Num_ocorrencias_er))

danos_sum_iqr$i_er <- ((danos_sum_iqr$Num_total_mortes_er_z * 5) +
                         (danos_sum_iqr$Danos_Humanos_total_er_z * 1) +
                         (danos_sum_iqr$Danos_Materiais_total_er_z * 1) +
                         (danos_sum_iqr$Total_perdas_er_z  * 1) +
                         (danos_sum_iqr$Num_ocorrencias_er_z * 2)) / 10

danos_sum_iqr$iqr_er <-  f_minmax(danos_sum_iqr$i_er)
}


### Movimentação de massa
{
danos_sum_iqr$Num_total_mortes_mm_z      <- f_minmax(scale(danos_sum_iqr$Num_total_mortes_mm         /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_mm_z   <- f_minmax(scale(danos_sum_iqr$Danos_Humanos_total_mm      /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_mm_z <- f_minmax(scale(danos_sum_iqr$Danos_Materiais_total_mm    /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_mm_z          <- f_minmax(scale(danos_sum_iqr$Total_perdas_mm             /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_mm_z       <- f_minmax(scale(danos_sum_iqr$Num_ocorrencias_mm))

danos_sum_iqr$i_mm <- ((danos_sum_iqr$Num_total_mortes_mm_z * 5) +
                         (danos_sum_iqr$Danos_Humanos_total_mm_z * 1) +
                         (danos_sum_iqr$Danos_Materiais_total_mm_z * 1) +
                         (danos_sum_iqr$Total_perdas_mm_z  * 1) +
                         (danos_sum_iqr$Num_ocorrencias_mm_z * 2)) / 10

danos_sum_iqr$iqr_mm <-  f_minmax(danos_sum_iqr$i_mm)

}

### outros
{
danos_sum_iqr$Num_total_mortes_ou_z      <- f_minmax(scale(danos_sum_iqr$Num_total_mortes_ou         /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_ou_z   <- f_minmax(scale(danos_sum_iqr$Danos_Humanos_total_ou      /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_ou_z <- f_minmax(scale(danos_sum_iqr$Danos_Materiais_total_ou    /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_ou_z          <- f_minmax(scale(danos_sum_iqr$Total_perdas_ou             /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_ou_z       <- f_minmax(scale(danos_sum_iqr$Num_ocorrencias_ou))

danos_sum_iqr$i_ou <- ((danos_sum_iqr$Num_total_mortes_ou_z * 5) +
                         (danos_sum_iqr$Danos_Humanos_total_ou_z * 1) +
                         (danos_sum_iqr$Danos_Materiais_total_ou_z * 1) +
                         (danos_sum_iqr$Total_perdas_ou_z  * 1) +
                         (danos_sum_iqr$Num_ocorrencias_ou_z * 2)) / 10

danos_sum_iqr$iqr_ou <-  f_minmax(danos_sum_iqr$i_ou)
}
        
#### Secas 
{
danos_sum_iqr$Num_total_mortes_se_z      <- f_minmax(scale(danos_sum_iqr$Num_total_mortes_se         /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_se_z   <- f_minmax(scale(danos_sum_iqr$Danos_Humanos_total_se      /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_se_z <- f_minmax(scale(danos_sum_iqr$Danos_Materiais_total_se    /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_se_z          <- f_minmax(scale(danos_sum_iqr$Total_perdas_se             /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_se_z       <- f_minmax(scale(danos_sum_iqr$Num_ocorrencias_se))

danos_sum_iqr$i_se <- ((danos_sum_iqr$Num_total_mortes_se_z * 5) +
                         (danos_sum_iqr$Danos_Humanos_total_se_z * 1) +
                         (danos_sum_iqr$Danos_Materiais_total_se_z * 1) +
                         (danos_sum_iqr$Total_perdas_se_z  * 1) +
                         (danos_sum_iqr$Num_ocorrencias_se_z * 2)) / 10

danos_sum_iqr$iqr_se <-  f_minmax(danos_sum_iqr$i_se)

}

# IQR final
{
danos_sum_iqr$Num_total_mortes_z      <- f_minmax((danos_sum_iqr$Num_total_mortes))      # /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Humanos_total_z   <- f_minmax((danos_sum_iqr$Danos_Humanos_total          /danos_sum_iqr$Populacao_censo2022))
danos_sum_iqr$Danos_Materiais_total_z <- f_minmax((danos_sum_iqr$Danos_Materiais_total        /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Total_perdas_z          <- f_minmax((danos_sum_iqr$Total_perdas                 /danos_sum_iqr$Pib_Municipal))
danos_sum_iqr$Num_ocorrencias_z       <- f_minmax((danos_sum_iqr$Num_ocorrencias))

danos_sum_iqr$iqr    <- ((danos_sum_iqr$Num_total_mortes_z * 5) +
                         (danos_sum_iqr$Danos_Humanos_total_z * 1) +
                         (danos_sum_iqr$Danos_Materiais_total_z * 1) +
                         (danos_sum_iqr$Total_perdas_z  * 1) +
                         (danos_sum_iqr$Num_ocorrencias_z * 2)) / 10

# danos_sum_iqr$iqr <- f_minmax(danos_sum_iqr$iqr)

danos_sum_iqr$iqr <- (danos_sum_iqr$i_cv + danos_sum_iqr$i_er + danos_sum_iqr$i_mm + danos_sum_iqr$i_ou + danos_sum_iqr$i_se)

danos_sum_iqr$iqr <- f_minmax(danos_sum_iqr$iqr)

}
    
}

    
#Clusteriza IRQ (ordem inversa)
  {    

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/Atlas_Danos_sumarizados_IRQ.xlsx"
danos_IRQ <- read_xlsx(url)

danos_IRQ$cluster_IRQ <- ""

# Formula IRQ_calc
# SE(Num_ocorrencias_total <=1;0;LOG(Num_ocorrencias_total)) +
# SE(num_anos_rep_total<=1;0;LOG(num_anos_rep_total))        +
# SE(IRQ<=1;0;LOG(IRQ))

danos_IRQ$IRQ_std <- scale(danos_IRQ$IRQ_reduzido)
danos_IRQ$IRQ_std2 <- f_minmax(log10(danos_IRQ$IRQ))


# Clusteriza com base no IRQ padronizado pelo desvio padrão (ordem inversa)
    
for(i in 1:nrow(danos_IRQ)) {
  if (danos_IRQ$IRQ_std[i] > 1.5) {danos_IRQ$cluster_IRQ[i] <- "E"}
  else {
    if (danos_IRQ$IRQ_std[i] > 0.5) {danos_IRQ$cluster_IRQ[i] <- "D"}
    else
      if (danos_IRQ$IRQ_std[i] > -0.5) {danos_IRQ$cluster_IRQ[i] <- "C"}
    else
      if (danos_IRQ$IRQ_std[i] > -1.5) {danos_IRQ$cluster_IRQ[i] <- "B"}
    else
    {danos_IRQ$cluster_IRQ[i] <- "A"}}}
    

url <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/Atlas Digital de Desastres/Atlas_Danos_sumarizados_IRQ_todascolunas2.xlsx"

writexl::write_xlsx(danos_IRQ, url)
    }  
    
# Fórmula de calcula atual do IRQ
# =(((mortes*6)/100000)+((danos_humanos*3)/100000)+((prejuizoz_totais*1)/100000))/10  
    
    
    
  