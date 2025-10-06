# Avaliação DEA - pacote Benchmarking

# Configs e carrega pacotes
{
configs()       # executa função configurações 
install.packages("Benchmarking")
library(Benchmarking)
library(readxl)

#Comentarios sobre a DEA
{
#Usaremos a função "dea" desse pacote e seus padrões (default)
#dea(X, Y, RTS="vrs", ORIENTATION="in", XREF=NULL, YREF=NULL,
##    FRONT.IDX=NULL, SLACK=FALSE, DUAL=FALSE, DIRECT=NULL, param=NULL,
##    TRANSPOSE=FALSE, FAST=FALSE, LP=FALSE, CONTROL=NULL, LPK=NULL)

#X Matriz de insumos das firmas que serão analisadas, 
## matriz de ordem K x m, sendo m insumos e k firmas

# Y - matriz dos produtos incluídos na análise. 
## ordem k x n, sendo n produtos e k firmas.

# RTS :texto ou número definindo o modelo DEA a ser estimado/retornos à escala
## 0 fdh : Free disposability hull, não é assumido convexidade;
## 1 vrs : Retornos variáveis à escala, convexidade e free disposability
## 2 drs : Retornos descrescentes à escala, convexidade, down-scaling e
## "free disposability" (disponibilidade fraca);
## 3 crs : Retornos constantes à escala, convexidade e free disposability
## 4 irs : Retornos crescentes à escala, 
## (up-scaling, mas não down-scaling), convexidade e free disposability
## 5 irs2: Retornos crescentes à escala
## (up-scaling, mas não down-scaling), additividade e  free disposability
# 6 add : Aditividade (scaling up e down, mas apenas com inteiros), 
## e free disposability; também conhedico uma replicabilidade e free disposability, 
## a free disposability e replicability hull (frh) – não é assumido convexidade
# 7 fdh+: Combinação de "free disposability" e restrito ou retornos constantes à
## escala local
#10 vrs+ :Retornos variáveis à escala, mas não há restrição sobre os 
## lambdas individuais via param

# ORIENTATION: insumo  "in" (1), produto "out" (2), e gráfico da eficiência "graph"

#XREF: Insumos das firmas determinando a tecnologia, default (padrão): X

#YREF: Produtos das firmas determinando a tecnologia,default: Y

#FRONT.IDX: Indices das firmas determinando a tecnologia

#SLACK: Calcula a as folgas dos insumos/produtos na etapa 2 via função slack.
}


# Função escala Min-Max (Normalização)
f_minmax0 <- function(x) {
  return(x / max(x) ) }


f_minmaxn <- function(x) {
  return(1- (x - min(x))/(max(x)-min(x)) )
}

}

# Dissertação - primeira entrega
{
# DEA Educação
{
edu <- read_xlsx ("abt_edu.xlsx")

#edu$Gasto_educ_pc                    <- f_minmax(edu$Gasto_educ_pc)
#edu$IDEB_2023_F1                     <- f_minmax(edu$IDEB_2023_F1)
#edu$IDEB_2023_F2                     <- f_minmax(edu$IDEB_2023_F2)
#edu$Gasto_educ_pc                    <- f_minmax(edu$Gasto_educ_pc)
#edu$Retenção                         <- f_minmax(edu$Retenção)
#edu$Distorcao                        <- f_minmax(edu$Distorcao)
#edu$Matriculas_total                 <- f_minmax(edu$Matriculas_total)
#edu$Gasto_educ                       <- f_minmax(edu$Gasto_educ)

#Matriz de insumos. Perceba que você deve combinar todos os insumos via função cbind

x <- as.matrix(with (edu, cbind(receitas_correntes_10000000_2023_PC,
                                desp_12edu_2023_PC, 
                                Docentes_PC)))

# Matriz de produtos. 
y <- as.matrix(with(edu, cbind(IDEB_2023_F1, 
                               IDEB_2023_F2,
                               Matricula_total,
                               Retencao,
                               Desempenho_Educacao_Distorcao_Idade_Serie_Ens_Fund_Dado_Bruto
                                )))

#Estimando a eficiência.

## Retornos constantes à escala e orientação insumo
eci <- dea(x,y, RTS="crs", ORIENTATION = "in")

## Retornos constantes à escala e orientação produto
eco <- dea(x,y, RTS="crs", ORIENTATION = "out")

## Retornos variáveis à escala e orientação insumo
evi <- dea(x,y, RTS="vrs", ORIENTATION = "in")

## Retornos variáveis à escala e orientação produto
evo <- dea(x,y, RTS="vrs", ORIENTATION = "out")

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

res$indcrsi <- f_minmax0(res$crs_i)
res$indcrso <- f_minmax0(res$crs_o)
res$indvrsi <- f_minmax0(res$vrs_i)
res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "edu_result_dea.xlsx")
}

