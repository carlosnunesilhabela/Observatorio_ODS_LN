### SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# Executar inicialmente o script Funcion.ALL.R
# configs()
# load_packages()

# Define lista dos municipios a serem baixados (utilizar uma das opções abaixo)
### utiliza o pacote readxl
library(readxl)
library(writexl)

lista_mun_rmvale <- read_xlsx("Tabelas/Municipios_RMVale.xlsx")  # 39 municipios da RM_Vale
lista_mun_rmvale <- dplyr::filter(lista_mun_rmvale, selecao == "S")

lista_municipios <- lista_mun_rmvale$nm_mun            # default = 39 municipios da rmvale
# lista_municipios <- c('sao-jose-dos-campos')         #opcionalmente especificar municipio

# anos <- readline(prompt = "Qual ano deseja baixar?: ")  # Digitar anos ou linha abaixo ou

anos <- c("2023") # "2021", "2022", "2023")    # colocar nesta variável, todos os anos que pretende baixar

download_receitas(anos, lista_municipios) #  grava o arquivo Receitas_municipios.xlsx

download_despesas(anos,lista_municipios)
    # load("Despesas_municipios.Rdata")
    # dsname <- "Despesas_municipios.xlsx"
    # write.xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx


####################### Procedimento para execução manual download despesas #######################################################################
{
library('xlsx')
library(stringr)
configs()

despesas_acum <- read.csv(file = "despesas-ilhabela-2024.csv", sep = ";", header = T, encoding = "latin1")
# despesas_acum <- read_xlsx("Despesas-municipio_2008-2023.xlsx") # opção para juntar base antiga

# Cria Novas Colunas
despesas_acum$historico_std     <- ''
despesas_acum$categoria         <- ''
despesas_acum$subcategoria      <- ''
despesas_acum$eventos           <- ''
despesas_acum$selecao           <- ''
despesas_acum$otmu              <- ''

despesas_acum <- dplyr::filter(despesas_acum, tp_despesa == "Valor Liquidado")

despesas_acum$historico_std <- tolower(despesas_acum$historico_despesa)                             # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
despesas_acum$historico_std <- rm_accent(despesas_acum$historico_std)                           # Remove todas acentuações 
despesas_acum$historico_std <- str_replace_all(despesas_acum$historico_std, "[^[:alnum:]]", "") # remove non alphanumeric characters

write.xlsx(despesas_acum, "despesas-ilhabela-2024.xlsx") #grava data frame em formato *.xlsx
}


#Seleciona apenas gastos com educação
{
despesas_acum <- read_xlsx("Despesas_municipios.xlsx") 

despesas_acum <- dplyr::filter(despesas_acum, ds_funcao_governo == "EDUCAÇÃO")

write_xlsx(despesas_acum, "Despesas_municipios_educacao.xlsx") 
}
