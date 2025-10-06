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

ABT_Amb <- readxl::read_xlsx("ABT_municipios_Amb.xlsx")

COD_MUN	
Municipio
municipio_std	
Populacao_censo2022	
ODS6_Score	
ODS7_Score	
ODS12_Score	
ODS13_Score	
ODS14_Score	
ODS15_Score	
Qualidade_do_Meio_Ambiente	
indice_de_Vulnerabilidade_Climatica_dos_Municipios	
Supressao_da_Vegetacao_Primaria_e_Secundaria	
Focos_de_Calor	
Emissoes_de_CO2e_por_Habitante	
areas_Verdes_Urbanas	
tem_S2ID_habilitado


ABT_Amb$ODS14_Score	                   <- scale(ABT_Amb$ODS14_Score	)


writexl::write_xlsx(ABT_Amb, "ABT_municipios_Amb_std.xlsx")



