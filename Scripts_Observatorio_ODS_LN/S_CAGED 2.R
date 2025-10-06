load_packages()

url <- "http://pdet.mte.gov.br/images/Novo_CAGED/2024/202403/3-tabelas.xlsx"
destino = "tabelas_caged.xlsx"
download.file(url, destfile = destino, mode = "wb")  

caged <- read_xlsx("tabelas_caged.xlsx", sheet = "Tabela 8.1", skip = 5 )

caged_filtrado <- caged[2:5579, 3:ncol(caged)]

colunas_para_converter<- 2:ncol(caged_filtrado)

#transforma todas colunas em numerico
caged_filtrado[colunas_para_converter] <- lapply(caged_filtrado[colunas_para_converter], as.numeric) 

dados_pivotado <- pivot_longer(caged_filtrado, 
                 cols = colnames(caged_filtrado) [2:ncol(caged_filtrado)],
                 names_to = 'variavel',
                 values_to = 'valor')

colnames(dados_pivotado)[1] <- "municipio"
head(dados_pivotado)

caged_rmvale <- filter(dados_pivotado, municipio == 'Sp-Ilhabela'      |
                         municipio == 'Sp-Caraguatatuba' | 
                         municipio == 'Sp-Sao Sebastiao' |
                         municipio == 'Sp-Sao Jose dos Campos' |
                         municipio == 'Sp-Ubatuba' )


