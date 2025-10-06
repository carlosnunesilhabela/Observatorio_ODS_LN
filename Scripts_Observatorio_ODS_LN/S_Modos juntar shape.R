configs()

#Carrega pacotes 

  load_packages()
  
  library("rgdal")
  library("plotly")
  library("tidyverse")
  library("knitr")
  library("kableExtra")
  library("gridExtra")
  library("png")
  library("grid")
  library("magick")
  library("rgl")
  library("devtools")
  # library("GISTools")
  library("rayshader")
  library("tmap")
  library("broom")
  library(ggplot2)
  library(stringr)
  library(dplyr)
  library(sparklyr)
  
  library(writexl)
  library(readxl)


# Carregando um shapefile dos municipios - fonte IBGE 

shp_municipios_br <- readOGR(dsn = "BR_Municipios_2022",
                            layer = "BR_Municipios_2022")

# Conferindo / Explorando a base de dados do shapefile 
summary(shp_municipios_br)
shp_municipios_br@data %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = TRUE, 
                font_size = 12)

# Para acessar as variáveis da base de dados atrelada ao shapefile, utilizaremos
# o operador $:
shp_municipios_br$CD_MUN
shp_municipios_br$CD_GEOCMU
shp_municipios_br@polygons #Posições geográficas dos polígonos
shp_municipios_br@plotOrder #Ordem de plotagem dos polígonos
shp_municipios_br@bbox #Eixo X (Longitude Oeste e Leste; Latitude Norte e Sul)
shp_municipios_br@proj4string@projargs #Sistema de projeção geográfica do shapefile

plot(shp_municipios_br)

# Quando há uma grande quantidade de polígonos, é melhor a utilização conjunta das
# funcionalidades do pacote plotly e ggplot2:

#Juntar Dados no Shape File

# Passo 1: Transformando o objeto shp_sc num data frame:
shp_municipios_df <- tidy(shp_municipios_br, region = "CD_MUN") %>% 
  rename(CD_MUN = id)

ABT <- read_xlsx("ABT_MDR_PNUD.xlsx") # Carregar a ABT
# save ("ABT", file="ABT_MDR_PNUD.RData")
# load("ABT_MDR_PNUD.RData")

shp_dados_municipios <- merge(x = shp_municipios_df,
                              y = ABT,
                              by.x = "CD_MUN",
                              by.y = "CD_MUN")



  # Passo 2: Juntando as informações da base de dados 
shp_municipios_df <- shp_municipiossc_df %>% 
  sparklyr::left_join(dados_sc, by = "CD_GEOCMU")

# Passo 3: Gerando um mapa no ggplot2
shp_sc_df %>%
  ggplot(aes(x = long,
           y = lat, 
           group = group, 
           fill = poverty)) +
  geom_polygon() +
  scale_fill_gradient(limits = range(shp_sc_df$poverty),
                      low = "#FFF3B0", 
                      high="#E09F3E") +
  layer(geom = "path", 
        stat = "identity", 
        position = "identity",
        mapping = aes(x = long, 
                      y = lat, 
                      group = group, 
                      color = I('#FFFFFF'))) +
  theme(legend.position = "none", 
        axis.line = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.ticks = element_blank(), 
        panel.background = element_blank())

# Passo 4: Salvando o mapa gerado no Passo 3 num objeto:
mapa_sc <- shp_sc_df %>%
  ggplot(aes(x = long,
             y = lat, 
             group = group, 
             fill = poverty)) +
  geom_polygon() +
  scale_fill_gradient(limits = range(shp_sc_df$poverty),
                      low = "#FFF3B0", 
                      high="#E09F3E") +
  layer(geom = "path", 
        stat = "identity", 
        position = "identity",
        mapping = aes(x = long, 
                      y = lat, 
                      group = group, 
                      color = I('#FFFFFF'))) +
  theme(legend.position = "none", 
        axis.line = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.ticks = element_blank(), 
        panel.background = element_blank())

