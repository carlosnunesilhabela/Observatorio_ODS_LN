configs()

{
# load_packages()

install.packages("pdftools")
install.packages("tabulapdf", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
install.packages("extractr", repos =("https://github.com/sckott/extractr"))
install.packages("tabulizer")

library(tidyverse)  #pacote para manipulacao de dados
library(readxl)
library(ggplot2)
library(stringr)
library(dplyr)
library(sparklyr)
library(writexl)
library(readxl)
library(stringi)

# library(extractr) # não encontrado
library(pdftools)
library(tabulapdf)
library(tabulizer)

} # Carrega pacotes

munprio <- read_xlsx("lista_municipios_prioritarios_1972.xlsx")

txt <-      pdf_text("lista_municipios_prioritarios_1972.xlsx")

f <- system.file("examples", "1403.2805.pdf", package = "tabulapdf")

out <- extract_tables(f)
out[[1]]

# consegui abrir PDF no google docs
xpdf <- extract("lista_municipios_prioritarios_1972.xlsx", "xpdf")


url <- 'http://www2.alerj.rj.gov.br/leideacesso/spic/arquivo/folha-de-pagamento-2018-01.pdf'

d <- extract_tables(url, encoding = "UTF-8", pages = 1)