# DEA Saneamento
{

san <- read_xlsx ("abt_san.xlsx")


#Matriz de insumos. Combinar todos os insumos via função cbind

x <- as.matrix(with (san, cbind(receitas_correntes_10000000_2023_PC,
                                desp_17sab_2023_PC,
                                inv_tot,
                                inv_total_saneamento_10anos,
                                FN220_Despesas_Municipais_com_residuos
                                ))) 

# Matriz de produtos. 
y <- as.matrix(with(san, cbind(IN015_AE_Índice_de_coleta_de_esgoto,
                               IN055_AE_Índice_de_atendimento_agua, 
                               Qtd_RDO_e_RPU_2022_PC, 
                               CS009_Resíduos_Recicláveis_perc
                               )))
#Estimando a eficiência.

## Retornos constantes à escala e orientação insumo
eci <- dea(x,y, RTS="crs", ORIENTATION = "in")

## Retornos constantes à escala e orientação produto
eco <- dea(x,y, RTS="crs", ORIENTATION = "out")

## Retornos variáveis à escala e orientação insumo
evi <- dea(x,y, RTS="vrs", ORIENTATION = "in")

## Retornos variáveis à escala e orientação produto
evo <- dea(x,y, RTS="vrs", ORIENTATION = "out")

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

res$indcrsi <- f_minmax0(res$crs_i)
res$indcrso <- f_minmax0(res$crs_o)
res$indvrsi <- f_minmax0(res$vrs_i)
res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "san_result_dea.xlsx")
}

#DEA Saude
{
sau <- read_xlsx ("abt_sau.xlsx")


#Matriz de insumos. Combinar todos os insumos via função cbind
  

x <- as.matrix(with (sau, cbind(receitas_correntes_10000000_2023_PC,
                                desp_10sau_2023_PC
                                ))) 

# Matriz de produtos. 
y <- as.matrix(with(sau, cbind(Mortalidade_Infantil_ate_5_anos,
                               Desempenho_Saude_Cobertura_Atencao_Basica_Dado_Bruto,                               Quantidade_Leitos_1000h,
                               Quantidade_estabelec_saude_1000h,
                               Quantidade_Leitos_1000h,
                               Med_1000habitante,
                               Enf_1000habitante
                               )))
#Estimando a eficiência.

## Retornos constantes à escala e orientação insumo
eci <- dea(x,y, RTS="crs", ORIENTATION = "in")

## Retornos constantes à escala e orientação produto
eco <- dea(x,y, RTS="crs", ORIENTATION = "out")

## Retornos variáveis à escala e orientação insumo
evi <- dea(x,y, RTS="vrs", ORIENTATION = "in")

## Retornos variáveis à escala e orientação produto
evo <- dea(x,y, RTS="vrs", ORIENTATION = "out")

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

res$indcrsi <- f_minmax0(res$crs_i)
res$indcrso <- f_minmax0(res$crs_o)
res$indvrsi <- f_minmax0(res$vrs_i)
res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "sau_result_dea.xlsx")
}

#DEA Segurança
{

seg <- read_xlsx ("abt_seg.xlsx")


#Matriz de insumos. Combinar todos os insumos via função cbind

x <- as.matrix(with (seg, cbind(receitas_correntes_10000000_2023_PC,
                                desp_06seg_2023_PC
                                ))) 

# Matriz de produtos. 
y <- as.matrix(with(seg, cbind(TOT._DE_INQUÉRITOS_POLICIAIS100,
                               HOMICÍDIOS100, 
                               ESTUPROS100, 
                               ROUBOS100,
                               FURTO100  
                               ))) 

#Estimando a eficiência.

## Retornos constantes à escala e orientação insumo
eci <- dea(x,y, RTS="crs", ORIENTATION = "in")

## Retornos constantes à escala e orientação produto
eco <- dea(x,y, RTS="crs", ORIENTATION = "out")

## Retornos variáveis à escala e orientação insumo
evi <- dea(x,y, RTS="vrs", ORIENTATION = "in")

## Retornos variáveis à escala e orientação produto
evo <- dea(x,y, RTS="vrs", ORIENTATION = "out")

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

res$indcrsi <- f_minmax0(res$crs_i)
res$indcrso <- f_minmax0(res$crs_o)
res$indvrsi <- f_minmax0(res$vrs_i)
res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "seg_result_dea.xlsx")
}



