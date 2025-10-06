
  # Pacotes usados no estudo
  
  ```{r, warning=FALSE, message=FALSE}
  # install.packages("remotes")
  remotes::install_github("rfsaldanha/microdatasus")
  2install.packages("microdatasus")

library(microdatasus)
library(tidyverse)
library(stargazer)
library(lubridate)
  pkgbuild::check_build_tools(debug = TRUE)
```

#  Fazendo o download dos dados do FTP do Datasus

```{r, warning=FALSE, message=FALSE}

nasc <- fetch_datasus(year_start = 2011,
                      year_end = 2021,
                      information_system = "SINASC")
```

# Fazendo um tratamento prévio dos dados com função própria do pacote Microdatasus

```{r, warning=FALSE, message=FALSE}

nascimento <- process_sinasc(nasc, municipality_data = FALSE)

```

# Selecionando as variáveis que serão utilizadas em meu estudo

```{r, warning=FALSE, message=FALSE}

#write.csv(nascimento, 'C:/Users/Usuario/Desktop/22_2/ATV600/Técnicas de Pesquisa em Economia II/dados.csv', 
#          row.names = FALSE)

# nascimento = read.csv("dados.csv")

selecao_nascimento <- nascimento %>%
  select(DTNASC,
         PESO,
         IDADEMAE,
         CONSPRENAT,
         ESCMAE,
         RACACORMAE,
         SEXO,
         ESTCIVMAE,
         GESTACAO)

```

# Criação de variáveis dummy para variável raça/cor e uma variavel dummy para pandemia^[Para estudos futuros]

```{r, warning=FALSE, message=FALSE}

selecao_nascimento <- selecao_nascimento %>%
  mutate(Parda = ifelse(selecao_nascimento$RACACORMAE == "Parda", 1, 0)) %>%
  mutate(Indigena = ifelse(selecao_nascimento$RACACORMAE == "Indígena",1, 0)) %>%
  mutate(Amarela = ifelse(selecao_nascimento$RACACORMAE == "Amarela", 1, 0)) %>%
  mutate(Preta = ifelse(selecao_nascimento$RACACORMAE == "Preta", 1, 0)) %>%
  mutate(pandemia = ifelse(selecao_nascimento$DTNASC >= "2020-11-01", 1, 0))

```

# Criação de variável negro e não negro

```{r, warning=FALSE, message=FALSE}

selecao_nascimento <- selecao_nascimento %>%
  mutate(negro = if_else(selecao_nascimento$RACACORMAE == "Parda"|selecao_nascimento$RACACORMAE == "Preta"|selecao_nascimento$RACACORMAE == "Indígena", "Negro", "Não negro"))

```

# Criação de variável dummy para variável negro e não negro

```{r, warning=FALSE, message=FALSE}

selecao_nascimento <- selecao_nascimento %>%
  mutate(Negro = ifelse(selecao_nascimento$negro == "Negro", 1,0))

```

# Criação de variável dummy para variável gênero

```{r, warning=FALSE, message=FALSE}

selecao_nascimento <- selecao_nascimento %>%
  mutate(feminino = ifelse(selecao_nascimento$SEXO == "Feminino",1,0))

```

# Conversão das variáveis idade e peso para numéricas

```{r, warning=FALSE, message=FALSE}

selecao_nascimento$PESO <- as.integer(selecao_nascimento$PESO)
selecao_nascimento$IDADEMAE <- as.integer(selecao_nascimento$IDADEMAE)

```

# Identificando quantidade de mães com idade superior a 60 anos

```{r, warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(IDADEMAE > 60)

```
Foram identificados 9 mães com idade superior a 60 e 127 com idade superior a 50

```{r, warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(IDADEMAE > 50)

```

# Filtrando apenas bebes que nasceram com peso inferior a 5kg

```{r, warning=FALSE, message=FALSE}

selecao_nascimento <- selecao_nascimento %>%
  filter(PESO < 5000)

```

Com este filtro, foram removidos 620 observações. Ou seja, 620 bebês tinha peso superior a 5 kg.

# Alguns gráficos - Descritiva do Estudo

