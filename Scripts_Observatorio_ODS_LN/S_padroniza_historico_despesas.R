# SCRIPT: Standardização do histórico das despesas (retirada de caracteres especiais, numeros e uppercase)

load_packages()    # executa FUNÇÃO: carregar pacotes

configs()       # função setar configurações

dsname <- "Despesas-Ilhabela-2014-2025(Maio).xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 
 
std_histdesp(dsname)


