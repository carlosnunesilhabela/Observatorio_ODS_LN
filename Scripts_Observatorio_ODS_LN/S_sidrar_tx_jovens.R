
install.packages("sidrar")
install.packages("zoo")

library(tidyverse)
library(sidrar)
library(dplyr)
library(gt)
library(glue)
library(sf)
library(geobr)
library(ggplot2)
library(scales)
library(dynlm)
library(zoo)

# Pesquisa tabelas com palavras (contem)
{
  ta_no_sidra <- search_sidra("saneamento") #lista tabelas relacionadas a Saneamento  
ta_no_sidra <- as.tibble(ta_no_sidra) # transforma o resultado em um tibble
writexl::write_xlsx(ta_no_sidra, "tabelas_SIDRA4.xlsx")  
}

# get_sidra    It recovers data from the given table according to the parameters
{
  regiao <- c(1,3)
tabela <- data.frame()

tabela_baixada <- get_sidra(x = 1315, # código da tabela no Sidra
                  period = "last",    #period = as.character(2020) # ano dos dados
                  geo = 'City',          
                      # "Brazil", "Region", "State", "MesoRegion", "MicroRegion", 
                      # "MetroRegion", "MetroRegionDiv", "IRD", "UrbAglo", "City", 
                      # "District","subdistrict","Neighborhood","PopArrang". 
                  geo.filter = "3520400" # list("Region" = i), #região
                 # variable = 215, # variável de interesse
                
  )
}


# dados nominais (por idade até censo de 2022)
# consultar o link API em https://sidra.ibge.gov.br PESQUISA tabela 2609 NASCIDOS Vivos 
censo_n = get_sidra(api="/t/2609/n1103/all/n6/all/v/allxp/p/last%201/c232/58297,71500/c240/0/c2/0")


# selecao de variaveis

censo_n_selecao = censo_n %>%
  select("brasil_uf" = `Brasil e Unidade da Federação`,
         "brasil_uf_code" = `Brasil e Unidade da Federação (Código)`,
         "sexo" = Sexo, 
         "idade" = Idade, 
         "qtd" = Valor,
         "ano" = Ano)

# subset 1 - apenas brasil
censo_brasil_jovem = censo_n_selecao %>%
  filter(brasil_uf == "Brasil")

# subset 2 - apenas jovens
censo_uf_jovem = censo_n_selecao %>%
  filter(brasil_uf != "Brasil") 

piramide_etaria = censo_brasil_jovem %>%
  group_by(ano,idade) %>%
  summarise(qtd = sum(qtd))

ggplot(piramide_etaria, aes(x = idade, y =  qtd)) +
  geom_bar(stat = "identity", fill = "#6d89f8") +
  facet_wrap(~ano, ncol = 1) +
  theme_classic() +
  theme(legend.position = "right",
        legend.title = element_blank())+
  # scale_y_continuous(labels = abs, limits = c(-1, 1) * max(censo_brasil_jovem$qtd)) +
  labs(title = "Pirâmide etária brasileira (15 - 29 anos)",
       subtitle = "Censo IBGE",
       y = "", x = "") +
  theme(plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(face = "italic"),
        plot.caption = element_text(face = "italic", hjust = 0),
        axis.text.x = element_blank())+
  geom_label(aes(label = sprintf("%.1fM", qtd / 1000000)),color = "black", size=2., show.legend = FALSE) +
  scale_fill_brewer(palette = "Set1") +
  coord_flip()

# coleta da geolocalização
br_map_estado <- read_municipality(code_muni = "all", year = 2020, showProgress = F)

# transformar em caracter
br_map_estado$code_state = as.character(br_map_estado$code_state)


