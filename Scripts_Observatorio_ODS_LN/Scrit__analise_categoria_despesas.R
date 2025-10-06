# SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# executar o script Function_ALL.R primeiramente (Cria as funções a serem utilizadas)

dsname <- "Despesas_municipios.xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 
           
categoria_sel <- "Desapropriacao"  # categoria a ser selecionada (dentre as abaixo)
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
#      despesas_acum$categoria     <- ''
# 26 - subcategoria
#      despesas_acum$subcategoria <- ''
# 27 - eventos
#      despesas_acum$eventos   
# 28 - selecao
# 29 - OTMU

palavras_sel <- read_excel("Tabelas/Lista_de_Keywords.xlsx")

palavras_sel = palavras_sel  %>% filter(categoria == categoria_sel) %>%  select('palavra') 

for (j in 1:nrow(despesas_acum)) {
 
   tem_evento = 0
  for (i in 1:nrow(palavras_sel)) {

    evento_sim <- str_detect(despesas_acum$historico_std[j], palavras_sel$palavra[i])  #24 = hist-str
   
    if (evento_sim) {
       tem_evento <- tem_evento +1
      }  # end if
    
    } # end for interno
   
    if (tem_evento > 0) {
      despesas_acum[j,27] <- paste(categoria_sel, ";", sep="") }
   else {
     despesas_acum[j,27] <- "N"
     }
    
} #end for externo (Verifica se lançamento refere-se a Eventos)

# despesas_acum <- data.frame(despesas_acum)
# save(despesas, file = "Despesas_municipios.Rdata") # Salva em formato RData

write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx


