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
 
#Ler IEGM 2023 e juntar na ABT
{
iegm <- read_xlsx("C:/Users/carlo/Desktop/Observatório dos ODS/IEGM/ListagemGeralFaixa_2023.xlsx")
iegm$COD_MUN <- as.character(iegm$COD_MUN)

url <- "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale.xlsx"
abt <- read_xlsx(url)



url2 = "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale2.xlsx"

writexl::write_xlsx(abt2, url2)
}

# investimentos em saneamento 10 anos
{
snis <- read_xlsx("ConsolidadoMunicipio-20241124212413_Investimentos.xlsx")
snis$COD_MUN <- as.character(snis$COD_MUN)

snisrmvale <- dplyr::filter(snis, COD_MUN == "350250" | #7 
                                  COD_MUN == "352040" | #4
                                  COD_MUN == "350315" | #8
                                  COD_MUN == "350350" | #5 
                                  COD_MUN == "350490" | #9
                                  COD_MUN == "350850" | #4
                                  COD_MUN == "350860" | #3
                                  COD_MUN == "350970" | #0
                                  COD_MUN == "350995" | #7
                                  COD_MUN == "351050" | #0
                                  COD_MUN == "351340" | #5
                                  COD_MUN == "351360" | #3
                                  COD_MUN == "351840" | #4
                                  COD_MUN == "352020" | #2
                                  COD_MUN == "352440" | #2
                                  COD_MUN == "352490" | #7
                                  COD_MUN == "352630" | #8
                                  COD_MUN == "352660" | #5
                                  COD_MUN == "352720" | #7
                                  COD_MUN == "353170" | #4
                                  COD_MUN == "353230" | #6
                                  COD_MUN == "353560" | #6
                                  COD_MUN == "353800" | #6
                                  COD_MUN == "353850" | #1
                                  COD_MUN == "354075" | #4
                                  COD_MUN == "354190" | #1
                                  COD_MUN == "354230" | #5
                                  COD_MUN == "354430" | #1
                                  COD_MUN == "354600" | #9
                                  COD_MUN == "354820" | #3
                                  COD_MUN == "354860" | #9
                                  COD_MUN == "354960" | #7
                                  COD_MUN == "354990" | #4
                                  COD_MUN == "355000" | #1
                                  COD_MUN == "355070" | #4
                                  COD_MUN == "355200" | #7
                                  COD_MUN == "355410" | #2
                                  COD_MUN == "355480" | #5
                                  COD_MUN == "355540" ) #6

snisrmvale <- read_xlsx("snis_rmvale2.xlsx")

snissum <- snisrmvale %>% group_by(COD_MUN) %>% 
  summarise(inv_san_10anos = sum (Inv_tot))


writexl::write_xlsx(snissum, "snis_rmvale_sum.xlsx")    

}  


# IVCM
{
# Menor ou Igual a 40 - Verde Escuro
# Entre 40 a 48 - Verde
# Entre 48 a 52 - Amarelo
# Entre 52 a 60 - Laranja
# Maior que 60 - Vermelho
# Município fora dos parâmetros - Cinza
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


# Seleciona colunas EDUCAÇÃO - prepara para DEA
{
url = "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale.xlsx"
abt <- read_xlsx(url)
abt <-abt[1:39,] # deleta linhas de benchmark

edu <- abt %>% select(c(COD_MUN,
                        Municipio,
                        Populacao_censo2022,
                        receitas_correntes_10000000_2023_PC, 
                        desp_12edu_2023_PC,
                        Docentes_Ensino_infantil,
                        Docentes_Ensino_fundamental,
                        Matriculas_Ensino_infantil,
                        Matriculas_Ensino_fundamental,
                        Escolas_Ensino_infantil,
                        Escolas_Ensino_fundamental,
                        Abandono_no_Ensino_Fundamental,
                        Abandono_no_Ensino_Medio,
                        IDEB_2023_F1,
                        IDEB_2023_F2,
                        Desempenho_Educacao_Distorcao_Idade_Serie_Ens_Fund_Dado_Bruto))

edu$Docentes_PC <- (edu$Docentes_Ensino_infantil +
                    edu$Docentes_Ensino_fundamental) / 
                   (edu$Matriculas_Ensino_infantil +
                    edu$Matriculas_Ensino_fundamental)
edu$Matricula_total <- (edu$Matriculas_Ensino_infantil +
                        edu$Matriculas_Ensino_fundamental)
edu$Retencao = ( 1 - edu$Abandono_no_Ensino_Fundamental)

writexl::write_xlsx(edu, "abt_edu.xlsx")  #grava data frame em formato *.xlsx
}

# Seleciona colunas SANEAMENTO - prepara para DEA
{
  url = "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale.xlsx"
  abt <- read_xlsx(url)
  
 san <- abt %>% select(c(COD_MUN,
                          Municipio,
                          Populacao_censo2022,
                          receitas_correntes_10000000_2023_PC,
                          desp_17sab_2023,
                          Qtd_RDO_e_RPU_2022,
                          FN033_Investimentos_totais_realizados_sabesp,
                          FN048_Investimentos_totais_municipio,
                          FN058_Investimentos_totais_estado,
                          CS009_Resíduos_Recicláveis,
                          FN220_Despesas_Municipais_com_residuos,
                          TB015_Qtde_trabalhadores_residuos,
                          IN015_AE_Índice_de_coleta_de_esgoto,
                          IN055_AE_Índice_de_atendimento_agua,
                          inv_total_saneamento_10anos
                          ))
  
san$IN015_AE_Índice_de_coleta_de_esgoto <- san$IN015_AE_Índice_de_coleta_de_esgoto/100
san$IN055_AE_Índice_de_atendimento_agua <- san$IN055_AE_Índice_de_atendimento_agua/100
san$Qtd_RDO_e_RPU_2022_PC               <- ((san$Qtd_RDO_e_RPU_2022 / san$Populacao_censo2022) / 365) * 1000
san$CS009_Resíduos_Recicláveis_perc     <- san$CS009_Resíduos_Recicláveis / san$Qtd_RDO_e_RPU_2022
san$inv_tot                             <- (san$FN033_Investimentos_totais_realizados_sabesp +
                                            san$FN048_Investimentos_totais_municipio +
                                            san$FN058_Investimentos_totais_estado) / san$Populacao_censo2022
san$desp_17sab_2023_PC                  <-  san$desp_17sab_2023 / san$Populacao_censo2022
  
writexl::write_xlsx(san, "abt_san.xlsx")  #grava data frame em formato *.xlsx
}
  
# Seleciona colunas SAUDE - prepara para DEA
{
  url = "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale.xlsx"
  abt <- read_xlsx(url)
  
  sau <- abt %>% select(c(COD_MUN,
                          Municipio,
                          Populacao_censo2022,
                          receitas_correntes_10000000_2023_PC,
                          desp_10sau_2023,
                          desp_10sau_2023_PC,
                          Mortalidade_Infantil_ate_5_anos,
                          Desempenho_Saude_Cobertura_Atencao_Basica_Dado_Bruto,
                          Quantidade_Leitos_1000h,
                          Quantidade_estabelec_saude_1000h,
                          Med_1000habitante,
                          Enf_1000habitante
                          ))
  
writexl::write_xlsx(sau, "abt_sau.xlsx")  #grava data frame em formato *.xlsx
}
  
# Seleciona colunas SEGURANÇA - prepara para DEA
{
 url = "C:/Users/carlo/Desktop/Mestrado FSP_USP - 2210 FSP-MProASaS/Projeto_Dissertação/Entrega final/ABT_MDR_caracterizacao_municipios_RMVale.xlsx"
 abt <- read_xlsx(url)
  
  seg <- abt %>% select(c(COD_MUN,
                          Municipio,
                          Populacao_censo2022,
                          receitas_correntes_10000000_2023_PC,
                          desp_06seg_2023_PC,
                          TOT._DE_INQUÉRITOS_POLICIAIS_INSTAURADOS,
                          HOMICÍDIO_DOLOSO,
                          TOTAL_DE_ESTUPRO,
                          ROUBO_OUTROS,
                          FURTO_OUTROS
                          ))
  seg$TOT._DE_INQUÉRITOS_POLICIAIS100 <- seg$TOT._DE_INQUÉRITOS_POLICIAIS_INSTAURADOS/seg$Populacao_censo2022*100000
  seg$HOMICÍDIOS100                   <- seg$HOMICÍDIO_DOLOSO/seg$Populacao_censo2022*100000
  seg$ESTUPROS100                     <- seg$TOTAL_DE_ESTUPRO/seg$Populacao_censo2022*100000
  seg$ROUBOS100                       <- seg$ROUBO_OUTROS/seg$Populacao_censo2022*100000
  seg$FURTO100                        <- seg$FURTO_OUTROS/seg$Populacao_censo2022*100000
  
  writexl::write_xlsx(seg, "abt_seg.xlsx")  #grava data frame em formato *.xlsx
}