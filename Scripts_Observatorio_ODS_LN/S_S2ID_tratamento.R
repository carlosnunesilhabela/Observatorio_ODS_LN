# S2Id_Danos_Informados_2013_2024.xlsx
{
  S2id_danos <- read_xlsx("S2Id_Danos_Informados_2013_2024.xlsx")
 
  S2id_danos$municipio <- tolower(S2id_danos$Município)    # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
  S2id_danos$municipio <- rm_accent(S2id_danos$municipio)     # Remove todas acentuações 
  S2id_danos$municipio <- str_replace_all(S2id_danos$municipio, "[^[:alnum:]]", "") #  remove non alphanumeric characters
  
  # S2id_danos$CD_MUN <- ""
  
  head(S2id_danos$municipioUF)
  head(Cod_Mun$municipioUF)
  
  Cod_Mun <- read_xlsx("Cod_municipios_IBGE.xlsx")
  Cod_Mun <- Cod_Mun[,-c(2,3,4)]
  
  # Teste left_join
  {
  X <- read_xlsx("x.xlsx")
  Y <- read_xlsx("Y.xlsx")
    Teste1 <- sparklyr::left_join(X, Y, by = "nome")
  }
 
  S2id_danos_com_CD_MUN <- sparklyr::full_join(S2id_danos, Cod_Mun, by = "municipioUF")
  
writexl::write_xlsx(S2id_danos_com_CD_MUN, "S2Id_Danos_Informados_2013_2024_4.xlsx") #grava data frame em formato *.xlsx
  
  save(ABT, file = "ABT_MDR_PNUD.RData") # grava data frame em formato RData
  load("ABT_MDR_PNUD.RData")
  
  remove(ABT)
  
  