# Plots
  {
#Veja o que tratamos teoricamente no vídeo teórico, 
## Os escores de eficiência sobre a pressuposição de retornos constantes com orientação
### insumo e produto são iguais, o que não ocorre sobre a pressuposição de retornos
### variáveis;
## Os escores de eficiência com a pressuposição de retornos variáveis são maiores
### do que os calculados sobre a orientação de retornos variáveis.


#Podemos traçar a isoquanta para essa função com dois insumos 
dea.plot.isoquant(tone$x1, tone$x2, RTS="vrs", txt=T)
#Podemos obter a fronteira de possibilidades de produção
## sobre a pressuposição de retornos consntantes, 
dea.plot.frontier(x, y, RTS="crs", txt=T)
## sobre a pressuposição de retornos variáveis, 
dea.plot.frontier(x, y, RTS="vrs", txt=T)

}

####    Pacote Eficiência nonparaeff
{
#Importando
library(readxl)
tone <- read_excel("Gastos_educ_x_ideb.xlsx")
install.packages("nonparaeff")
library(nonparaeff)
rt <- sbm.tone(res) # , noutput = 1)

writexl::write_xlsx(rt, "rt.xlsx")
}
} # Dissertação - primeira entrega FIM

############### segunda versão da Dissertação

url <- "C:/Users/carlo/Desktop/Observatório dos ODS/RProjet _workspace_Observatorio_ODS_LN_2024/ABT_MDR_caracterizacao_municipios_RMVale_V20250302.xlsx"
abt <- read_xlsx (url)


#### Educação DEA
{
  abt$desp_12edu_2023_PC   <- as.numeric(abt$desp_12edu_2023_PC)
  
  inputs <- as.matrix(with (abt, cbind(desp_12edu_2023_PC))) #Matriz de Insumos

# Matriz de produtos. 
outputs <- as.matrix(with(abt, cbind(IDEB_2023_F1_NxP, IDEB_2023_F2_NxP))) #matriz de produtos

inputs <- inputs[-40]
outputs <- outputs[-40, ]


#Estimando a eficiência.


eci <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "in")  # Retornos constantes à escala e orientação insumo
eco <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "out") # Retornos constantes à escala e orientação produto
evi <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "in")  # Retornos variáveis à escala e orientação insumo
evo <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "out") # Retornos variáveis à escala e orientação produto

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

# res$indcrsi <- f_minmax0(res$crs_i)
# res$indcrso <- f_minmax0(res$crs_o)
# res$indvrsi <- f_minmax0(res$vrs_i)
# res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "edu_result_dea.xlsx")
}

#### Saúde DEA
{
  abt$desp_10sau_2023      <- as.numeric(abt$desp_10sau_2023)
  
  inputs <- as.matrix(with (abt, cbind(desp_10sau_2023))) #Matriz de Insumos

# Matriz de produtos. 
outputs <- as.matrix(with(abt, cbind(Quantidade_Leitos_1000h, ESF_2020,perc_Pop_internacoes))) #matriz de produtos

inputs <- inputs[-40]
outputs <- outputs[-40, ]


#Estimando a eficiência.

eci <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "in")  # Retornos constantes à escala e orientação insumo
eco <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "out") # Retornos constantes à escala e orientação produto
evi <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "in")  # Retornos variáveis à escala e orientação insumo
evo <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "out") # Retornos variáveis à escala e orientação produto

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

# res$indcrsi <- f_minmax0(res$crs_i)
# res$indcrso <- f_minmax0(res$crs_o)
# res$indvrsi <- f_minmax0(res$vrs_i)
# res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "sau_result_dea.xlsx")
}

