# https://api.portaldatransparencia.gov.br/swagger-ui/index.html#/Benef%C3%ADcios/auxilioBrasilPorMunicipio

library(rvest) 
URL <- "https://aplicacoes.mds.gov.br/sagi/servicos/misocial/?fl=codigo_ibge%2Canomes_s%20qtd_pes_pob:cadun_qtd_pessoas_cadastradas_pobreza_pbf_i%20qtd_pes_baixa_renda:cadun_qtd_pessoas_cadastradas_baixa_renda_i%20qtd_pes_acima_meio_sm:cadun_qtd_pessoas_cadastradas_rfpc_acima_meio_sm_i&fq=cadun_qtd_pessoas_cadastradas_baixa_renda_i%3A*&q=*%3A*&rows=100000&sort=anomes_s%20desc%2C%20codigo_ibge%20asc&wt=csv&fq=anomes:%5b202303%20TO%20202312%5d" 
tabelas <- read_html(URL) %>% html_table() 
tabela1 <- tabelas[[1]] 
tabela1[[3]] <- NULL 
names(tabela1) <- c("Posição","Time") 

tabelas <- read_html(URL)


library("httr")
library("jsonlite")

URL_API <- "https://api.portaldatransparencia.gov.br/api-de-dados/auxilio-brasil-por-municipio?mesAno=202312&codigoIbge=3520400&pagina=1"

URL_API <- "https://aplicacoes.mds.gov.br/sagi/servicos/misocial/?fl=codigo_ibge%2Canomes_s%20qtd_pes_pob:cadun_qtd_pessoas_cadastradas_pobreza_pbf_i%20qtd_pes_baixa_renda:cadun_qtd_pessoas_cadastradas_baixa_renda_i%20qtd_pes_acima_meio_sm:cadun_qtd_pessoas_cadastradas_rfpc_acima_meio_sm_i&fq=cadun_qtd_pessoas_cadastradas_baixa_renda_i%3A*&q=*%3A*&rows=100000&sort=anomes_s%20desc%2C%20codigo_ibge%20asc&wt=csv&fq=anomes:%5b202303%20TO%20202312%5d"

get_budget <- GET(URL_API, type = "basic")
head(get_budget)

df1 <- dplyr::data_frame(get_budget_text)


writexl::write_xlsx(df1, "bf.xlsx")

get_budget_text <- content(get_budget, "text")
head(get_budget_text)
     
get_budget_json <- fromJSON(get_budget_text, flatten = TRUE)
get_budget_json
