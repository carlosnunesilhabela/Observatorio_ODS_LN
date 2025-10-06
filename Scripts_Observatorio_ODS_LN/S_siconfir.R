
# Script Busca dados no SICONFI (template FIRJAN)

# librarys
{ 
  # devtools::install_github("tchiluanda/rsiconfi")
  library(rsiconfi)
  library(dplyr)
  library(tidyr)
  library(devtools)
 }

# Vamos ver Despesas por Função (I-E)
# A função get_account_dca retorna os códigos possíveis
# Coloco o ano 2018, o I-E e um código relacionado com SP
# Aqui a lista de todos:
# https://siconfi.tesouro.gov.br/siconfi/pages/public/conteudo/conteudo.jsf?id=581 clique em Tabela dos códigos de instituição utilizados no Siconfi - Código das Instituições

df_conta_dca <- get_account_dca(2018, "I-E", c("35") )


## Captura gastos de SP com Saúde (11)
gasto_uf_sp_2019 <- get_dca(year = 2018,
                            annex = "I-E",
                            entity = "35", 
                            arg_cod_conta = "10")

# Os dados de 2019 ainda não estão na API


# Com um vetor dos anos posso baixar tudo e comparar depois
gasto_uf_sp <- get_dca(year = c(2013, 2014, 2015, 2016, 2017, 2018),
                       annex = "I-E",
                       entity = "35", 
                       arg_cod_conta = "10")




########### Trabalhando as despesas ############################################

#Monta um vetor com todos os códigos de UFs do Brasil
#Vide https://atendimento.tecnospeed.com.br/hc/pt-br/articles/360021494734-Tabela-de-C%C3%B3digo-de-UF-do-IBGE

todos_estados<-11 #para efeito de teste considera-se aqui apenas o estado de Rondônia
#todos_estados<-c(11:17,21:29,31:35,41:43,50:53) #para execução completa tire o comentário dessa linha


#Monta um vetor com as contas que se referem às despesas com a burocracia nos municípios
#para saber as contas disponíveis use a função get_account_dca, como indicado abaixo
# df_conta_dca<- get_account_dca(2018, "I-E", c("2312908") )

contas_depesas_burocaracia<- c("01", #Despesa com legislativo,
                               "04" #Despesa com administração do estado
)




#chama função que traz dados contábeis anuais de todos os municípios de um conjunto de estados
#Atenção, a execução da linha abaixo pode demorar várias horas para execução.
#Caso queira fazer somente um teste sugerimos substituir o vetor de estados.
#Considere usar apenas o estado 11-Rondônia para testes
df_desp_mun<- get_dca_mun_state(year= 2018, #ano a que se refere os dados. poderia ser um vetor de anos
                                annex= "I-E", #Anexo de Contas Anuais que se refere a despesa por função
                                state = todos_estados, #Informa o conjunto de UFs a que se refere os dados recuperados. nesse caso todos as UFs
                                arg_cod_conta = contas_depesas_burocaracia#Contas associadas a despesa com burocracia
)

#O vetor df_rec_mun apresenta várias linhas para o mesma chave composta de cod_ibge e conta.
#Deve-se escolher a fase da despesa para não haver distorção nos dados.
#Para esse caso vamos filtar as despesas liquidadas, presentes na variável coluna
#Aproveitamos para usar no dataset apenas as variáveis cod_ibge, conta e valor

df_desp_mun<- df_desp_mun %>%
  filter(coluna== "Despesas Liquidadas") %>%
  select(cod_ibge, conta, valor)

#Transpõe  a matriz de despesa para os tipos de despesa virarem coluna
df_desp_mun_tidy <- df_desp_mun %>%
  spread(conta,valor)

names(df_desp_mun_tidy)[2:3]<- c("desp_legislativa","desp_administracao")

###########Trabalhando as receitas

#Monta um vetor com as contas que se referem às receitas que são consideradas no cálculo
#para saber as contas disponíveis use a função get_account_dca, como indicado abaixo
# df_conta_dca<- get_account_dca(2018, "I-C", c("2312908") )

contas_receita<- c("1.0.0.0.00.0.0", #Receitas Correntes ,
                   "1.7.0.0.00.0.0", #Transferências correntes,
                   "RO1.7.2.8.01.1.0", #Cota-parte do ICMS,
                   "RO1.7.2.8.01.2.0", #Cota-parte do IPVA,
                   "RO1.7.1.8.01.5.0", #Cota-parte do ITR,
                   "1.7.2.8.01.3.0 Cota-Parte do IPI"#Cota-parte do IPI
)

