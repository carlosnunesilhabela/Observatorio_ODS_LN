despesas_acum <- read_xlsx("Despesas_SJCampos_2020-2023.xlsx") # opcional para alterar direto no arquivo xlsx

save(despesas_acum, file = "Despesas_municipios.Rdata") # grava resultado em formato RData

dsname <- "Despesas_municipios.xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 

write.xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx

std_histdesp('despesas_acum') # cria campo histórico padronizado (sem acentuação)

} # FUNÇÃO: download_despesas TCE