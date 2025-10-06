configs()
library(stringr)

# Baixar empresas (nao funcionou)
{
url_baixar <- "https://aplicacoes.mds.gov.br/sagi/servicos/misocial/?fl=codigo_ibge%2Canomes_s%20qtd_pes_pob:cadun_qtd_pessoas_cadastradas_pobreza_pbf_i%20qtd_pes_baixa_renda:cadun_qtd_pessoas_cadastradas_baixa_renda_i%20qtd_pes_acima_meio_sm:cadun_qtd_pessoas_cadastradas_rfpc_acima_meio_sm_i&fq=cadun_qtd_pessoas_cadastradas_baixa_renda_i%3A*&q=*%3A*&rows=100000&sort=anomes_s%20desc%2C%20codigo_ibge%20asc&wt=csv&fq=anomes:%5b202303%20TO%20202312%5d"

download.file(url_baixar, "cadunico.xlsx")   

"C:\Users\carlo\Desktop\Incritos no CadUnico.xlsx"
}
a <- 2
cadunico$codigo_ibge[1]

colnames(cadunico)[1] <- "CD_MUN"
cadunico2 <- cadunico[,-7] #exceto coluna
cadunico3  <- cadunico2[,-6]
cadunico3  <- cadunico3[,-6]

cadunico4 <- dplyr::filter(cadunico3, anomes_s == "202312")

cadunico <- readxl::read_xlsx("cadunico_std.xlsx")  
cadunico$CD_MUN <- str_pad(cadunico$CD_MUN,0)

linkr <- getwd()
link_pnud <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/"
link_ler <- paste(link_pnud, "BT_MDR_caracterizacao_municipios.xlsx", sep = '')

ABT12 <- readxl::read_xlsx("ABT_MDR_caracterizacao_municipios.xlsx")

ABT13 <- sparklyr::full_join(ABT12, cadunico, by = "CD_MUN")

writexl::write_xlsx(ABT13, "ABT_MDR_caracterizacao_municipios4.xlsx")  

}