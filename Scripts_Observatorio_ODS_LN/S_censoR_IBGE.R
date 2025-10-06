# install from CRAN
install.packages("censobr")

# or use the development version with latest features
utils::remove.packages('censobr')
remotes::install_github("ipeaGIT/censobr", ref="dev")
library(censobr)
Basic usage
The package currently includes 6 main functions to download & read census data:
  
read_population()
read_households()
read_mortality()
read_families()
read_emigration()
read_tracts()

pop <- read_population()


