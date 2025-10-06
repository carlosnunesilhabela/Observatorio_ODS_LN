######## Busca dados / mapas do IBGE #######################################

br          = read_country(year = 2018)
estados     = read_state(code_state = 'all')
ba          = read_state(code_state = 'BA')
municipios  = read_municipality() 
biomas      = read_biomes()
areas_risco = read_disaster_risk_area()

muni <- read_sf('C:/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace/shp_mun_rmvale/SP_Municipios_2020.shp')

regiao  = read_region()

norte    = filter(estados, name_region == 'Norte' )
muni_sp  = filter(municipios, code_state == '35')
teresopolis = filter(areas_risco, name_muni == 'Teresopolis')

lookup_muni(name_muni = "Ilhabela")
  
plot (muni_sp$geom)

plot (muni$geometry) 

plot (areas_risco)

ggplot() + geom_sf(data = br,lwd=4) + geom_sf(data = sul, fill='yellow')  


uc <- read_conservation_units()

uc1 <- subset(uc, uc$code_conservation_unit==3138) 

map <- leaflet(uc1) %>% addTiles()

map  %>% addPolygons()

shape <- st_write(uc1, "parque.shp")
             
kml <- st_write(uc1, "parque.kml")

