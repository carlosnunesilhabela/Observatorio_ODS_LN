# Função: Standardização do histórico das despesas (retirada de caracteres especiais, numeros e uppercase)

std_histdesp <- function(dsname) {
 
# Lê o arquivo de dsname (despesas a ser trabalhado)

# Colunas
  #27 - eventos
  #26 - subcategorias
  #25 - categoria
  #24 - historico_std
  #23 - historico_despesa

despesas_acum <- read_xlsx(dsname)

# Executa função de padronização (retorna msg de erro mas executa a função)
despesas_acum$historico_std <- std_str(despesas_acum$historico_despesa)

despesas_acum <-data.frame(despesas_acum)

# save(despesas_acum, file = "Despesas_municipios.Rdata") # Salva em formato RData

write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx


return()
} # FUNÇÃO: std_histdesp - Padronização do historico das despesas
