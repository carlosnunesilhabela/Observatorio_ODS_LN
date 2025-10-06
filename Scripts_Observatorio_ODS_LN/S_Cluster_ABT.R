# ANALISE DE CLUSTER
configs()

# Retirar notacao cientifica no R
options(scipen = 999)

library(readxl)
library("cluster")
library("factoextra")
library("gridExtra")

ABT_eco <- readxl::read_xlsx("ABT_municipios_economico_std.xlsx")

# remove(ABT_eco)

#Calcular a matriz de distancias euclidianas os municipios
dist_euclid <- dist(ABT_eco[7:8], method="euclidean")  #Calculo das distancias euclidianas
 

# seleção de variaveis para clusterização atraves do pca 
  
#Faca a analise de agrupamento com as variaveis padronizadas
#usando os 2 metodos apresentados, escolha um dos metodos 
#e justifique a quantidade de grupos apos a analise do Dendrograma.

#Matriz de graficos de dimensao 1 linhas x 2 colunas

par(mfrow=c(1,1)) #janela grafica

#método do vizinho mais próximo
clust_res <- hclust(dist_euclid, method="ward.D") 

#Analise as caracteristicas de cada grupo.
#Atribui a cada pais o cluster a qual ele pertence pela variavel cluster
ABT_eco$cluster2 <- as.factor(cutree(clust_res, k=5))  #corta em 5

#Tamanho dos Clusters
table(ABT_eco$cluster)

#Faz BoxPlot para cada variavel e compara por cluster
#Distribuicao das variaveis por cluster
par(mfrow=c(2,5)) #coloca os graficos lado a lado

boxplot(ABT_eco$Receitas_correntes_2022_PC ~ ABT_eco$cluster, col="paleturquoise",main="Receitas correntes")
# boxplot(ABT_eco$ODS8_Score ~ ABT_eco$cluster, col="darkturquoise",main="ODS8")
# boxplot(ABT_eco$ODS9_Score ~ ABT_eco$cluster, col="paleturquoise",main="ODS9")
# boxplot(ABT_eco$ODS11_Score ~ ABT_eco$cluster, col="darkturquoise",main="ODS11")
boxplot(ABT_eco$Pib_municipal_PC  ~ ABT_eco$cluster, col="darkturquoise",main="PIB")
boxplot(ABT_eco$Total_empresas_inst_2022_PC ~ ABT_eco$cluster, col="paleturquoise",main="Total Empresas")
boxplot(ABT_eco$Pessoal_ocupado_2022_PC ~ ABT_eco$cluster, col="darkturquoise",main="Pessoal Ocupado")
boxplot(ABT_eco$Pessoal_Assalariado_2022_PC ~ ABT_eco$cluster, col="paleturquoise",main="Pessoal Assalariado")
boxplot(ABT_eco$qtd_pes_pob_12_2023_PC ~ ABT_eco$cluster, col="paleturquoise",main="Pobreza")
boxplot(ABT_eco$qtd_pes_baixa_renda_12_2023_PC ~ ABT_eco$cluster, col="paleturquoise",main="Baixa Renda")

writexl::write_xlsx(ABT_eco, "Cluster_eco.xlsx")
