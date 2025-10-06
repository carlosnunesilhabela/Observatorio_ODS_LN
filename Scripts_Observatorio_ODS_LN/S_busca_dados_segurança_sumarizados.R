########################################

configs()

# Carrega Pacotes
{ load_packages()

  library(tidyverse)  #pacote para manipulacao de dados
  library(cluster)    #algoritmo de cluster
  library(dendextend) #compara dendogramas
  library(factoextra) #algoritmo de cluster e visualizacao
  library(fpc)        #algoritmo de cluster e visualizacao
  library(gridExtra)  #para a funcao grid arrange
  library(readxl)
  library(ggplot2)
  library(stringr)
  library(dplyr)
  library(sparklyr)
  library(writexl)
  library(readxl)
  #library( readr#
  
}

ano <- "2015"

# url_baixar <- paste("https://www.gov.br/mj/pt-br/assuntos/sua-seguranca/seguranca-publica/estatistica/download/dnsp-base-de-dados/bancovde-", ano, ".xlsx/@@download/file",sep = "")
# df_name <- paste("ind_seg_", ano, ".xlsx",sep = "")

# download.file(url_baixar, df_name)               #traz para meu diretorio (vem sem ser zipado)

for(ano in c("2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024")) {
  
  arq_ler    <- paste("BancoVDE ", ano, ".xlsx", sep = "")
  
  print (arq_ler)
    
  Arq_temp <- read_xlsx(arq_ler);
  
  Arq_temp <-  filter(Arq_temp, (municipio == 'ILHABELA'             |
                                municipio   == 'CARAGUATATUBA'       | 
                                municipio   == 'SÃO SEBASTIÃO'       |
                                municipio   == 'SÃO JOSÈ DOS CAMPOS' |
                                municipio   == 'UBATUBA'             ) &
                                uf          == 'SP'                  )
  
  Arq_temp$data_referencia <- format(Arq_temp$data_referencia, format = "%Y")
  
  #  Arquivo <- filter(Arquivo, municipio == 'zzzzzz')
  
  
  Arquivo <- bind_rows(Arquivo,  Arq_temp) 
  
} 

arq_ler <- "BancoVDE 2015-2024.xlsx"
Arquivo <- read_xlsx(arq_ler)

# remove(Arq_seg_sum)

Arquivo$municipio


Arq_seg_sum <- Arquivo %>% 
               group_by(ano, municipio) %>% 
               dplyr::summarise(Tot_Vitima = sum(total_vitima), 
                                Tot_Prisao = sum(total_prisao),
                                .groups = "drop")

url1 <- "C:/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace_Observatorio_ODS_LN_2024/Segurança_LN_2015-2024.xlsx"
writexl::write_xlsx(Arq_seg_sum, url1)

warnings()
