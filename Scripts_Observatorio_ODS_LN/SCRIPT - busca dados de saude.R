########### Script para baixar dados de Saúde ########################

configs()
load_packages()

devtools::install_github('https://github.com/joaohmorais/rtabnetsp', force=TRUE)

library(rtabnetsp)  # Manual: http://scielo.iec.gov.br/scielo.php?script=sci_arttext&pid=S1679-49742021000100085

indicator_list(url= 'http://portal.saude.sp.gov.br/links/matriz')   # retrieve a list of available indicators
indicator_search('dengue', url = 'http://portal.saude.sp.gov.br/links/matriz') # search for indicators containing "dengue" in its name
view_indicator(indicator_index, url = 'http://portal.saude.sp.gov.br/links/matriz', timeout = 1)

data_sus <- indicator_df(
  indicator_index = 12, # retrieve data from indicator with ID 12 
  region = "Município", # in municipality aggregation level
  subindicator = NULL, # if not specified, the last subindicator will be retrieved
  years = c(2017, 2018, 2019, 2020, 2021) # desired time period
)

ds <- fetch_all(region = 'Município', url = 'http://portal.saude.sp.gov.br/links/matriz', timeout = 1)

ds <- filter(ds, Município == 'Ilhabela'      |
                 Município == 'Caraguatatuba' | 
                 Município == 'São Sebastião' |
                 Município == 'Ubatuba' )


tabnet_map2(
  indicator_index = 12, # data from indicator with ID 12 will be represented in the map
  region = "Município", # in municipality aggregation level
  subindicator = NULL, # if not specified, the last subindicator will be retrieved
  years = 2018, # desired time period
  palette = "Purples" # RColorBrewer palette
)

write_xlsx(ds, "Dados_saude_sp.xlsx") #grava data frame em formato *.xlsx

# save(ds, file = "DDados_saude_sp.Rdata") # Salva em formato RData
