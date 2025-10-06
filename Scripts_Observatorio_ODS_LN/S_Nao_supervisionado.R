
#   CHAMANDO BIBLIOTECAS IMPORTANTES ######
{
library(tidyverse) #pacote para manipulacao de dados
library(cluster) #algoritmo de cluster
library(dendextend) #compara dendogramas
library(factoextra) #algoritmo de cluster e visualizacao
library(fpc) #algoritmo de cluster e visualizacao
library(gridExtra) #para a funcao grid arrange
library(readxl)
library(ggplot2)
}

########################################
#
#         CLUSTER HIERARQUICO - juntos
#
########################################

#LEITURA DOS DADOS
ABT <- readxl::read_xlsx("ABT_MDR_PNUD.xlsx") ; 
alunos_pap <- read.table("alunos_pap.csv", sep = ";", header = T, dec = ",")

View(alunos_pap)
rownames(alunos_pap) <- alunos_pap[,1]  #variavel tem que informar ao R que é nome da linha
alunos_pap <- alunos_pap[,-1]

#CALCULANDO MATRIZ DE DISTANCIAS
d <- dist(alunos_pap, method = "euclidean")     #0 distancia euclidiana
d

#DEFININDO O CLUSTER A PARTIR DO METODO ESCOLHIDO 
#metodos disponiveis "average", "single", "complete" e "ward.D"
hc1 <- hclust(d, method = "single" )
hc2 <- hclust(d, method = "complete" )
hc3 <- hclust(d, method = "average" )
hc4 <- hclust(d, method = "ward.D" )

#DESENHANDO O DENDOGRAMA
plot(hc1, cex = 0.6, hang = -1)      #dendogramas
plot(hc2, cex = 0.6, hang = -1)
plot(hc3, cex = 0.6, hang = -1)
plot(hc4, cex = 0.6, hang = -1)

plot(hc1)
#BRINCANDO COM O DENDOGRAMA PARA 2 GRUPOS  
rect.hclust(hc4, k = 2)                 #apenas marca como dividir os grupos (a tesoura)

#COMPARANDO DENDOGRAMAS
#comparando o metodo average com ward
dend3 <- as.dendrogram(hc3)
dend4 <- as.dendrogram(hc4)
dend_list <- dendlist(dend3, dend4) 
#EMARANHADO, quanto menor, mais iguais os dendogramas sao
tanglegram(dend3, dend4, main = paste("Emaranhado =", round(entanglement(dend_list),2)))  #quanto maior o emaranhado melhor 
#agora comparando o metodo single com complete
dend1 <- as.dendrogram(hc1)
dend2 <- as.dendrogram(hc2)
dend_list2 <- dendlist(dend1, dend2) 
dend_list2den #EMARANHADO, quanto menor, mais iguais os dendogramas sao
tanglegram(dend1, dend2, main = paste("Emaranhado =", round(entanglement(dend_list2),2)))

#criando 2 grupos de alunos
grupo_alunos2 <- cutree(hc4, k = 3)
table(grupo_alunos2)

#transformando em data frame a saida do cluster
alunos_grupos <- data.frame(grupo_alunos2)

#juntando com a base original
Base_alunos_fim <- cbind(alunos_pap, alunos_grupos)    #cbind é basicamente um join

# entendendo os clusters
#FAZENDO ANALISE DESCRITIVA
#MEDIAS das variaveis por grupo
mediagrupo_alunos <- Base_alunos_fim %>% 
  group_by(grupo_alunos2) %>% 
  summarise(n = n(),
            Portugues = mean(Portugues), 
            Matematica = mean(Matematica))
mediagrupo_alunos


########################################
#     CLUSTER HIERARQUICO - MCDonald
#
########################################

#Carregar base de dados: 
mcdonalds <- read.table("dados/MCDONALDS.csv", sep = ";", dec = ",", header = T)
#transformar o nome dos lanches em linhas
rownames(mcdonalds) <- mcdonalds[,1]
mcdonalds <- mcdonalds[,-1]

#Padronizar variaveis
mcdonalds.padronizado <- scale(mcdonalds)

#calcular as distancias da matriz utilizando a distancia euclidiana
distancia <- dist(mcdonalds.padronizado, method = "euclidean")

#Calcular o Cluster: metodos disponiveis "average", "single", "complete" e "ward.D"
cluster.hierarquico <- hclust(distancia, method = "single" )

# Dendrograma
plot(cluster.hierarquico, cex = 0.6, hang = -1)