```{r, results='asis', warning=FALSE, message=FALSE}

ggplot(selecao_nascimento, aes(x=PESO))+
  geom_histogram(bins = 300)+
  geom_density()+
  geom_vline(xintercept=3136, colour='red')+
  theme_bw()+
  labs(title = "",
       x="Peso",
       caption="Fonte: DATASUS - SINASC")

```

```{r, results='asis', warning=FALSE, message=FALSE}

ggplot(selecao_nascimento, aes(y=PESO, x=RACACORMAE))+
  geom_boxplot()+
  theme_bw()+
  labs(x="Raça cor da mãe",
       y="Peso",
       caption = "Fonte: DATASUS - SINASC")

```

```{r, results='asis', warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(IDADEMAE) %>%
  ggplot(aes(x=IDADEMAE, 
             y=n, 
             fill=IDADEMAE, 
             color=IDADEMAE))+
  geom_bar(stat = "identity")+
  geom_vline(xintercept=27.55, colour='red')+
  labs(title = "",
       subtitle = "",
       x = "Idade",
       y = "",
       caption = "Fonte: DATASUS - SINASC")+
  theme_bw()+
  theme(legend.position = "none")

```

```{r, results='asis', warning=FALSE, message=FALSE}

ggplot(selecao_nascimento, aes(y=IDADEMAE, x=RACACORMAE))+
  geom_boxplot()+
  theme_bw()+
  labs(x="Raça cor da mãe",
       y="Idade",
       caption = "Fonte: DATASUS - SINASC")


```

```{r, results='asis', warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(ESCMAE, RACACORMAE) %>%
  ggplot(aes(x=ESCMAE, 
             y=n, 
             fill=ESCMAE, 
             color=ESCMAE,
             label=n))+
  geom_bar(stat = "identity")+
  geom_label(color="white")+
  facet_wrap(~RACACORMAE, scales = "free",ncol = 2 )+
  coord_flip()+
  labs(title = "",
       subtitle = "",
       x = "Idade",
       y = "",
       caption = "")+
  theme_bw()+
  theme(legend.position = "none")


```

```{r, results='asis', warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(ESCMAE, RACACORMAE) %>%
  ggplot(aes(x=RACACORMAE, 
             y=n, 
             fill=ESCMAE, 
             color=ESCMAE,
             label=n))+
  geom_bar(stat = "identity")+
  geom_label(color="white")+
  facet_wrap(~ESCMAE, scales = "free",ncol = 2 )+
  labs(title = "",
       subtitle = "",
       x = "Idade",
       y = "",
       caption = "Fonte: DATASUS - SINASC")+
  theme_bw()+
  theme(legend.position = "none")


```

```{r, results='asis', warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(GESTACAO) %>%
  ggplot(aes(x=GESTACAO, 
             y=n, 
             label=n))+
  geom_bar(stat = "identity")+
  geom_label(color="black")+
  #coord_flip()+
  labs(title = "",
       subtitle = "",
       x = "Idade",
       y = "",
       caption = "Fonte: DATASUS - SINASC")+
  theme_bw()+
  theme(legend.position = "none")


```

```{r, results='asis', warning=FALSE, message=FALSE}

bpn <- selecao_nascimento %>%
  mutate(bpn = ifelse(PESO < 2500, "baixo peso", "não baixo peso"))

bpn <- bpn %>%
  mutate(ano = year(DTNASC))

```

```{r, results='asis', warning=FALSE, message=FALSE}

bpn_grafico_prop <- bpn %>%
  count(bpn, ano, RACACORMAE)

```

```{r, results='asis', warning=FALSE, message=FALSE}

bpn_grafico_prop <- bpn_grafico_prop %>%
  pivot_wider(names_from = "bpn", values_from = "n") %>%
  mutate(proporcao = `baixo peso`/`não baixo peso`*100) %>%
  select(ano, `baixo peso`, `não baixo peso`, proporcao, RACACORMAE)

```

```{r, results='asis', warning=FALSE, message=FALSE}

ggplot(bpn_grafico_prop, aes(x=RACACORMAE, y=proporcao))+
  geom_col()+
  theme_bw()+
  facet_wrap(~as.character(ano), nrow = 2, ncol = 3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.9))+
  geom_label(aes(label=round(proporcao,2)))+
  labs(x='Ano', 
       y='',
       title="",
       subtitle = "",
       caption='')

```

