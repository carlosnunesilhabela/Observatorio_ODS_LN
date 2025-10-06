########### Script para baixar dados de Saúde ########################
# Instala pacotes
{
configs()
load_packages()
 
install.packages("xml")
install.packages("xml2")

devtools::install_github('https://github.com/joaohmorais/rtabnetsp', force=TRUE)
library(rtabnetsp)  # Manual: http://scielo.iec.gov.br/scielo.php?script=sci_arttext&pid=S1679-49742021000100085

# https://github.com/abraji/APIs/blob/master/rsiconfi/gastos_estaduais_SP_com_saude_2018.R
}


indicator_list(url= 'http://portal.saude.sp.gov.br/links/matriz')   # retrieve a list of available indicators
indicator_search('dengue', url = 'http://portal.saude.sp.gov.br/links/matriz') # search for indicators containing "dengue" in its name

ds <- fetch_all(region = 'Município', url = 'http://portal.saude.sp.gov.br/links/matriz', timeout = 1)

ds <- filter(ds, 
        # Município == 'Bertioga'           |
          Município == 'Aparecida'          |
          Município == 'Arapeí'             |
          Município == 'Areias'             |
          Município == 'Bananal'            |
          Município == 'Caçapava'           |
          Município == 'Cachoeira Paulista' |
          Município == 'Campos do Jordão'   |
          Município == 'Canas'              |
          Município == 'Caraguatatuba'      | 
          Município == 'Cruzeiro'           |
          Município == 'Cunha'              |
          Município == 'Guaratinguetá'      | 
          Município == 'Igaratá'            |
          Município == 'Ilhabela'           |
          Município == 'Jacareí'            |
          Município == 'Jambeiro'           |
          Município == 'Lagoinha'           |
          Município == 'Lavrinhas'          |
          Município == 'Lorena'             |
          Município == 'Monteiro Lobato'    | 
          Município == 'Natividade da Serra'|
          Município == 'Paraibuna'          |
          Município == 'Pindamonhangaba'    | 
          Município == 'Piquete'            |
          Município == 'Potim'              |
          Município == 'Queluz'             |
          Município == 'Redenção da Serra'  |
          Município == 'Roseira'            |
          Município == 'Santa Branca'       |
          Município == 'Santo Antônio do Pinhal'|
          Município == 'São Bento do Sapucaí'   |
          Município == 'São José do Barreiro'   |
          Município == 'São José dos Campos'    |
          Município == 'São Luís do Paraitinga' |
          Município == 'São Sebastião'          | 
          Município == 'Silveiras'              |
          Município == 'Taubaté'                |
          Município == 'Tremembé'               |
          Município == 'Ubatuba'                )


ds <- filter(ds, Ano == '2023')

leitos = "Leitos.SUS.por.1.000(mil).habitantes.na.populacao.SUS.dependente_Leitos.SUS"
uti = "Percentual.de.Leitos.SUS.de.UTI.(Adulto,.Infantil.e.Neonatal)_Perc.Leitos.UTI.(%)"

ds1 <-  filter(ds, Indicador == leitos)
ds2 <-  filter(ds, Indicador == uti)

ds3_df <- shp_municipiossc_df %>% 
  sparklyr::left_join(dados_sc, by = "CD_GEOCMU")
writexl::write_xlsx(ds2, "Dados_saude_leitos.xlsx") #grava data frame em formato *.xlsx

# save(ds, file = "Dados_saude_sp.Rdata") # Salva em formato RData

url <- "C:/Users/carlo/Desktop/Observatório dos ODS/Saúde/Indicadores_saude_tabnet.xlsx"
writexl::write_xlsx(ds,url)

