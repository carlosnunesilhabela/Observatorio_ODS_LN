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

ABT_eco <- readxl::read_xlsx("ABT_municipios_economico.xlsx")

ABT_eco$ODS8_Score                    <- scale(ABT_eco$ODS8_Score)
ABT_eco$ODS9_Score                    <- scale(ABT_eco$ODS9_Score)
ABT_eco$ODS11_Score                   <- scale(ABT_eco$ODS11_Score)
ABT_eco$Receitas_correntes_2022_PC    <- scale(ABT_eco$Receitas_correntes_2022_PC)
ABT_eco$Pib_municipal_PC              <- scale(ABT_eco$Pib_municipal_PC) 
ABT_eco$Total_empresas_inst_2022_PC   <- scale(ABT_eco$Total_empresas_inst_2022_PC) 
ABT_eco$Pessoal_ocupado_2022_PC       <- scale(ABT_eco$Pessoal_ocupado_2022_PC)
ABT_eco$Pessoal_Assalariado_2022_PC   <- scale(ABT_eco$Pessoal_Assalariado_2022_PC)
ABT_eco$qtd_pes_pob_12_2023_PC        <- scale(ABT_eco$qtd_pes_pob_12_2023_PC) 
ABT_eco$qtd_pes_baixa_renda_12_2023_PC <- scale(ABT_eco$qtd_pes_baixa_renda_12_2023_PC)

writexl::write_xlsx(ABT_eco, "ABT_municipios_economico_std.xlsx")



