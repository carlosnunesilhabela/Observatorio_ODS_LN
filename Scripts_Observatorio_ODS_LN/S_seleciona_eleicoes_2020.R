### SCRIPT: Ler e selecionar dados das eleições 2020 

eleicoes_2020 <- read.csv(file = "votacao_secao_2020_SP.csv", sep = ";", header = T, encoding = "latin1")

eleicoes_ilhabela <- filter(eleicoes_2020, NR_ZONA == "132")
eleicoes_ilhabela <- filter(eleicoes_ilhabela ,  NM_MUNICIPIO == "ILHABELA")
 
head (eleicoes_ilhabela)

write_xlsx(eleicoes_ilhabela, "Eleicoes_Ilhabela_2020.xlsx") #grava data frame em formato *.xlsx
  

