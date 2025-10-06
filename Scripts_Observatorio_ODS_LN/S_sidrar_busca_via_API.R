{
# get_sidra          It recovers data from the given table according to the parameters
# info_sidra         It allows you to check what parameters are available for a table via an web browser
# search_sidra       It searches which tables have a particular 
  } # Consulta IBGE utilizando o pacote sidrar

# librarys
{
#  install.packages("zoo") # são varios pacoes juntos -z series e time series
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
}

#Busca PIBM 
{
# https://apisidra.ibge.gov.br/values/t/5938/n1/all/n6/all/v/37/p/last%201/d/v37%200
pibm = get_sidra(api='/t/5938/n1/all/n6/all/v/37/p/last%201/d/v37%200') # PIB-M
}

# taxa de ocupação
{
tx_ocup = get_sidra(api='/t/6381/n1/all/v/4099/p/all/d/v4099%201') #tx de ocupação


times = seq(as.Date('2016-01-01'), as.Date('2017-08-01'),  #Ajustar
            by='month')

desemprego = data.frame(time=times, desemprego=tail(tabela$Valor, 20))  

ggplot(desemprego, aes(x=time, y=desemprego))+
  geom_line(size=.8, colour='darkblue')+
  scale_x_date(breaks = date_breaks("1 months"),
               labels = date_format("%b/%Y"))+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  geom_point(size=9, shape=21, colour="#1a476f", fill="white")+
  geom_text(aes(label=round(desemprego,1)), size=3, 
            hjust=0.5, vjust=0.5, shape=21, colour="#1a476f")+
  xlab('')+ylab('%')+
  labs(title='Taxa de Desocupação PNAD Contínua',
       subtitle='População desocupada em relação à PEA',
       caption='Fonte: analisemacro.com.br com dados do IBGE.')
}

# Indice Gini Brasil
{
gini <- get_sidra(x = 5939,
         variable = 529,
      # period = "2014",
       #  geo = "State",
       #  geo = "City",  (Gini não disponivel por municipio)
         header = TRUE,
         format = 1)
}

# IPCA tem até 2019
{
ipca <- get_sidra(x = 1419,
          variable = 63,
          period = c("last" = 12),
          geo = "City",
          geo.filter = 5002407,
          classific = "c315",
          category = list(7169),
          header = FALSE,
          format = 3)
}

# PNAD 
{
  pnadcm <- get_sidra(x = 4095,
                  # variable = 529,
                  period = "202304",
                  #  geo = "State",
                  geo = "City",
                  header = TRUE,
                  format = 1)
}

# População por cidade (sidrar)
{
Tabelas_sidra <- search_sidra("população")

pop <- get_sidra(x = 166,  #população
                    variable = 529,
                    # period = "2014",
                    #  geo = "State",
                    geo = "City",
                    header = TRUE,
                    format = 1)
}

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

# PESQUISA tabela 2609 NASCIDOS Vivos
{
# consultar o link API em https://sidra.ibge.gov.br  
censo_n = get_sidra(api="/t/2609/n1103/all/n6/all/v/allxp/p/last%201/c232/58297,71500/c240/0/c2/0")
}

# exemplos de selecao de variaveis após download
{
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
}

# coleta da geolocalização
{
br_map_estado <- read_municipality(code_muni = "all", year = 2020, showProgress = F)

# transformar em caracter
br_map_estado$code_state = as.character(br_map_estado$code_state)
}

