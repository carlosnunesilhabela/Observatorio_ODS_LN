### SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# Executar inicialmente o script Funcion.ALL.R

# Define lista dos municipios a serem baixados (utilizar uma das opções abaixo)

#  lista_mun_rmvale <- read_xlsx("Tabelas/Lista_de_municipios_RM_Vale.xlsx")  # 39 municipios da RM_Vale 
# lista_municipios <- lista_mun_rmvale$nm_municipio                          # default = 39 municipios da rmvale
lista_municipios <- c('caraguatatuba') # 'ilhabela', 'caraguatatuba', 'sao-sebastiao','ubatuba') 

# anos <- readline(prompt = "Qual ano deseja baixar?: ")  # Digitar anos ou linha abaixo ou

anos <- c('2023')    # colocar nesta variável, todos os anos que pretende baixar

download_receitas(anos, lista_municipios)

download_despesas(anos,lista_municipios)
