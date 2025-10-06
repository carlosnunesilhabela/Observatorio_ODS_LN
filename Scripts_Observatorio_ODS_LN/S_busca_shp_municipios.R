# SCRIPT: Obter SHP dos municipios

configs()

load_packages()

shp_mun_rmvale <- rgdal::readOGR(dsn = "shp_mun_rmvale", layer = "shp_mun_rmvale",    
                                 encoding = "utf-8") # ou "'ISO-8859-1")
lista_mun_minusculas <- shp_mun_rmvale@data$NM_MU  # [31]


#shp_mundo <- rgdal::readOGR(dsn = "Mapa_mundi_kml", layer = "mundo",    
#                                 encoding = "utf-8") # ou "'ISO-8859-1")
#lista_paises <- shp_mundo$data