#Criar o grafico e destacar os grupos
rect.hclust(cluster.hierarquico, k = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(mcdonalds.padronizado, FUN = hcut, method = "wss")


#criando 4 grupos de lanches
grupo_lanches4 <- cutree(cluster.hierarquico, k = 4)
table(grupo_lanches4)

#transformando em data frame a saida do cluster
Lanches_grupos <- data.frame(grupo_lanches4)

#juntando com a base original
Base_lanches_fim <- cbind(mcdonalds, Lanches_grupos)

#FAZENDO ANALISE DESCRITIVA
#MEDIAS das variaveis por grupo
mediagrupo <- Base_lanches_fim %>% 
  group_by(grupo_lanches4) %>% 
  summarise(n = n(),
            Valor.Energetico = mean(Valor.Energetico), 
            Carboidratos = mean(Carboidratos), 
            Proteinas = mean(Proteinas),
            Gorduras.Totais = mean(Gorduras.Totais), 
            Gorduras.Saturadas = mean(Gorduras.Saturadas), 
            Gorduras.Trans = mean(Gorduras.Trans),
            Colesterol = mean(Colesterol), 
            Fibra.Alimentar = mean(Fibra.Alimentar), 
            Sodio = mean(Sodio),
            Calcio = mean(Calcio), 
            Ferro = mean(Ferro) )
mediagrupo


########################################
#
#    CLUSTER NAO HIERARQUICO - Mcdonald
#
########################################

#AGRUPANDO LANCHES PELO METODO NAO HIERARQUICO

#Rodar o modelo
mcdonalds.k2 <- kmeans(mcdonalds.padronizado, centers = 2)

#Visualizar os clusters
fviz_cluster(mcdonalds.k2, data = mcdonalds.padronizado, main = "Cluster K2")

#Criar clusters
mcdonalds.k3 <- kmeans(mcdonalds.padronizado, centers = 3)
mcdonalds.k4 <- kmeans(mcdonalds.padronizado, centers = 4)
mcdonalds.k5 <- kmeans(mcdonalds.padronizado, centers = 5)

#Criar graficos
G1 <- fviz_cluster(mcdonalds.k2, geom = "point", data = mcdonalds.padronizado) + ggtitle("k = 2")
G2 <- fviz_cluster(mcdonalds.k3, geom = "point",  data = mcdonalds.padronizado) + ggtitle("k = 3")
G3 <- fviz_cluster(mcdonalds.k4, geom = "point",  data = mcdonalds.padronizado) + ggtitle("k = 4")
G4 <- fviz_cluster(mcdonalds.k5, geom = "point",  data = mcdonalds.padronizado) + ggtitle("k = 5")

#Imprimir graficos na mesma tela
grid.arrange(G1, G2, G3, G4, nrow = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(mcdonalds.padronizado, kmeans, method = "wss")


########################################
#
#    CLUSTER NAO HIERARQUICO - Municipios
#
########################################

#carregar base municipio
municipios <- read.table("dados/municipios.csv", sep = ";", header = T, dec = ",")
rownames(municipios) <- municipios[,1]
municipios <- municipios[,-1]


#padronizar dados
municipios.padronizado <- scale(municipios)


#Agora vamos rodar de 3 a 6 centros  e visualizar qual a melhor divisao
municipios.k3 <- kmeans(municipios.padronizado, centers = 3)
municipios.k4 <- kmeans(municipios.padronizado, centers = 4)
municipios.k5 <- kmeans(municipios.padronizado, centers = 5)
municipios.k6 <- kmeans(municipios.padronizado, centers = 6)

#Graficos
G1 <- fviz_cluster(municipios.k3, geom = "point", data = municipios.padronizado) + ggtitle("k = 3")
G2 <- fviz_cluster(municipios.k4, geom = "point",  data = municipios.padronizado) + ggtitle("k = 4")
G3 <- fviz_cluster(municipios.k5, geom = "point",  data = municipios.padronizado) + ggtitle("k = 5")
G4 <- fviz_cluster(municipios.k6, geom = "point",  data = municipios.padronizado) + ggtitle("k = 6")

#Criar uma matriz com 4 graficos
grid.arrange(G1, G2, G3, G4, nrow = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(municipios.padronizado, FUN = hcut, method = "wss")


#juntando dados
municipios2 <- read.table("dados/municipios.csv", sep = ";", header = T, dec = ",")
municipiosfit <- data.frame(municipios.k6$cluster)

#Agrupar cluster e base
MunicipioFinal <-  cbind(municipios2, municipiosfit)



