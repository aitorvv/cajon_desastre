#------------------------------------------------------------------------------------------#
####               Graficar resultados de SIMANFOR con ggplot2 - ejemplos               ####
#                                                                                          #
#                            Aitor V�zquez Veloso, 31/03/2022                              #
#            Fuente original: https://github.com/aitorvv96/cajon_desastre                  #
#                 R Version: 4.2.0  -  File encoding: WINDOWS-1252                         #
#------------------------------------------------------------------------------------------#



#### Resumen ####


# A lo largo de este documento seguiremos unos pasos sencillos para realizar gr�ficos con los resultados obtenidos de SIMANFOR

# Este documento tiene dos partes principales:
# - la primera parte permite hacer una adaptaci�n de los datos para ver la evoluci�n de nuestra masa forestal a lo largo del
#   escenario selv�cola. El resultado gr�fico es la evoluci�n de la masa que tenemos en nuestro monte, sin tener en cuenta la que
#   extraemos con las cortas
# - la segunda parte permite hacer una adaptaci�n de los datos para ver la cantidad de madera acumulada a lo largo de los escenarios
#   selv�colas. El resultado gr�fico es la cantidad de madera total que obtenemos de nuestra masa, incluyendo la extra�da con las cortas

# Si ya has utilizado R anteriormente, entonces puedes saltar al siguiente apartado, pero si eres nuevo, d�jame que te explique:
# - las l�neas como esta, que empiezan con un "#", son comentarios. R no los interpreta, lo que permite escribir todo lo que quieras sin 
#   temor a tener errores en el c�digo.
# - las l�neas que NO comienzan con # son las l�neas de c�digo que se ejecutan. Debes ir ejecutando una a una, revisando en los 
#   comentarios si es necesario hacer alg�n cambio en tu c�digo
# - R tiene algunas funciones integradas por defecto, pero necesitaremos funciones extra (llamadas librer�as), que nos permitan
#   tener otras utilidades m�s avanzadas, como por ejemplo hacer gr�ficos complejos
# - lee los comentarios que he ido poniendo durante el script para saber qu� haces en casa paso



#### Pasos b�sicos ####


### librer�as

# si no tienes las siguientes librer�as instaladas, entonces ejecuta las 5 l�neas siguientes para hacerlo
install.packages('plyr')
install.packages('dplyr')
install.packages('ggplot2')
install.packages("tidyverse")
install.packages("readxl")

# una vez instaladas, vamos a cargarlas en R para poder utilizarlas
library(readxl)
library(plyr)
library(dplyr)
library(ggplot2)
library(tidyverse)


### establecer directorio de trabajo

# el directorio de trabajo es la carpeta de tu ordenador donde tienes los RESULTADOS obtenidos de SIMANFOR y sobre el que trabajaremos
# Copia dicha ruta a continuaci�n entre las "", y aseg�rate de que en dicha carpeta SOLO tienes archivos con los RESULTADOS de la 
# simulaci�n (NO les cambies el nombre a los archivos, sino el script te dar� errores)
general_dir <- "escribe aqu� la ruta a tu carpeta SIN ESPACIOS"
# �ATENCI�N! Debes cambiar las \ de la ruta por /, sino obtendr�s un error; ning�n nombre de carpeta debe tener un espacio, de ser as�, cambia el nombre de tu carpeta

setwd(general_dir)  # ahora establecemos la ruta anterior como directorio de trabajo



#### Importar informaci�n de los resultados de SIMANFOR ####


# en este apartado vamos acceder a todos los archivos de resultados de SIMANFOR, extrayendo su informaci�n
# para ello, vamos a hacer un bucle "for": https://r-coder.com/for-en-r/
# esto nos permitir� recorrer todos los archivos, y con c�digo auxiliar importaremos la informaci�n que queremos en R

plots <- data.frame()  # variable que contendr� la informaci�n de parcelas
directory <- list.dirs(path = ".")  # variable que contendr� los nombres de las subcarpetas

for (folder in directory){  # para cada carpeta dentro del directorio...
        
        # generamos una subcarpeta y la establecemos como directorio actual
        specific_dir <- paste(general_dir, "substract", folder, sep = "")
        specific_dir <- gsub("substract.", "", specific_dir)
        setwd(specific_dir)
        
        # extraemos el nombre de los archivos .xlsx (OJO, aseg�rate de que solo tienes ah� los resultados de SIMANFOR)
        files_list <- list.files(specific_dir, pattern="xlsx")
        
        # ahora accedemos a cada uno de los archivos...
        for (doc in files_list) {
                
                plot_data <- read_excel(doc, sheet = "Parcelas")  # leemos la informaci�n de la hoja "Parcelas"
                
                plot_data$Nombre_fichero_origen <- doc  # creamos una columna en donde a�adimos el nombre del archivo

                # a�adimos la informaci�n a la variable "plots"
                ifelse(length(plots) == 0, plots <- rbind(plot_data), plots <- rbind(plots, plot_data))
        }
}



#### Manejo de datos inicial - evoluci�n de la masa ####


