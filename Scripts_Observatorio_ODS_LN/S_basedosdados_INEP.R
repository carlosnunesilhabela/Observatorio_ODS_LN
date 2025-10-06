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
Using
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
