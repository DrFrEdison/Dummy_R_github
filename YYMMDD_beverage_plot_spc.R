# beverage parameter ####
setwd(this.path::this.dir())
dir( pattern = "_mtx_" )
source.file <- print(dir( pattern = "_mtx_" )[ length( dir( pattern = "_mtx_" ))])
source( paste0(getwd(), "/", source.file) )

# Plot functions for model spectra ####
setwd(dt$wd)
setwd("./Modellerstellung")
setwd(paste0("./", dt$para$model.raw.date[1], "_", dt$para$model.raw.pl[1]))
setwd("./Validierungsset")
setwd( dt$wd.valset <- getwd() )
setwd("..")
setwd("./spc")
setwd( dt$wd.mastermodel <- getwd() )

# read Q-xx-MTX ####
setwd("..")
require(openxlsx)

dir( pattern = "Q-xx-MTX-")
dt$qxxmtx <- c("Q-xx-MTX-00024-V01-00_Max_Lemon.xlsx", "Q-xx-MTX-00024-V01-00_Max_Lemon.xlsx")

dt$qxxmtx <- mtx_add( qxxmtx = dt$qxxmtx)
dt$qxxmtx$QXXMTX <- dt$qxxmtx$QXXMTX[ , 1:8]
dt$parameter <- dt$qxxmtx$parameter[1:6]
dt$qxxmtx <- dt$qxxmtx$QXXMTX

# find parameter in Q-xx-MTX ####
dt$parameter
dt$parameter <- c(dt$parameter, "FG")

# set validation parameter ####
dt$valparameter <- dt$parameter

# create directory structure for spc ####
mtx_folder(dt$wd.mastermodel, dt$parameter)
mtx_folder(dt$wd.valset, dt$parameter)

# move spectra from Tidas ####
mtx_move_spc( dir.source = wd$tidas
              , dir.target = dt$wd.mastermodel
              , parameter = dt$parameter
              , filter = "VAS"
              , filteron = T
              , SL = "SL")

# move spectra from Tidas VAS ####
mtx_move_spc( dir.source = wd$tidas
              , dir.target = dt$wd.valset
              , parameter = dt$parameter
              , filter = "VAS"
              , filteron = F
              , SL = "SL")

# Plot and write spc ####
mtx_plot_spc(dir = dt$wd.mastermodel
             , beverage = dt$para$beverage
             , parameter = NA
             , baseline = NA
             , pngplot = F
             , plotlyplot = T
             , recursive = T
             , filestext = NA
             , colp = NA
             , subfiles = NA
             , write = T)

# Plot and write subspectra ####
dt$parameter
for(i in 1 : length(dt$parameter) )
  # for(i in c(4))
  mtx_plot_spc(dir = dt$wd.mastermodel
               , beverage = dt$para$beverage
               , parameter = dt$parameter[ i ]
               , baseline = NA
               , pngplot = F
               , plotlyplot = T
               , recursive = T
               , filestext = NA
               , colp = NA
               , subfiles = NA
               , write = F)

# Plot and write VAS ####
mtx_plot_spc(dir = dt$wd.valset
             , beverage = dt$para$beverage
             , parameter = NA
             , baseline = NA
             , pngplot = F
             , plotlyplot = T
             , recursive = T
             , write = T)
