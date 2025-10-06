# SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# executar o script Function_ALL.R primeiramente (Cria as funções a serem utilizadas)dsname <- "Despesas-Ilhabela-2008-2023(out).xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 

dsname     <- paste0(pasta, "/Bkp_orcamento/Despesas-Ilhabela-bkp-2008-2024.xlsx") # Substituir DSN do arquivo de despesas a ser trabalhado
despesas_f <- read_xlsx(dsname) # opcional para alterar direto no arquivo xlsx

categoria_sel <- "Eventos;"  # categoria a ser selecionada (dentre as abaixo)
                # Publicidade
                # Eventos
                # Desapropriacao
                # Consultoria
                # Residuos


despesas_acum <- read_xlsx(dsname)
# Colunas: <- '' # cria e/ou limpa coluna de eventos 
# 23 - historico_despesa
# 24 - historico_std
# 25 - categoria
       despesas_acum$categoria     <- ''
# 26 - subcategoria
     despesas_acum$subcategoria <- ''
# 27 - eventos
       despesas_acum$eventos  <- ''   
# 28 - selecao
# 29 - OTMU

dsname     <- paste0(pasta, "/Tabelas/Lista_de_Keywords_para_categorizacao.xlsx") # Substituir DSN
palavras_sel <- read_excel(dsname)

palavras_sel = palavras_sel  %>% filter(categoria == categoria_sel) %>% filter(operacao == "Inclui") %>% select('keyword') 

i <- 0
j <- 0

for (j in 1:nrow(despesas_acum)) {
  
  tem_evento = 0
  for (i in 1:nrow(palavras_sel)) {
   
    evento_sim <- str_detect(despesas_acum$historico_std[j], palavras_sel$palavra[i])  #24 = hist-str
    
    if (evento_sim) {
      tem_evento <- tem_evento +1
    }  # end if
    
  } # end for interno
  
  if (tem_evento > 0) {
    despesas_acum[j,25] <- paste(categoria_sel, "; ", sep="") }
  else {
    despesas_acum[j,25] <- ""
  }
  
} #end for externo (Verifica se lançamento refere-se a Eventos)

# remove(despesas_acum)

# despesas_acum <- data.frame(despesas_acum)
# save(despesas, file = "Despesas_municipios.Rdata") # Salva em formato RData

write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx
# file.remove(dsname)
