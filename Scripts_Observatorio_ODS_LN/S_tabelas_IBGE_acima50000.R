pra quem usa o pacote sidrar do IBGE por API, acima de 50 mil registros.
#cria o vetor
cod_sidras <- c('/t/4094/n1/all/n2/all/n3/all/n6/all/v/4096,4099,12466/p/all/c58/allxt/d/v4096%201,v4099%201,v12466%201',      '/t/4094/n1/all/n2/all/n3/all/n6/all/v/4104,4106,4108/p/all/c58/allxt/d/v4104%201,v4106%201,v4108%201',
                '/t/4094/n1/all/n2/all/n3/all/n6/all/v/4110,4112/p/all/c58/allxt/d/v4110%201,v4112%201')
lista_dataframes <- list()
# Loop sobre as APIs
for (api in cod_sidras) {
  # Obtém o dataframe para a API atual
  pnadct <- get_sidra(api = api)
  # Adiciona o dataframe resultante à lista
  lista_dataframes[[api]] <- pnadct
}
# Agrega os dataframes em um único dataframe usando bind_rows
pnadctGR <- bind_rows(lista_dataframes)
...daqui por diante é o basico: modify, filter, group_by etc. à medida da necessidade, resultado nos links abaixo: 
  Indice de Gini (Pnad Contínua/A)
http://www.ipeadata.gov.br/ExibeSerieR.aspx?stub=1...
Índice de Desenvolvimento Humano Municipal (IDHM)
http://www.ipeadata.gov.br/ExibeSerieR.aspx?stub=1...
Taxa de pobreza nacional
http://www.ipeadata.gov.br/ExibeSerieR.aspx?stub=1...
Taxa de desemprego (IBGE/Pnad Contínua)
http://www.ipeadata.gov.br/ExibeSerieR.aspx?stub=1...