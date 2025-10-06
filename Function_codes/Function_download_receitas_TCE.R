############ Função Download Receitas do TCE  - municípios da lista_mun_minusculas 

download_receitas <- function(anos_f, lista_municipios_f) {
 
  tipo = "receitas"
  receitas_acum <- read.csv(file = "receitas_vazia.csv", sep = ";", header = T, encoding = "latin1")
  # receitas_acum <- read_xlsx("Receitas-Ilhabela-2008-2022.xlsx") # opção de juntar antigo 
  
  
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
  
  write_xlsx(receitas_acum, "Receitas_municipios.xlsx") #grava data frame em formato *.xlsx
  
} # FUNÇÃO download_receitas
