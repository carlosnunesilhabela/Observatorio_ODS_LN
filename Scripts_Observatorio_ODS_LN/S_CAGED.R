
# catalog_mtps: lista os dados do site em um catálogo;
# datavault_mtps: baixa os arquivos de dados brutos para um diretório local específico;
# build_mtps: constrói a base de dados;
# sqlite_mtps: constrói a base de dados em SQLite.

# instala libraries
load_packages()

# carrega libraries
library(DBI)
library(RSQLite)

# define diretórios
output_dir <- file.path( tempdir() , "MTPS" ) 
datavault_dir <- file.path( tempdir() , "MTPS_DV" ) 

# carrega funções
downloader::source_url( "https://raw.githubusercontent.com/guilhermejacob/guilhermejacob.github.io/master/scripts/mtps.R" , prompt = FALSE )

# cria catálogo de dados
catalog <- catalog_mtps( output_dir = output_dir )

# cria datavault
# esse passo é opcional!
catalog <- datavault_mtps( catalog = catalog, datavault_dir = datavault_dir )

# limita apenas para bases de 2016
catalog <- subset( catalog , year == 2023 )

# constrói base de dados
build_mtps( catalog = catalog )

# base de dados em sqlite
sqlite_mtps( catalog = catalog )