# Passo 5: Salvando o objeto mapa_sc como um arquivo de extensão *.png, com uma
# boa resolução:
xlim <- ggplot_build(mapa_sc)$layout$panel_scales_x[[1]]$range$range  #estabelecendo um bounding box 
ylim <- ggplot_build(mapa_sc)$layout$panel_scales_y[[1]]$range$range

ggsave(filename = "mapa_co_dsa.png",   #grava um png em meu diretório
       width = diff(xlim) * 4, 
       height = diff(ylim) * 4, 
       units = "cm")

# Passo 6: Carregando o arquivo mapa_co_dsa.png:
background_mapa <- readPNG("mapa_co_dsa.png")

# Passo 7: Capturando as coordenadas dos centroides de cada município de SC num 
# data frame:
coordinates(shp_sc) %>% 
  data.frame() %>% 
  rename(longitude = 1,
         latitude = 2) %>% 
  mutate(CD_GEOCMU = shp_sc@data$CD_GEOCMU) %>% 
  dplyr::select(latitude, everything()) -> coords_sc

# Passo 8: Adicionando as coordenadas dos municípios do Centro-Oeste no objeto
# map_data_centro_oeste
shp_sc_df <- shp_sc_df %>% 
  left_join(coords_sc, by = "CD_GEOCMU")

# Passo 9: Georreferenciando a imagem PNG e plotando marcações sobre a pobreza 
# em SC nos centroides de cada polígono  (na realidade é um grafico scattter)
shp_sc_df %>%
  ggplot() + 
  annotation_custom(
    rasterGrob(background_mapa, 
               width=unit(1,"npc"),
               height=unit(1,"npc")),-Inf, Inf, -Inf, Inf) + 
  xlim(xlim[1],xlim[2]) + # x-axis Mapping
  ylim(ylim[1],ylim[2]) + # y-axis Mapping
  geom_point(aes(x = longitude, y = latitude, color = poverty), size = 1.5) + 
  scale_colour_gradient(name = "Poverty", 
                        limits = range(shp_sc_df$poverty), 
                        low = "#FCB9B2", 
                        high = "#B23A48") + 
  theme(axis.line = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.ticks = element_blank(), 
        panel.background = element_blank())

# Passo 10: Salvando o resultado do Passo 9 num objeto
mapa_pobreza <- shp_sc_df %>%
  ggplot() + 
  annotation_custom(
    rasterGrob(background_mapa, 
               width=unit(1,"npc"),
               height=unit(1,"npc")),-Inf, Inf, -Inf, Inf) + 
  xlim(xlim[1],xlim[2]) + # x-axis Mapping
  ylim(ylim[1],ylim[2]) + # y-axis Mapping
  geom_point(aes(x = longitude, y = latitude, color = poverty), size = 1.5) + 
  scale_colour_gradient(name = "Poverty", 
                        limits = range(shp_sc_df$poverty), 
                        low = "#FCB9B2", 
                        high = "#B23A48") + 
  theme(axis.line = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.ticks = element_blank(), 
        panel.background = element_blank())

# Passo 11: Gerando o mapa 3D da pobreza em SC (não feche a janela pop-up que
# foi aberta até completar esse script até o final) - #3D estamos criando um eixo Z 
# cria uma janela separada
rayshader::plot_gg(ggobj = mapa_pobreza, 
        width = 11, 
        height = 6, 
        scale = 300, 
        multicore = TRUE, 
        windowsize = c(1000, 800))

# Passo 12: Melhorando o resultado do Passo 11:
render_camera(fov = 70, 
              zoom = 0.5, 
              theta = 130, 
              phi = 35)

# Opções de salvamento em vídeo do mapa gerado nos Passos 11 e 12:
azimute_metade <- 30 + 60 * 1/(1 + exp(seq(-7, 20, length.out = 180)/2))
azimute_completo <- c(azimute_metade, rev(azimute_metade))

