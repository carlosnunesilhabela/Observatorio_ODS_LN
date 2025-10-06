
############################Função: configs (Configurações) ############################### 

configs <- function() {
  diretorio <- '/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace'
  
   #localização das Bases já baixadas até 2022
   based_ate_2022_loc <- "C:/Users/carlo/Desktop/Observatório dos ODS/Orçamentos_LN _2008_2022/_Despesas-Ilhabela-2008-2022.xlsx"
   baser_ate_2022_loc <- "C:/Users/carlo/Desktop/Observatório dos ODS/Orçamentos_LN _2008_2022/_Receitas-Ilhabela-2008-2022.xlsx"
   
  setwd(diretorio) #define workspace directory 
  getwd()
  
# lista_mun_rmvale <- read_xlsx("Lista_de_municipios_RM_Vale.xlsx")  # 39 municipios da RM_Vale 
# lista_municipios <- lista_mun_rmvale$nm_municipio                  # default = 39 municipios da rmvale

  } # FUNÇÃO: configs (configurações)
