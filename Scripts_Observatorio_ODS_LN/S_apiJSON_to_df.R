# Instale o pacote jsonlite (se ainda não estiver instalado)
install.packages("jsonlite")

# Carregue o pacote jsonlite
library(jsonlite)

# Leitura de dados JSON de uma URL:
  # A função principal do pacote jsonlite para ler dados JSON de uma URL é fromJSON(). Aqui está um exemplo de como usá-la:

# URL do arquivo JSON
url <- "https://www.ilhabela.sp.gov.br/portal/dados-abertos/contratos/2025"

# Leia os dados JSON da URL
dados <- fromJSON(url)

# Exiba os dados
print(dados)


str(dados)

df <- as.data.frame(dados)