# ahora que ya tenemos los datos de SIMANFOR en R, vamos a trabajar un poco con ellos
df <- plots  # vamos a copiar los datos para conservar los orginales


# las edades de las parcelas son muy diferentes, por lo que, para simplificar, vamos a agruparlas en grupos de edad de 5 a�os
redondeo <- function(x, base){  # esta funci�n nos permitir� redondear la edad de la masa a m�ltiplos de 5 a�os
        base * round(x/base)
}                                 
df$T <- redondeo(df$T, 5)  # utilizamos la funci�n anterior


df <- df[!df$Accion == "Carga Inicial", ]  # la primera l�nea de datos no es necesaria, as� que vamos a eliminarla


# para identificar cada uno de los escenarios, vamos a extraer el n� de escenario y crear una columna con su valor

## OJO, ejecuta solo en comando correcto en los siguientes:
df$n_scnr <- substr(df$Nombre_fichero_origen, 38, 39)  # ejemplo de calidad de estaci�n
df$n_scnr <- substr(df$Nombre_fichero_origen, 0, 4)  # ejemplo de distintos escenarios



#### C�lculo de la evoluaci�n promedio de las parcelas para cada escenario ####


# si has introducido en R informaci�n de varias parcelas, la siguiente parte del c�digo te permitir� hacer la media para 
# algunos de los valores m�s importantes a nivel de parcela


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
# OJO! Abre tus datos y mira qu� clasificaci�n de productos tiene el modelo que has utilizado
# En el segundo grupo de c�lculo puedes activar algunos productos que aparecen silenciados por defecto, hazlo si tienes los datos
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-

mean_evo_by_scnr <- ddply(df, c('n_scnr', 'T'), summarise,  # agrupamos la informaci�n por n� de escenario y edad de parcela

                          # ahora calcularemos algunas variables generales...                          
                          N = mean(N, na.rm = TRUE),  # calculamos la densidad media                    
                          dg = mean(dg, na.rm = TRUE),  # di�metro medio cuadr�tico
                          Ho = mean(Ho, na.rm = TRUE),  # altura dominante
                          V = mean(V_con_corteza, na.rm = TRUE),  # volumen
                          WT = mean(WT, na.rm = TRUE),  # biomasa total
                          G = mean(G, na.rm = TRUE),  # �rea basim�trica
                          
                          # y la clasificaci�n de productos
                          #V_desenrollo = mean(V_desenrollo, na.rm = TRUE),  # volumen desenrollo
                          #V_chapa = mean(V_chapa, na.rm = TRUE),  # volumen chapa
                          V_sierra_gruesa = mean(V_sierra_gruesa, na.rm = TRUE),  # volumen sierra gruesa
                          V_sierra = mean(V_sierra, na.rm = TRUE),  # volumen sierra
                          V_sierra_canter = mean(V_sierra_canter, na.rm = TRUE),  # volumen sierra c�nter
                          #V_postes = mean(V_postes, na.rm = TRUE),  # volumen postes
                          #V_estacas = mean(V_estacas, na.rm = TRUE),  # volumen estacas
                          V_trituracion = mean(V_trituracion, na.rm = TRUE)  # volumen trituracion
)



#### Graficar resultados - Densidad y �rea basim�trica de la masa ####


## Ahora que ya tenemos los datos que necesitamos, vamos a hacer unos gr�ficos que nos muestren la evoluci�n de la parcela 
## bajo distintos escenarios selv�colas. Para ello utilizaremos la librer�a ggplot2



# Densidad de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = N,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n de la densidad de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Densidad (pies/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos



# �rea basim�trica de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = G,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
        
       # ponemos las etiquetas   
       labs(title = "Evoluci�n del �rea basim�trica de la masa",  # t�tulo
             # subtitle = "",  # subt�tulo
             x = "Edad de la masa (a�os)",  # eje x
             y = "�rea basim�trica (m2/ha)"  # eje y 
        ) +
        
        # modificamos las etiquetas
        theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                      hjust=0.5),  # centramos t�tulo
              plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                         hjust=0.5),  # centramos subt�tulo
              axis.title = element_text(size = 15),  # tama�o ejes
              legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
              legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
              
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda

        # y dibujamos lo datos
        geom_point() +  # nube de puntos
        #geom_smooth(method='lm', )  # regresi�n lineal
        geom_line()  # l�nea uniendo puntos



# �rea basim�trica del �rbol

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = G/N,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del �rea basim�trica del �rbol promedio",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad del �rbol (a�os)",  # eje x
       y = "�rea basim�trica (m2)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos



#### Graficar resultados - Vol�menes comerciales de la masa ####

## Antes de lanzarte a hacer los gr�ficos, revisa qu� variables tienes disponibles en tus resultados


