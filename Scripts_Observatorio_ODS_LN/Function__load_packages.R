########################## FUNÇÃO: load_packs - Carrega pacotes ######################## 

load_packages <- function() {

install.packages(c('readxl', 'dplyr'))  # pacotes minimos para executar a função
library('readxl')
library('dplyr')
 
pacotes_df <- read_xlsx("Tabelas/pacotes.xlsx")    #le planilha de pacotes e grava data frame
pacotes_df <- filter(pacotes_df, carregar == "S")
pacotes <- as.vector( pacotes_df$pacote)

print (pacotes)

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T)  # opção: lapply(carregar, require, character.only = TRUE)   
}

# O pacote rayshader que está no CRAN, no momento, possui alguns bugs. A versão
# que está no GitHub do autor do pacote já é mais funcional. Para instalá-la: (responder 3 na console)
# devtools::install_github("tylermorganwall/rayshader")  #(só a primeira vez)

# Para carregar o rayshader  (faz graficos tridimensionais - barras sobre o mapa)
# library(rayshader)

} # FUNÇÃO: carrega pacotes

# load_packages() # função carregar pacotes
