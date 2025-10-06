load_packages()

configs()

library(stringr)

siafi <- read_xlsx("Tabelas/Codigo_IBGE_SIAFI_Municipios.xlsx") 
siafi$nome_municipio
siafi$NOME_MUNICIPIO


siafi$mun <- tolower(siafi$nome_municipio)                  # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
siafi$mun  <- rm_accent(siafi$mun)                          # Remove todas acentuações 
siafi$mun <- str_replace_all(siafi$mun, "[^[:alnum:]]", "") # remove non alphanumeric characters

siafi$MUN <- tolower(siafi$NOME_MUNICIPIO)                  # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
siafi$MUN  <- rm_accent(siafi$MUN)                          # Remove todas acentuações 
siafi$MUN <- str_replace_all(siafi$MUN, "[^[:alnum:]]", "") # remove non alphanumeric characters

if siafi$mun[1] != siafi$MUN[1]
{siafi$erro = "diferente"}

  # Executa função de padronização (retorna msg de erro mas executa a função)
  
 write.xlsx(siafi, "tabela_siafi.xlsx") #grava data frame em formato *.xlsx
  
   library('xlsx')
  
  for(ano in anos_f) {
    
    for(mun in lista_municipios_f) {
      
      print (paste("baixando", tipo, "de:", mun, "ano:", ano))
      
      url_baixar <- paste("https://transparencia.tce.sp.gov.br/sites/default/files/csv/", tipo, "-", mun, "-", ano, ".zip",sep = "")
      
      df_name_zip   <- paste(tipo, "-", mun, "-", ano, ".zip",sep = "")
      df_name_csv   <- paste(tipo, "-", mun, "-", ano, ".csv",sep = "")
      df_name_pasta <- paste(tipo, "-", mun, "-", ano,        sep = "")
      
      download.file(url_baixar, df_name_zip)               #traz para meu diretorio (vem zipado)
      unzip(df_name_zip, files = df_name_csv)              #Unzipa           
      
      file.remove(df_name_zip)
      #file.remove(df_name_pasta)
      
      receitas <- read.csv(file = df_name_csv, sep = ";", header = T, 
                           encoding = "latin1",dec = ",")
      receitas$dt_atlz    <- ''
      receitas$categoria  <- ''
      
      receitas_acum <- rbind.data.frame(receitas_acum, receitas)
      
      rm (receitas)
      file.remove (df_name_csv)
      
    }  # Fim do loop de município  
  }  # Fim do loop de ano
  
  colnames(receitas_acum) <- 
    c('Identificação da Receita',	
      'Ano',	
      'Municipio',	
      'Orgão',	
      'Mês',	
      'Mês extenso',	
      'Poder',	
      'Fonte de Recurso',	
      'Código aplicacao fixo',	
      'Código aplicação variavel',	
      'Categoria Econômica',	
      'Sub Categoria',	
      'Fonte',	
      'Rubrica',	
      'Alínea',	
      'Sub Alínea',	
      'Valor arrecadacao',
      'Data Atualização',
      'Categoria'
    )
  
  # save(receitas_acum, file = "Receitas_municipios.Rdata") # grava resultado em formato RData
  
  write.xlsx(receitas_acum, "Receitas_municipios.xlsx") #grava data frame em formato *.xlsx
  
} # FUNÇÃO download_receitas TCE

############ Função Download Despesas do TCE  - municípios da lista_mun_minusculas ###########
##### Tem como parametros de entrada, os anos a serem baixados e lista de municipios #########
download_despesas <- function(anos_f, lista_municipios_f) {
  
  # FUNÇÃO: Baixar DESPESAS dos municípios da lista_mun_minusculas ########################## 
  
  library('xlsx')
  tipo = "despesas"
  
  despesas_acum <- read.csv(file = "despesas_vazia.csv", sep = ";", header = T, encoding = "latin1")
  # despesas_acum <- read_xlsx("Despesas-municipio_2008-2023.xlsx") # opção para juntar base antiga
  
  # anos_f <- c("2020","2021")
  # lista_municipios_f <- c("sao-jose-dos-campos")
  
  for(ano in anos_f) {
    
    for(mun in lista_municipios_f) {
      
      print (paste("baixando", tipo, "de:", mun, "ano:", ano))
      
      url_baixar <- paste("https://transparencia.tce.sp.gov.br/sites/default/files/csv/", tipo, "-", mun, "-", ano, ".zip",sep = "")
      
      df_name_zip   <- paste(tipo, "-", mun, "-", ano, ".zip",sep = "")
      df_name_csv   <- paste(tipo, "-", mun, "-", ano, ".csv",sep = "")
      df_name_pasta <- paste(tipo, "-", mun, "-", ano,        sep = "")
      
      download.file(url_baixar, df_name_zip)               #traz para meu diretorio (vem zipado)
      unzip(df_name_zip, files = df_name_csv)              #Unzipa           
      
      file.remove(df_name_zip)
      
      file.remove(df_name_pasta)
      
      despesas <- read.csv(file = df_name_csv, sep = ";", header = T, 
                           encoding = "latin1", dec = ",")
      
      # Cria Novas Colunas
      despesas$historico_std     <- ''
      despesas$categoria         <- ''
      despesas$subcategoria      <- ''
      despesas$eventos           <- ''
      despesas$selecao           <- ''
      despesas$otmu              <- ''
      
      
      despesas_vl <- dplyr::filter(despesas, tp_despesa == "Valor Liquidado")
      
      despesas_acum <- rbind.data.frame(despesas_acum, despesas_vl)
      
      rm (despesas, despesas_vl)
      
      file.remove (df_name_csv)
      
    }  # Fim do loop de município  
  }  # Fim do loop de ano
  
  # colnames(despesas_acum) <- c('identificação da despesa detalhe',
  #                               'ano exercicio',
  #                               'municipio',
  #                               'Orgão',
  #                               'mês',
  #                               'mês extenso',
  #                               'tipo despesa',	
  #                               'Num. Empenho (interno)',	
  #                               'identificador despesa',
  #                               'destino da despesa (Fornecedor)',
  #                               'data emissao despesa',
  #                               'Valor',
  #                               'funcao de governo',
  #                               'subfuncao governo',
  #                               'codigo do programa',
  #                               'descrição do programa',	
  #                               'cód Ação',	
  #                               'descrição da acao',	
  #                               'Fonte de Recurso',	
  #                               'código da aplicacao fixo',	
  #                               'modalidade de licitação',
  #                               'Categoria Econômica e Descrição  da Despesa',	
  #                               'Histórico da despesa',
  #                               'historico_std',
  #                               'categoria',
  #                               'sub_categoria',
  #                               'eventos',
  #                               'selecão',
  #                               'otmu')
  
  
  save(despesas_acum, file = "Despesas_municipios.Rdata") # grava resultado em formato RData
  
  dsname <- "Despesas_municipios.xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 
  
  write.xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx
  
  std_histdesp(dsname) # cria campo histórico padronizado (sem acentuação)
  
} # FUNÇÃO: download_despesas TCE


############################  Exemplo de execução das funções ############################### 

# configs()       # executa função configurações 
# load_packages() # Executa a função carregar pacotes
# download_receitas(anos, lista_municipios)
# download_despesas(anos,lista_municipios)