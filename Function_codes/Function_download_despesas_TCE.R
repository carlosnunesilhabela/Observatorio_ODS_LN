############ Função Download Despesas do TCE  - municípios da lista_mun_minusculas ###########

download_despesas <- function(anos_f, lista_municipios_f) {
  
  # FUNÇÃO: Baixar DESPESAS dos municípios da lista_mun_minusculas ########################## 
  
  tipo = "despesas"
  despesas_acum <- read.csv(file = "despesas_vazia.csv", sep = ";", header = T, encoding = "latin1")
  # despesas_acum <- read_xlsx("Despesas-Ilhabela_2008-2022.xlsx") # opção para juntar base até 2022dados 
  
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
      
      
      despesas_vl <- filter(despesas, tp_despesa == "Valor Liquidado")
      
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
  
  
  # save(despesas_acum, file = "Despesas_municipios.Rdata") # grava resultado em formato RData

  dsname <- "Despesas_municipios.xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 

  write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx
  
  std_histdesp(dsname) # cria campo histórico padronizado (sem acentuação)
  
} # FUNÇÃO: download_despesas

