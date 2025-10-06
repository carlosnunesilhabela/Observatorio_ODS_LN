#### FUNÇÃO: std_str - Standardização (retirada de caracteres especiais, numeros e uppercase)

std_str <- function(str2) {
  # FUNÇÃO std_str - Padronização dos caracteres
  str2 <- tolower(str2)                             # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
  str2 <- rm_accent(str2)                           # Remove todas acentuações 
  str2 <- str_replace_all(str2, "[^[:alnum:]]", "") # remove non alphanumeric characters
  return(str2)
} # FUNÇÃO: std_str - Padronização dos caracteres



