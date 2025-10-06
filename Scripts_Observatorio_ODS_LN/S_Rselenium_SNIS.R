###  RSelenium project: capturar dados no SNIS - Sistema Nacional de Informações de Saneamento

configs()
load_packages()

profcrn <- getChromeProfile(
           "C:\\Users\\carlo\\AppData\\Local\\Google\\Chrome\\User Data", "Profile 2" )

remote_driver <- remoteDriver(browserName = "chrome", extraCapabilities = profcrn)

lista_municipios <- read_excel("municipios_a_pesquisar.xlsx") %>% unlist() 


# Definir remote server / navegador e a função que vai executar a tarefa 
 
binman::rm_platform("phantomjs")   #correct error "Error in if (file.access(phantompath, 1) < 0)...."
wdman::selenium(retcommand = TRUE)

driver <- RSelenium::rsDriver(port = 4567L, browser = "chrome", 
                              chrome = "97.0.4692.71", verbose = F)
# Definir remote driver 

remote_driver <- driver[["client"]] 

# robot função que vai fazer todo o trabalho:

remote_driver$open()

url <- "http://app4.mdr.gov.br/serieHistorica/municipio/index"
remote_driver$navigate(url)
# remote_driver$navigate(paste0(url,"-historical-data"))  # adiciona um string ao final da URL
# url = remote_driver$getCurrentUrl()

#clica no botão   Informações de Indicadores dos Municípios Consolidados
inf_ind_mun_con = remote_driver$findElement(using = 'xpath', "//*[@id='oculto']/li[2]/a") 
inf_ind_mun_con$clickElement()

#clica no botão Estado //*[@id="frm_filtros"]/fieldset[2]/p[2]/button/span[2]

#clica no botão Municípios/Seleciona
botao_municipios = remote_driver$findElement(using = 'xpath', "//*[@id='frm_filtros']/fieldset[3]/p/button/span[2]") 
botao_municipios$clickElement() 
Sys.sleep(15)   #aguarda montar a tabela dos municipios (em torno de 15 segundos)
botao_municipios$clickElement() 
print ("Tabela carregada")

for (i in 1:length(lista_municipios)) {                   
      
      print(paste(i, " - imprime cod.municipio", lista_municipios[i]))
  
      botao_municipios$clickElement() 
        print ('cliquei no botão Municípios/Seleciona')

      
      
      botao_filtrar = remote_driver$findElement(using = 'xpath', "//*[@id='multiselect_menu_cod_mun']/div/div/input") 
      Sys.sleep(2)
      botao_filtrar$sendKeysToElement(list(key='backspace', key='backspace', key='backspace',
                                           key='backspace', key='backspace', key='backspace'))
        print('Digita 5 backspaces no botão Filtrar - para limpar conteúdo anterior')
      
      
      botao_filtrar$sendKeysToElement(list(lista_municipios[i])) 
        print(paste('Digitei o cod.municipio', lista_municipios[i], 'no botão Filtrar'))
      
      Sys.sleep(2)
      marcar_todos = remote_driver$findElement(using = 'xpath', "/html/body/div[8]/div/ul/li[1]/a/span[1]")
      Sys.sleep(2)
     
      marcar_todos$clickElement()                         # click
      marcar_todos$sendKeysToElement(list(key='enter'))   # Enter
      print('Cliquei e dei enter no botão Marcar Todos')
}

#clica novamento no botão Municípios/Seleciona (apenas para apagar a janela de seleção)
botao_municipios = remote_driver$findElement(using = 'xpath', "//*[@id='frm_filtros']/fieldset[3]/p/button/span[2]") 
botao_municipios$clickElement() 

#Clica no Botão CONTINUAR
botao_continuar = remote_driver$findElement(using = 'xpath', "//*[@id='bt_gerar']")
Sys.sleep(2)
botao_continuar$clickElement()    # ENTER

#clica no botão família de Indicadores / Selecione
botao_selecione = remote_driver$findElement(using = 'xpath', "//*[@id='frm_colunas']/p[1]/button/span[2]")
Sys.sleep(2)
botao_selecione$clickElement()    # ENTER

marcar_todos2 = remote_driver$findElement(using = 'xpath', "//*[@id='multiselect_menu_cod_fam_info']/div/ul/li[1]/a/span[2]")
Sys.sleep(2)
marcar_todos2$clickElement()    # ENTER

#clica no botão família de Indicadores / Selecione  (apenas para apagar a janela de seleção)
botao_selecione = remote_driver$findElement(using = 'xpath', "//*[@id='frm_colunas']/p[1]/button/span[2]")
Sys.sleep(2)
botao_selecione$clickElement()    # ENTER

#clica no botão Consultar  (ERR0)
botao_consultar = remote_driver$findElement(using = 'xpath', "//*[@id='bt_gerar']/text()")
Sys.sleep(2)
botao_consultar$clickElement()

Sys.sleep(20)   #aguarda gerar as planilhas

# clica no botao gerar planilha
botao_gerar_planilha = remote_driver$findElement(using = 'xpath', "consultar//*[@id='bt_relatorio']/text()")
botao_gerar_planilha$clickElement()  # ENTER

remote_driver$close()


  