# Volumen de desenrollo de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_desenrollo,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de desenrollo de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen desenrollo (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de chapa de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_chapa,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de chapa de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen chapa (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de sierra gruesa de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_sierra_gruesa,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de sierra gruesa de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen sierra gruesa (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de sierra c�nter de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_sierra_canter,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de sierra c�nter de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen sierra c�nter (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de sierra de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_sierra,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de sierra de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen sierra (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de postes de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_postes,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de postes de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen postes (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de estacas de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_estacas,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de estacas de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen estacas (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos


# Volumen de trituraci�n de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = T, y = V_trituracion,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evoluci�n del volumen de trituraci�n de la masa",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "Edad de la masa (a�os)",  # eje x
       y = "Volumen trituraci�n (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresi�n lineal
  geom_line()  # l�nea uniendo puntos



#### Manejo de datos inicial - madera acumulada ####

## para este caso, vamos a trabajar con el volumen total y el �rea basim�trica
## para ello, ver�s que repetimos los mismos c�lculos para las dos variables

df_2 <- plots  # reutilizo los datos iniciales

cortas <- filter(df_2, Accion == "Corta")  # extraigo informaci�n de las cortas
crecimientos <- filter(df_2, Accion == "Ejecuci�n")  # extraigo informaci�n de los crecimientos

# me quedo �nicamente con el valor del �ltimo crecimiento
crecimiento_final <- crecimientos[crecimientos$Edad_de_escenario == max(crecimientos$Edad_de_escenario), ]

cortas <- filter(cortas, !is.na(V_extraido))  # elimino procesos de corta en los que no se extrae nada
cortas <- filter(cortas, V_extraido != 0)  # elimino procesos de corta en los que no se extrae nada

# calculo el volumen y �rea basim�trica de la corta en cada proceso
cortas$v_cortado <- cortas$V_con_corteza * cortas$V_extraido / (100 - cortas$V_extraido) 
cortas$g_cortada <- cortas$G * cortas$G_extraida / (100 - cortas$G) 

# sumo los datos de las cortas
cortas <- ddply(cortas, c('Nombre_fichero_origen'), summarise,  # agrupo filas por c�digo de escenario
              v_cortado_sum = sum(v_cortado, na.rm = TRUE),  # sumo el volumen cortado en cada parcela
              g_cortada_sum = sum(g_cortada, na.rm = TRUE),  # sumo el �rea basim�trica cortada en cada parcela
)  

# uno ambas bases de datos, cortas y ejecuciones
final_plots <- merge(crecimiento_final, cortas, by = 'Nombre_fichero_origen', all = TRUE)

final_plots[is.na(final_plots)] <- 0  # para evitar celdas vac�as, le doy a estas el valor 0 (evitar errores de c�lculo)
final_plots$Vfinal <- final_plots$V_con_corteza + final_plots$v_cortado_sum  # calculo el volumen final (cortado y en pie)
final_plots$Gfinal <- final_plots$G + final_plots$g_cortada_sum  # calculo el �rea basim�trica final (cortado y en pie)

# para identificar cada uno de los escenarios, vamos a extraer el n� de escenario y crear una columna con su valor

## OJO, ejecuta solo en comando correcto en los siguientes:
final_plots$Escenario <- substr(final_plots$Nombre_fichero_origen, 38, 39)  # ejemplo de calidad de estaci�n
final_plots$Escenario <- substr(final_plots$Nombre_fichero_origen, 0, 4)  # ejemplo de calidad de estaci�n

# calculamos ahora el promedio, por escenario, de volumen y �rea basim�trica acumulada
mean_acum_by_scnr <- ddply(final_plots, c('Escenario'), summarise,  # agrupamos por c�digo de escenario
                           V_acum = mean(Vfinal, na.rm = TRUE),  # volumen acumulado por escenario
                           G_acum = mean(Gfinal, na.rm = TRUE))  # �rea basim�trica acumulada por escenario


#### Graficar resultados - �rea basim�trica y Volumen acumulado de la masa ####


# �rea basim�trica de la masa

ggplot(mean_acum_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = Escenario, y = G_acum,  # eje X e Y
           fill = Escenario)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "�rea basim�trica acumulada durante el escenario",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "",  # eje x 
       y = "�rea basim�trica (m2/ha)"  # eje y       
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # y dibujamos lo datos
  geom_bar(stat="identity")  # barras


# Volumen de la masa

ggplot(mean_acum_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selecci�n de variables
       aes(x = Escenario, y = V_acum,  # eje X e Y
           fill = Escenario)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Volumen acumulado durante el escenario",  # t�tulo
       # subtitle = "",  # subt�tulo
       x = "",  # eje x 
       y = "Volumen (m3/ha)"  # eje y       
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tama�o del t�tulo
                                hjust=0.5),  # centramos t�tulo
        plot.subtitle=element_text(size = 15,  # tama�o subt�tulo
                                   hjust=0.5),  # centramos subt�tulo
        axis.title = element_text(size = 15),  # tama�o ejes
        legend.title = element_text(size = 15),  # tama�o t�tulo leyenda
        legend.text = element_text(size = 12)) +  # tama�o contenido leyenda
  
  # y dibujamos lo datos
  geom_bar(stat="identity")  # barras
