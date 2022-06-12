#############################################################
# Transformación de un archivo xlsx a yml
# Aitor Vázquez Veloso
# Junio de 2022
# Fuente original: https://github.com/aitorvv96/cajon_desastre
# R Version: 4.2.0  -  File encoding: UTF-8
#############################################################

#### Pasos básicos ####

# directorio
setwd("")

#librerías

#install.packages("openxlsx")
library(openxlsx)
#install.packages("readxl")
library(readxl)


#### Archivo de origen y salida ####

input <- "example.xlsx"
file_sheets <- getSheetNames(input) # buscar todas las hojas de excel
last_value <- tail(file_sheets, n=1) # registrar última hoja

# crear el archivo de salida
output <- "output.json"
cat("{", file = output, sep = "\n")  

# escribir el contenido

for (sheet in file_sheets) {  # para cada hoja
  
  sheet_info <- read_excel(input, sheet = sheet, col_names = FALSE)  # lectura de la hoja
  
  intro_line <- paste('  "', sheet, sep = '')
  intro_line <- paste(intro_line, '": {', sep = '')
  cat(intro_line, file = output, append = TRUE, sep = "\n")  # encabezado

  for (i in 1:nrow(sheet_info)){  # para cada parámetro de la hoja

    line <- paste("    ", sheet_info[i,1], sep = '')    
    line <- paste(line, ": ", sep = '')
    line <- paste(line, sheet_info[i,3])
    
    cat(line, file = output, append = TRUE, sep = "\n")  # añadimos una l?nea
  }
  
  if(sheet != last_value){
  cat('  },', file = output, append = TRUE, sep = "\n")  # cierre del grupo de variables
  }
 
}

cat('  }', file = output, append = TRUE, sep = "\n")  # cierre de }
cat('}', file = output, append = TRUE, sep = "\n")  # cierre de }