df_rec_mun<- get_dca_mun_state(year= 2018, #ano a que se refere os dados. poderia ser um vetor de anos
                               annex= "I-C", #Anexo de Contas Anuais que se refere a receita orçamentária
                               state = todos_estados, #Informa o conjunto de UFs a que se refere os dados recuperados. nesse caso todas as UFs
                               arg_cod_conta = contas_receita#Contas associadas a receitas econômicas municipais
)


#para todas as receitas devem ser excluídas as deduções relativas a FUNDEB, transferências constitucionais e outras deduções da receita da receita bruta realizada.
#Para tanto, deve-se trabalhar com as informações que estão na variável "coluna"


df_rec_liq<- df_rec_mun %>%
  mutate(valor = ifelse(coluna== "Receitas Brutas Realizadas", valor, -valor)) %>% #Se não for Receita Bruta realizada, trata-se de dedução, o valor deve ser multipliado por -1
  group_by(cod_ibge, cod_conta) %>%
  summarise(
    valor_liquido = sum(valor)
  ) %>%
  spread(cod_conta, valor_liquido) %>%
  ungroup() %>%
  mutate(rec_econ = RO1.0.0.0.00.0.0 - RO1.7.0.0.00.0.0 + rowSums(.[4:7])) %>%
  select(1,2,8)


names(df_rec_liq)[2:3]<-c("receitas_correntes_liq", "receita_economica_mun")


####Trabalha em conjunto as informações de receita e despesa e calcula o índice FIRJAN de autonomia



df_resultado<-df_desp_mun_tidy %>%
  inner_join(df_rec_liq) %>%
  mutate(indicador = (receita_economica_mun-
                        desp_legislativa-
                        desp_administracao)/
           receitas_correntes_liq,
         IFGF_autonomia =  case_when(
           indicador > 0.25 ~ 1,
           indicador < 0.25 & indicador >0 ~ indicador/0.25,
           TRUE ~ 0))



# install.packages("basedosdados")
# install.packages("bigrquery")

library("basedosdados")

library("bigrquery")

# Defina o seu projeto no Google Cloud
set_billing_id("<projeto-inep-419700>") # definido no GCP carlos.nunes@iis.org.br

# Para carregar o dado direto no R
query <- bdplyr("br_inep_censo_escolar.dicionario")
df <- bd_collect(query)

rlang::last_trace()

# Defina o seu projeto no Google Cloud
set_billing_id("<Sidra_Crnunes>")

# Para carregar o dado direto no R
query <- bdplyr("br_ibge_censo_2022.area_territorial_densidade_demografica_municipio")
df <- bd_collect(query)


query <- bdplyr("br_ipea_avs.municipio")
df <- bd_collect(query)




#API do Siconfi pode ser acessado no seguinte link: https://apidatalake.tesouro.gov.br/docs/siconfi/. 

install.packages("siconfir")
library("tidyverse")
library("siconfir")



financial and budgetary reports for the city of Varginha. Here is a breakdown of each line of code:
  
siconfir::find_cod("Varginha")

Finds the code for the city of Varginha.
fiscal <- siconfir::get_fiscal(year = 2020, period = 3, cod = 3170701)

Fetches fiscal management report information for Varginha in the third period of the year 2020.
bdg <- siconfir::get_budget(year = 2020, period = 1, cod = 3170701)

Fetches budget execution information for Varginha in the first period of the year 2020.
acc <- siconfir::get_annual_acc(year = 2020, cod = 3170701)



base_url_rreo <- "apidatalake.tesouro.gov.br/ords/siconfi/tt/rreo?"


library(httr)
library(jsonlite)
library(stringr)
library(dplyr)
library(tidyr)


# parâmetros de consulata ao RREO
ano <- "2019"
bimestre <- "1"
tipo_relatorio <- "RREO"
num_anexo <- "RREO-Anexo+01"
ente <- "3304557" 

# montar a chamada à API
chamada_api_rreo <- paste(base_url_rreo,
                          "an_exercicio=", ano, "&",
                          "nr_periodo=", bimestre, "&",
                          "co_tipo_demonstrativo=", tipo_relatorio, "&",
                          "no_anexo=", num_anexo, "&",
                          "id_ente=", ente, sep = "")

rreo <- GET(chamada_api_rreo)







install.packages("remotes")
remotes::install_github("aspeddro/siconfir")

3Using
get_fiscal(): Fiscal management report
get_budget(): Budget execution summary report
get_annual_acc(): Annual statement of accounts
msc_budget(): Budget accounts, accounting balances matrix
msc_control(): Control accounts, accounting balances matrix
msc_equity(): Equity accounts, accounting balances matrix
report_status(): Report status
get_annex(): Attachments of reports by sphere of government
get_info(): Basic information of the federation entities
find_cod(): Find state or municipality information
