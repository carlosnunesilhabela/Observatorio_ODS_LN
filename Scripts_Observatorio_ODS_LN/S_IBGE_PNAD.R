
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

{ # PNADcIBGE
install.packages("PNADcIBGE")
library(PNADcIBGE)
help("get_pnadc")
dadosPNADc <- get_pnadc(year=2023, quarter=4)
dadosPNADc <- get_pnadc(year=2017, quarter=4, vars=c("VD4001","VD4002"))
# Por exemplo, um usuário que deseje trabalhar apenas com as variáveis de Condição em relação à força de trabalho (VD4001) e Condição de ocupação (VD4002) do 4º trimestre de 2017, pode utilizar o argumento vars para selecionar apenas estas variáveis:
  
#Variável  Descrição
#UF	        Unidade da Federação
#V2001	    Número de pessoas no domicílio
#V2005	    Condição no domicílio
#V2007	    Sexo
#V2009	    Idade do morador na data de referência
#V2010	    Cor ou raça
#V3007	    Já concluiu algum outro curso de graduação?
#VD3004	    Nível de instrução mais elevado alcançado (pessoas de 5 anos ou mais de idade)
#VD4001	    Condição em relação à força de trabalho na semana de referência para pessoas de 14 anos ou mais de idade
#VD4002	    Condição de ocupação na semana de referência para pessoas de 14 anos ou mais de idade
#VD4020	    Rendimento mensal efetivo de todos os trabalhos para pessoas de 14 anos ou mais de idade (apenas para pessoas que receberam em dinheiro, produtos ou mercadorias em qualquer trabalho)
#VD4035	    Horas efetivamente trabalhadas na semana de referência em todos os trabalhos para pessoas de 14 anos ou mais de idade

# dadosPNADc <- pnadc_labeller(data_pnadc=dadosPNADc, dictionary.file="dicionario_PNADC_microdados_trimestral.xlsx")
pnad <- as.tibble (dadosPNADc$variables) 
pnad2 <- dplyr::filter(pnad, Estrato == "3520400") #3520400 - Ilhabela

pnad_sum <- pnad %>% group_by(Ano) %>%  
  summarise(quantidade = n())
}  # PNADcIBGE


# get_sidra          It recovers data from the given table according to the parameters
# info_sidra         It allows you to check what parameters are available for a table via an web browser
# search_sidra       It searches which tables have a particular 

tabela = get_sidra(api='/t/6381/n1/all/v/4099/p/all/d/v4099%201') #tx de ocupação

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




gini <- get_sidra(x = 5939,
         variable = 529,
      # period = "2014",
       #  geo = "State",
       #  geo = "City",
         header = TRUE,
         format = 1)

# IPCA tem até 2019
ipca <- get_sidra(x = 1419,
          variable = 63,
          period = c("last" = 12),
          geo = "City",
          geo.filter = 5002407,
          classific = "c315",
          category = list(7169),
          header = FALSE,
          format = 3)

pnadcm <- get_sidra(x = 4095,
                  # variable = 529,
                  # period = "2014",
                  #  geo = "State",
                  #  geo = "City",
                  header = TRUE,
                  format = 1)

Tabelas_sidra <- search_sidra("população")

pop <- get_sidra(x = 166,  #população
                    # variable = 529,
                    # period = "2014",
                    #  geo = "State",
                    #  geo = "City",
                    header = TRUE,
                    format = 1)