#### Segurança DEA
{
  abt$desp_06seg_2023_PC   <- as.numeric(abt$desp_06seg_2023_PC)
  
inputs <- as.matrix(with (abt, cbind(desp_06seg_2023_PC))) #Matriz de Insumos

# Matriz de produtos. 
outputs <- as.matrix(with(abt, cbind(HOMICÍDIOS100, ROUBOS100, FURTO100))) #matriz de produtos

inputs <- inputs[-40]
outputs <- outputs[-40, ]


#Estimando a eficiência.

eci <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "in")  # Retornos constantes à escala e orientação insumo
eco <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "out") # Retornos constantes à escala e orientação produto
evi <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "in")  # Retornos variáveis à escala e orientação insumo
evo <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "out") # Retornos variáveis à escala e orientação produto

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

# res$indcrsi <- f_minmax0(res$crs_i)
# res$indcrso <- f_minmax0(res$crs_o)
# res$indvrsi <- f_minmax0(res$vrs_i)
# res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "seg_result_dea.xlsx")
}


#### Saneamento Básico
{
  abt$inv_SAB_10anos_PC    <- as.numeric(abt$inv_SAB_10anos_PC)
  
inputs <- as.matrix(with (abt, cbind(inv_SAB_10anos_PC))) #Matriz de Insumos

# Matriz de produtos. 
outputs <- as.matrix(with(abt, cbind(Pop_com_abastecimento_de_agua_2022_PC, Populacao_atendida_com_esgotamento_sanitario_PC))) #matriz de produtos

inputs <- inputs[-40]
outputs <- outputs[-40, ]


#Estimando a eficiência.

eci <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "in")  # Retornos constantes à escala e orientação insumo
eco <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "out") # Retornos constantes à escala e orientação produto
evi <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "in")  # Retornos variáveis à escala e orientação insumo
evo <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "out") # Retornos variáveis à escala e orientação produto

#Combinando os resultados (indice de eficiencia de cada modelo) 

res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                  crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)

# res$indcrsi <- f_minmax0(res$crs_i)
# res$indcrso <- f_minmax0(res$crs_o)
# res$indvrsi <- f_minmax0(res$vrs_i)
# res$indvrso <- f_minmax0(res$vrs_o)

writexl::write_xlsx(res, "sab_result_dea.xlsx")
}

#### Capacidade de Gestão
{
abt$receitas_correntes_2023_PC  <- as.numeric(abt$receitas_correntes_2023_PC)
  
  inputs <- as.matrix(with (abt, cbind(receitas_correntes_2023_PC))) #Matriz de Insumos
  
  # Matriz de produtos. 
  outputs <- as.matrix(with(abt, cbind(IPDM_2022, iegm_score))) #matriz de produtos
  
  inputs <- inputs[-40]
  outputs <- outputs[-40, ]
  
  
  #Estimando a eficiência.
  
  eci <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "in")  # Retornos constantes à escala e orientação insumo
  eco <- dea(X = inputs, Y = outputs, RTS="crs", ORIENTATION = "out") # Retornos constantes à escala e orientação produto
  evi <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "in")  # Retornos variáveis à escala e orientação insumo
  evo <- dea(X = inputs, Y = outputs, RTS="vrs", ORIENTATION = "out") # Retornos variáveis à escala e orientação produto
  
  #Combinando os resultados (indice de eficiencia de cada modelo) 
  
  res <- data.frame(crs_i = eci$eff, crs_o = eco$eff, vrs_i = evi$eff, vrs_o = evo$eff,
                    crs_1o = 1/eco$eff, vrs_1o = 1/evo$eff)
  
  # res$indcrsi <- f_minmax0(res$crs_i)
  # res$indcrso <- f_minmax0(res$crs_o)
  # res$indvrsi <- f_minmax0(res$vrs_i)
  # res$indvrso <- f_minmax0(res$vrs_o)
  
  writexl::write_xlsx(res, "ges_result_dea.xlsx")
}

####### teste pacote rDEA

install.packages("rDEA")
library(rDEA)

# Criando um conjunto de dados de exemplo (5 DMUs, 2 inputs, 1 output)
inputs <- matrix(c(5, 3, 2, 4, 6,   # Input 1
                   8, 6, 5, 7, 9),  # Input 2
                 nrow = 5, byrow = FALSE)

outputs <- matrix(c(10, 9, 7, 8, 12),  # Output único
                  nrow = 5, byrow = FALSE)

# Rodando o DEA CRS orientado para entrada
dea_result <- dea(XREF=inputs, YREF=outputs, model = "input", RTS="variable")

di_naive = dea(X, Y, X=X[firms,], Y=Y[firms,], model="input", )

# Exibir os índices de eficiência
print(dea_result$theta)