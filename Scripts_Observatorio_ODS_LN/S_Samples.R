# Samples de códigos


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
}

ls() # lista variáveis  do Environment

rm (a) # remove arquivos e variáveis do Environment
rm (List = ls()) # remove todos arquivos e variáveis do Environment

# Cria um vetor
x <- c(1:5)

matriz <- matrix(df_ln, nrow=3, ncol=3)


#load/save
{ load("data.RData") # To load the data again
save(data1, file = "data.RData") # Saving on object in RData format
save(data1, data2, file = "data.RData") # Save multiple objects
save.image(file = "meu_espaco_de_trabalho.RData") # Salvar todo o espaço de trabalho
}

# Read / Write .csv
{ rec <- utils::read.table("receitas_vazia.csv", header = TRUE,
                      sep = ";", dec = ",")
  utils::write.csv(dados, file = "/Users/Eugenia/MQ/dados.csv") }

# Read / Write .xlsx 
{ Arquivo <- read_xlsx("Info_Mun.xlsx", sheet = 1, skip = 1, col_names = columns); 
    writexl::write_xlsx(ABT, "ABT_MDR_PNUD.xlsx")  }
  
 # Stardardização de campos  
{ fild1 <- tolower(fild1)       # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
  fild1 <- rm_accent(fild1)     # Remove todas acentuações 
  fild1 <- str_replace_all(fild1, "[^[:alnum:]]", "")  # remove non alphanumeric characters
}

#Junta (Append) dataframes (roll bind)
{  
 df_total <- rbind.data.frame(df1, df2) } 

# juntando dados (col bind)
{ municipios2 <- read.table("dados/municipios.csv", sep = ";", header = T, dec = ",")
municipiosfit <- data.frame(municipios.k6$cluster)

#Agrupar cluster e base
MunicipioFinal <-  cbind(municipios2, municipiosfit) }

# Rename de colunas
{ dados <- rename(dados, new_name = old_name)
  colnames(dados)[5] <- "sp"
  
  names(df_desp_mun_tidy)[2:3]<- c("desp_legislativa","desp_administracao")
  }

# transforma em tibble
{
  iris <- as_tibble(iris) # transformando em tibble (não é necessário)
}

# Sumarização
{ BCP_sum <- BCP %>% group_by(MÊS.COMPETÊNCIA, CÓDIGO.MUNICÍPIO.SIAFI) %>% 
  summarise(quantidade = n())
#Opções
  summarise(tempo_médio = mean(tempo),
          mínimo = min(tempo),
          máximo = max(tempo),
          contagem = n()) %>% 
  arrange(desc(máximo))
}  
  
#  Filtro de linhas
{  
  dataset_filtrado <- dataset2 %>%
    dplyr::filter(campo1 == 10 & (campo2 == "abc" | campo2 == "bcd"))
}  

#Cria time series (sequencia de datas)
{
times = seq(as.Date('2016-01-01'), as.Date('2017-08-01'),  #Ajustar
            by='month') }

#join (pacote sparklyr)
{
shp_municipios_df <- shp_municipiossc_df %>% 
  sparklyr::left_join(dados_sc, by = "CD_GEOCMU")
}

#Baixar um arquivo diretamente da internet
{
download.file("https://www.gov.br/mdr/pt-br/centrais-de-conteudo/publicacoes/protecao-e-defesa-civil-sedec/lista_municipios_prioritarios_1972_anexos_I_e_II_20240606.pdf", "1403.2805.pdf", mode = "wb")
}

#Retirar notacao cientifica no R
{
  options(scipen = 999) }

#Concatenar campos
{ resultado <- paste("campo1"," - ", "campos2", sep="") }

# Padroniza variáveis (Z Score)
consumo_z <- scale(consumo[,-1])

#Seleciona colunas
{
consumo[,-2] #exceto segunda coluna
consumo[,2:3]
}

# Converte para numero para alfa e vice-versa 
{
numero <- as.numeric(texto)
alfa <- stringr::str_pad(cadunico$CD_MUN,0)  # ou
RMVale$COD_MUN <- as.character(RMVale$COD_MUN)
}

# Tibbles
{
#Tibbles são data frames com ajustes que as deixam mais amigáveis a nós cientistas de dados. Elas são parte do pacote {tibble}. Assim, para começar a usá-las, instale e carregue o pacote.
install.packages("tibble")
library(tibble)
mtcar_tib <- as_tibble(mtcars)
}

#Classificação (arrange)
{
dataset_cassificado <- arrange(dataset, (campo1, desc(campo2)) 
} # default é ascending 

#Remove duplicados
{ 
  cod2 <-cod_[!duplicated(cod_[c("Cod_IBGE_Mun")]),]
}

# Sub strings 
{
Sub_var <- substr(variavel, inicio, fim)) # veja que é diferente de outras linguagens que normalmente fornece o tamanho
}

# Rename de colunas
{
covid_sp <- covid_sp %>% 
  rename(data_sintomas = DT_SIN_PRI,
         municipio = ID_MN_RESI)
}

#Delete colunas
{
covid_sp <- covid_sp %>% select(-c(VACINA_COV,DT_EVOLUCA))
}

# Transforma todas as counas em numericas
{
df2 = as.data.frame(sapply(df,as.numeric)) #transforma todas colunas em numericas
}


############## sumarização de valores  ##############
{
# ideal (mas não obrigatório) que o campo chave da sumarização seja CHAR
  
    tab_pagtos$Cod_Mun_IBGE <- stringr::str_pad(tab_pagtos$Cod_Mun_IBGE,0) # transforma cod ibge em char
  
    danos_sum <- mapa_danos %>% dplyr::group_by(Cod_Mun_IBGE) %>% 
    dplyr::summarise(Num_mortes_total         = sum (DH_MORTOS),
                     Danos_Humanos_total      = sum(DH_total_danos_humanos),
                     Danos_Materiais_total    = sum(DM_total_danos_materiais),
                     Valor_pago_2012_2024     = sum(Valor_Pago),
                     Num_ocorrencias_total    = n(),
                     num_anos_rep_total       = n_distinct(year(Data_Registro)))
    
}


install.packages("Rserve",,"http://rforge.net")
