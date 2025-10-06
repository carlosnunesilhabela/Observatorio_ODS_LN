install.packages("pdftools")
install.packages("tesseract")
install.packages("extractr")
install.packages("tabulizer", dependencies = TRUE)

library(tesseract)

eng <- tesseract("eng")

text <- tesseract::ocr("http://jeroen.github.io/images/testocr.png", engine = eng)
cat(text)

library(extractr)
xpdf <- extract("Desktop/rio-grande-da-serra-LEI-2306.pdf", "xpdf")


> lito <- str_locate(xpdf$data, "Litológicos") #procura o fim de litologicos
> hidro <- str_locate(xpdf$data, "Hidrogeológicos") # procura o início de hidrogeologicos
> dados <- str_sub(xpdf$data, start = lito[2] + 4, end = hidro[1]- 5)
> dados
[1] "De (m):, , Até (m):, , Litologia:, , Descrição Litológica:, , 0, , 3, , Arenito

library(tidyverse)
library(stringr)
library(pdftools)
pdf <- '../../static/data/ocr/pdf_digital.pdf'
txt <- pdf_text(pdf)