```{r, results='asis', warning=FALSE, message=FALSE}

ggplot(bpn_grafico_prop, aes(x=ano, y=proporcao))+
  geom_line(aes(color=RACACORMAE),size=1)+
  theme_bw()+
  theme(#legend.position = "right",
    legend.title = element_blank(),
    plot.title = ggplot2::element_text(face = "bold"),
    plot.subtitle = ggplot2::element_text(face = "italic"),
    legend.text = ggplot2::element_text(face = "bold"))+
  geom_text(aes(label=round(proporcao,2)), size=3.8)+
  labs(x='Ano', 
       y='%',
       title="",
       subtitle = "",
       caption='Fonte: DATASUS - SINASC')

```

# Desvio padrão do peso e idade

```{r, results='asis', warning=FALSE, message=FALSE}

sd(selecao_nascimento$PESO, na.rm = TRUE)

```

```{r, results='asis', warning=FALSE, message=FALSE}

sd(selecao_nascimento$IDADEMAE, na.rm = TRUE)

```

```{r, warning=FALSE, message=FALSE}

selecao_nascimento %>%
  count(IDADEMAE > 50)

```

# Primeiro Modelo

```{r, warning=FALSE, message=FALSE}

modelo <- lm(PESO ~ IDADEMAE + as.integer(CONSPRENAT)+ ESCMAE + RACACORMAE + SEXO + ESTCIVMAE + GESTACAO, selecao_nascimento)

```

# Segundo modelo

```{r, warning=FALSE, message=FALSE}

modelo_final <- lm(PESO ~ IDADEMAE +
                     as.integer(CONSPRENAT) +
                     ESCMAE + 
                     RACACORMAE +
                     feminino + 
                     ESTCIVMAE + 
                     GESTACAO, selecao_nascimento)

```

# Terceiro modelo

```{r, warning=FALSE, message=FALSE}

modelo_final_negro <- lm(PESO ~ IDADEMAE +
                           as.integer(CONSPRENAT) +
                           ESCMAE + 
                           Parda +
                           Indigena +
                           Amarela +
                           Preta +
                           feminino + 
                           ESTCIVMAE + 
                           GESTACAO, selecao_nascimento)

stargazer::stargazer(modelo_final_negro, type="text")

```
# Quarto modelo

```{r, warning=FALSE, message=FALSE}

modelo_final_negro_binario <- lm(PESO ~ IDADEMAE +
                                   as.integer(CONSPRENAT) +
                                   ESCMAE + 
                                   Negro+
                                   feminino + 
                                   ESTCIVMAE + 
                                   GESTACAO, selecao_nascimento)

stargazer::stargazer(modelo_final_negro_binario, type="text")

```

# Análise de residuos

```{r, warning=FALSE, message=FALSE}

plot(fitted(modelo_final), residuals(modelo_final), 
     xlab="Valores Ajustados", 
     ylab="Resíduos")
abline(h=0, col = "red")

```

```{r, warning=FALSE, message=FALSE}

hist(residuals(modelo_final),
     main = "",
     xlab = "Resíduos",
     ylab = "Frequência",
     breaks = 1000)
lines(density(residuals(modelo_final)))

```

# Teste Breusch-Pagan

```{r, warning=FALSE, message=FALSE}

library(lmtest)
bptest(modelo_final)

```

# Tratamento dos resíduos - Erros robustos de White

```{r, warning=FALSE, message=FALSE}
library(car)
library(AER)

homoce.final <- hccm(modelo_final_negro, type=c('hc1'))
modelo.final<- coeftest(modelo_final_negro, homoce.final)
modelo.final

```

# Modelo com variavel pandemia

```{r, results='asis', warning=FALSE, message=FALSE}

modelo_pandemia <- lm(PESO ~ IDADEMAE +
                        as.integer(CONSPRENAT) +
                        pandemia +
                        ESCMAE + 
                        RACACORMAE +
                        feminino + 
                        ESTCIVMAE + 
                        GESTACAO, selecao_nascimento)

```

\newpage

```{r, results='asis', warning=FALSE, message=FALSE}

stargazer::stargazer(modelo, modelo_final, modelo_final_negro, modelo_pandemia,
                     font.size = 'tiny',
                     header = FALSE,
                     title="Resultados")
