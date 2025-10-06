install.packages("basedosdados")
library("basedosdados")
library(dplyr)
configs()
load_packages()

# Defina o seu projeto no Google Cloud
set_billing_id("<Sidra_Crnunes>")

# Para carregar o dado direto no R
query <- bdplyr("br_me_siconfi.municipio_receitas_orcamentarias")
df <- bd_collect(query)


rlang::last_trace()


# Para carregar o dado direto no R
query <- bdplyr("br_ibge_censo_2022.area_territorial_densidade_demografica_municipio")
df <- bd_collect(query)


