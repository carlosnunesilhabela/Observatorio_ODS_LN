# Acessa SNIS

install.packages("basedosdados")
library("basedosdados")

# Defina o seu projeto no Google Cloud
set_billing_id("obs-ln")

# Para carregar o dado direto no R
query <- bdplyr("br_mdr_snis.municipio_agua_esgoto")

df <- bd_collect(query_snis)

# write.xlsx(df_ln, "dados_banda_larga_ln.xlsx") #grava data frame em formato *.xlsx


