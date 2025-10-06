# SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# executar o script Function_ALL.R primeiramente (Cria as funções a serem utilizadas)

dsname <- "_Despesas-Ilhabela-2014-2025(Maio).xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 
           
despesas_acum <- read_xlsx(dsname)

# Colunas adicionais na base de dados de despesas
  # X  - historico_std	
  # Y  - categoria	
  # Z  - subcategoria 

# Le a tabela excel "Lista de Keywords para categorizacao"
tab_palavras <- read_excel("Tabelas/Lista_de_Keywords_para_categorizacao.xlsx")

categoria_sel <- "Eventos;"  # categoria a ser selecionada (dentre as abaixo)
  
lista_palavras  <- tab_palavras %>% filter(categoria == categoria_sel & operacao == "Inclui") %>%
  select('keyword')

lista_subfuncao <- tab_palavras %>% filter(categoria == categoria_sel & operacao == "subfuncao") %>%
  select('subfuncao')


for (j in 1:nrow(despesas_acum)) {
 
   tem_evento = 0
 
 
  for (i in 1:nrow(lista_palavras)) {

   # evento_sim <- str_detect(despesas_acum$historico_std[j], lista_palavras$keyword[i])  
     evento_sim <- any(grepl(lista_palavras$keyword[i], despesas_acum$historico_std[j])) 
    
    if (evento_sim) {
       tem_evento <- tem_evento +1
      }  # end if
    
    } # end for interno
   
    if (tem_evento > 0) {
      
      for (k in 1:nrow(lista_subfuncao)) {
           
           if (despesas_acum$subfuncao.governo == lista_subfuncao[k,]) {
               despesas_acum[j,25] <- categoria_sel  } # paste(categoria_sel, ";", sep="")
           else {
               despesas_acum[j,25] <- "Sem categoria"
           } # end if (despesas_acum$subfuncao.governo == lista_subfuncao[k,])
           
     } #end for (k in 1:nrow(lista_subfuncao) 
   
     } # end if (tem_evento > 0)
    
} #end for externo (Verifica se linha contem a categoria procurada)
   

despesas_acumf <- data.frame(despesas_acum)

# save(despesas, file = "Despesas_municipios.Rdata") # Salva em formato RData

write_xlsx(despesas_acumf, dsname) #grava data frame em formato *.xlsx


