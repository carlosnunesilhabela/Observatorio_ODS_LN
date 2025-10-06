########### Script teste grafico de barras sobre o mapa ########################

configs()
load_packages()

# Caso o objeto 3d não seja renderizado (mostrando uma figura preta),
# será necessário remover alguns pacotes e instalar a versão diretamente do github: 
# remove.packages('rgl')
# remove.packages('rayshader')

# install_github('tylermorganwall/rayshader')



shp_rmvale <- st_read(dsn = "C:/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace/shp_mun_rmvale/", 
                            layer = "shp_mun_rmvale")  # le apenas a base de dados

Municipios_RMVale <- read_xlsx("Tabelas/Municipios_RMVale.xlsx"); 


mn_poligonos <- readOGR(dsn = "C:/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace/shp_mun_rmvale/", 
                              layer = "shp_mun_rmvale",
                              verbose=FALSE, 
                              stringsAsFactors=FALSE);

save(mn_poligonos, file = "poligonos_mn_rmvale.Rdata") # Salva em formato RData (apenas geometry)

mn_poligonos_kml <- readOGR("RMVale.kml",     # (Não funcionou)
                            layer = "RMVale",
                            verbose=FALSE, 
                            stringsAsFactors=FALSE);

colnames(mn_poligonos@data)[1] ="CD_MU_IBGE"

colnames(mn_poligonos@data)[2] ="NM_MUN"

mn_poligonos2@data[1:66] <- NULL  # só geometria
save(mn_poligonos2, file = "poligonos_mn_rmvale(sogeometria).Rdata") # Salva em formato RData (apenas geometry)


mn_poligonos@data <- Municipios_RMVale

plot(mn_poligonos)

df_final <- list(x, y, z) 

head(mn_poligonos@data$CD_MU)
     
mn_poligonos@data$AREA_ <- NULL


mn_poligonos@data <- mn_poligonos@data[,-c(3,4,5,6)]

mn_poligonos@data

rm ("mn_poligonos")

write_xlsx(shp_rmvale, "dados_tcc_dsa_rmvale.xlsx") #grava data frame em formato *.xlsx


head(mn_poligonos@data$CD_MU_IBGE)

mn_poligonos@data %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = TRUE, 
                font_size = 12)

tm_shape(shp = mn_poligonos) + 
  tm_borders()

tmap_mode("plot")
tm_shape(shp = mn_poligonos) + 
  tm_borders() +
  tm_text(text = "NM_MUN", size = 0.4)

writeOGR(mn_poligonos, "shp_rmvale_dataframe", layer="rmvale", driver="ESRI Shapefile")

