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

ABT_Gov <- readxl::read_xlsx("ABT_municipios_Gov.xlsx")

ABT_Gov$ODS17_Score <- scale(ABT_Gov$ODS17_Score)
ABT_Gov$Cluster_IGM <- scale(ABT_Gov$Cluster_IGM)
ABT_Gov$Gestao_Transparencia_Transparencia_ATRICON_Nota <- scale(ABT_Gov$Gestao_Transparencia_Transparencia_ATRICON_Nota)
ABT_Gov$Gestao_Transparencia_Indicador <- scale(ABT_Gov$Gestao_Transparencia_Indicador)
ABT_Gov$Gestao_Dimensao <- scale(ABT_Gov$Gestao_Dimensao)
ABT_Gov$IGM_CFA <- scale(ABT_Gov$IGM_CFA)
ABT_Gov$Receitas_correntes_2022_PC <- scale(ABT_Gov$Receitas_correntes_2022_PC)

writexl::write_xlsx(ABT_Gov, "ABT_municipios_Gov_std.xlsx")



