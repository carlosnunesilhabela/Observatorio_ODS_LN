
Baixar empresas

url_baixar <- "https://sidra.ibge.gov.br/geratabela?format=xlsx&name=tabela9418.xlsx&terr=N&rank=-&query=t/9418/n6/all/v/allxp/p/all/c12762/117897/d/v662%200/l/v,p%2Bc12762,t"
download.file(url_baixar, "empresas.xlsx")   


{ 
cacemp <- readxl::read_xlsx("C:/Users/carlo/Desktop/tabela9418_cacempr.xlsx")  
cacemp$Municipio[1]

cacemp$Municipio <- paste(cacemp$Municipio,cacemp$UF) 

# Stardardização de campos 
cacemp$Municipio <- tolower(cacemp$Municipio)       # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
cacemp$Municipio <- rm_accent(cacemp$Municipio)     # Remove todas acentuações 
cacemp$Municipio <- str_replace_all(cacemp$Municipio, "[^[:alnum:]]", "")  # remove non alphanumeric characters

colnames(cacemp)[1] <- "municipio_std"
cacemp3 <- cacemp[,-7] #exceto coluna
cacemp <- cacemp3[,-2]

linkr <- getwd()
link_pnud <- "C:/Users/carlo/Desktop/144968 - Projeto BRA12017 - Sistema de Análise - Perfil Municipal-Defesa Civil/Bases de Dados/ABT_Componentes/"
link_ler <- paste(link_pnud, "ABT_MDR_caracterizacao_municipios2.xlsx", sep = '')

# ABT <- readxl::read_xlsx(link_ler) 

ABT11 <- sparklyr::full_join(ABT, cacemp, by = "municipio_std")
 
writexl::write_xlsx(ABT11, link_ler)  

}