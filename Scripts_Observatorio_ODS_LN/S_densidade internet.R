# Densidade de acessos à internet
# Percentual de pontos de acesso à internet banda larga fixa em relação ao número de domicílios

install.packages("basedosdados")
install.packages("xlsx")
library("basedosdados")
library("xlsx")

# Defina o seu projeto no Google Cloud
set_billing_id("obs-ln")

# Para carregar o dado direto no R
query <- bdplyr("br_anatel_banda_larga_fixa.densidade_municipio")
df <- bd_collect(query)

df_sp <- filter(df, sigla_uf == 'SP')

df_ln <- filter(df_sp, id_municipio == '3520400'      | # Ilhabela 
                    id_municipio == '3510500'         | # Caraguatatuba
                    id_municipio == '3550704'         | # São Sebastião
                    id_municipio == '3549904'         | # São José dos Campos
                    id_municipio == '3555406'         ) # Ubatuba

write.xlsx(df_ln, "dados_banda_larga_ln.xlsx") #grava data frame em formato *.xlsx

getwd()
remove(df_sp)

