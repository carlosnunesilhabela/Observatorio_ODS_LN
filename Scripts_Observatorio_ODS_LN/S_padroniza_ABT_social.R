# padroniza nomes das colunas da ABR
configs()

# Padroniza labels
{
ABT_metadados <- read_xlsx("ABT_Meta_dados.xlsx")

ABT_metadados$nome_ind_std <- tolower(ABT_metadados$Nome_Indicador) # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
ABT_metadados$nome_ind_std <- rm_accent(ABT_metadados$nome_ind_std) # Remove todas acentuações 
ABT_metadados$nome_ind_std <- str_replace_all(ABT_metadados$nome_ind_std, "[^[:alnum:]]", "")  # remove non alphanumeric characters

writexl::write_xlsx(ABT_metadados, "ABT_Meta_dados.xlsx") #grava data frame em formato *.xlsx
} # Stardardização de campos  

ABT_soc <- readxl::read_xlsx("ABT_municipios_social.xlsx")

ABT_soc$ODS1_Score                    <- scale(ABT_soc$ODS1_Score)
ABT_soc$ODS2_Score                    <- scale(ABT_soc$ODS2_Score)
ABT_soc$ODS3_Score                    <- scale(ABT_soc$ODS3_Score)
ABT_soc$ODS4_Score                    <- scale(ABT_soc$ODS4_Score)
ABT_soc$ODS5_Score                    <- scale(ABT_soc$ODS5_Score)
ABT_soc$ODS10_Score                   <- scale(ABT_soc$ODS10_Score)

ABT_soc$IPS_Brasil                    <- scale(ABT_soc$IPS_Brasil)

ABT_soc$Pop_com_abastecimento_de_agua_2022_PC <- scale(ABT_soc$Pop_com_abastecimento_de_agua_2022_PC) 

ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC  <- scale(ABT_soc$Populacao_atendida_com_esgotamento_sanitario_PC) 

ABT_soc$IVS2010             <- scale(ABT_soc$IVS2010)

ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto <- as.numeric(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)
ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto <- scale(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)
ABT_soc$teste <- scale(ABT_soc$Financas_Inv_per_Capita_Invest_Educacao_Dado_Bruto)

ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto       <- as.numeric(ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto) 
ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto       <- scale(ABT_soc$Financas_Inv_per_Capita_Invest_Saude_Dado_Bruto) 

ABT_soc$Desempenho_Seguranca_Indicador <- scale(ABT_soc$Desempenho_Seguranca_Indicador)

ABT_soc$Quantidade_Leitos_1000h <- scale(ABT_soc$Quantidade_Leitos_1000h)

ABT_soc$Quantidade_estabelec_saude_1000h <- scale(ABT_soc$Quantidade_estabelec_saude_1000h)

writexl::write_xlsx(ABT_soc, "ABT_municipios_social_std.xlsx")