rotacao <- 0 + 45 * sin(seq(0, 359, length.out = 360) * pi/180)

zoom_metade <- 0.45 + 0.2 * 1/(1 + exp(seq(-5, 20, length.out = 180)))
zoom_completo <- c(zoom_metade, rev(zoom_metade))

render_movie(filename = "resutado1_sc",  #renderiza como video
             type = "custom", 
             frames = 360, 
             phi = azimute_completo, 
             zoom = zoom_completo, 
             theta = rotacao)

# Carregando os dados de alguns terremotos na Oceania: (nativo do pacote GISTools)
data(quakes)

# Observando os dados do objeto quakes:
quakes %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = TRUE, 
                font_size = 12)

# Aplicando a função class():
class(quakes)

# Transformando o data frame quakes num objeto sf:
sf_terremotos <- sf::st_as_sf(x = quakes, 
                          coords = c("long", "lat"), 
                          crs = 4326)
class(sf_terremotos)
# Observando os dados do objeto sf_terremotos:
sf_terremotos %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = TRUE, 
                font_size = 12)

# Visualizando o objeto sf_terremotos de forma espacial:
tm_shape(sf_terremotos) +
  tm_dots(size = 0.5, alpha = 0.3)

# Gerando gráficos estratificados pela profundidade do terremoto - 
# estratificação por tamanho:
tm_shape(shp = sf_terremotos) +
  tm_bubbles(size = "depth", 
             scale = 1, 
             shape = 19, 
             alpha = 0.3,
             title.size = "Profundidade dos Terremotos") +
  tm_compass() +
  tm_layout(legend.outside = TRUE,
            legend.text.size = 3)

# Gerando gráficos estratificados pela profundidade do terremoto - 
# estratificação por cor:
tm_shape(shp = sf_terremotos) +
  tm_dots(col = "depth", 
          shape = 19, 
          alpha = 0.5, 
          size = 0.6, 
          palette = "viridis", 
          title = "Profundidade dos Terremotos") +
  tm_compass() +
  tm_layout(legend.outside = TRUE,
            legend.text.size = 3)

# Como gerar plotar dois gráficos na aba Plots, simultaneamente, com o tmap:
grid.newpage()   #cuidado para não comandar esse comando mais que uma vez

# Passo 1: Salvar em um objeto o primeiro gráfico de interesse:
plot_01 <- tm_shape(shp = sf_terremotos) +
  tm_bubbles(size = "depth", 
             scale = 1, 
             shape = 19, 
             alpha = 0.3,
             title.size = "Profundidade dos Terremotos") +
  tm_compass() +
  tm_layout(legend.outside = TRUE)

# Passo 2: Salvar em um objeto o segundo gráfico de interesse:
plot_02 <- tm_shape(shp = sf_terremotos) +
  tm_dots(col = "depth", 
          shape = 19, 
          alpha = 0.5, 
          size = 0.6, 
          palette = "viridis", 
          title = "Profundidade dos Terremotos") +
  tm_compass() +
  tm_layout(legend.outside = TRUE)

# Passo 3: Preparar o ambiente gráfico do R para receber gráficos de forma
# simultânea:
pushViewport(
  viewport(
    layout = grid.layout(1,2)
  )
)

# Passo 4: Executar as plotagens
print(plot_01, vp = viewport(layout.pos.col = 1, height = 5))
print(plot_02, vp = viewport(layout.pos.col = 2, height = 5))

# Estabelecendo cutoffs
tmap_mode("view")

sf_terremotos %>% 
  filter(mag >= 6) %>% 
  tm_shape() +
  tm_dots(col = "depth", 
          shape = 19, 
          alpha = 0.5, 
          size = 0.2, 
          #palette = "-plasma", 
          title = "Profundidade dos Terremotos")

# Fim ---------------------------------------------------------------------
