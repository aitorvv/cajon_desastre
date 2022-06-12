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

#install.packages("rjson")
library(rjson)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("openxlsx")
library(openxlsx)
#install.packages("RJSONIO")
library(RJSONIO)


#### Archivo de origen ####

# seleccionar el archivo que queremos transformar

input <- "example.json"
myList = rjson::fromJSON(file = input)  # si no funciona este comando, usar el siguiente
myList = RJSONIO::fromJSON(input)


#### Archivo de salida ####

wb <- createWorkbook() # original
counter = 1  # parámetro control

for (list in myList){ # cada list es una hoja de excel

  sheet <- names(myList[counter]) # hoja en la que quiero escribir
  counter <- counter + 1
  addWorksheet(wb=wb, sheetName = sheet)
  
  # crear un dataframe por página de excel y grupo de json
  data <- data.frame()
  titulos <- names(list)
  count = 1

  for (j in list){  # para cada línea (valor)
  
    linea <- paste('"', titulos[count], sep = '')  # construyo el texto
    linea <- paste (linea, j, sep = '"::: "')
    linea <- paste(linea, '"', sep = '')
    
    data <- rbind(data, linea) # esto es lo que tengo que escribir en la hoja correspondiente
    count <- count + 1
    
    colnames(data)[1] = "column_1"  # divido el texto en 2 columnas
    data <- separate(data = data, col = "column_1", into = c("left", "right"), sep = ":::", remove = FALSE)
    
    data$right <- paste(data$right, ",", sep = '')  # añado la coma final, excepto para la última línea
    last_line <- nrow(data)
    data$right[last_line] <- str_replace(data$right[last_line], ",", "")
    
  }
  
  writeData(wb, sheet = sheet, data[2], startCol = 1, colNames = FALSE)  # escribo el excel
  writeData(wb, sheet = sheet, data[3], startCol = 2, colNames = FALSE)
  writeData(wb, sheet = sheet, data[3], startCol = 3, colNames = FALSE)
  
}

# guardar el archivo de salida
saveWorkbook(wb, "example.xlsx", overwrite = TRUE)
