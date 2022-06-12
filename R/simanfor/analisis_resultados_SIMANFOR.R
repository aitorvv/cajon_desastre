#------------------------------------------------------------------------------------------#
####               Graficar resultados de SIMANFOR con ggplot2 - ejemplos               ####
#                                                                                          #
#                            Aitor Vázquez Veloso, 31/03/2022                              #
#            Fuente original: https://github.com/aitorvv96/cajon_desastre                  #
#                 R Version: 4.2.0  -  File encoding: WINDOWS-1252                         #
#------------------------------------------------------------------------------------------#



#### Resumen ####


# A lo largo de este documento seguiremos unos pasos sencillos para realizar gráficos con los resultados obtenidos de SIMANFOR

# Este documento tiene dos partes principales:
# - la primera parte permite hacer una adaptación de los datos para ver la evolución de nuestra masa forestal a lo largo del
#   escenario selvícola. El resultado gráfico es la evolución de la masa que tenemos en nuestro monte, sin tener en cuenta la que
#   extraemos con las cortas
# - la segunda parte permite hacer una adaptación de los datos para ver la cantidad de madera acumulada a lo largo de los escenarios
#   selvícolas. El resultado gráfico es la cantidad de madera total que obtenemos de nuestra masa, incluyendo la extraída con las cortas

# Si ya has utilizado R anteriormente, entonces puedes saltar al siguiente apartado, pero si eres nuevo, déjame que te explique:
# - las líneas como esta, que empiezan con un "#", son comentarios. R no los interpreta, lo que permite escribir todo lo que quieras sin 
#   temor a tener errores en el código.
# - las líneas que NO comienzan con # son las líneas de código que se ejecutan. Debes ir ejecutando una a una, revisando en los 
#   comentarios si es necesario hacer algún cambio en tu código
# - R tiene algunas funciones integradas por defecto, pero necesitaremos funciones extra (llamadas librerías), que nos permitan
#   tener otras utilidades más avanzadas, como por ejemplo hacer gráficos complejos
# - lee los comentarios que he ido poniendo durante el script para saber qué haces en casa paso



#### Pasos básicos ####


### librerías

# si no tienes las siguientes librerías instaladas, entonces ejecuta las 5 líneas siguientes para hacerlo
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
# Copia dicha ruta a continuación entre las "", y asegúrate de que en dicha carpeta SOLO tienes archivos con los RESULTADOS de la 
# simulación (NO les cambies el nombre a los archivos, sino el script te dará errores)
general_dir <- "escribe aquí la ruta a tu carpeta SIN ESPACIOS"
# ¡ATENCIÓN! Debes cambiar las \ de la ruta por /, sino obtendrás un error; ningún nombre de carpeta debe tener un espacio, de ser así, cambia el nombre de tu carpeta

setwd(general_dir)  # ahora establecemos la ruta anterior como directorio de trabajo



#### Importar información de los resultados de SIMANFOR ####


# en este apartado vamos acceder a todos los archivos de resultados de SIMANFOR, extrayendo su información
# para ello, vamos a hacer un bucle "for": https://r-coder.com/for-en-r/
# esto nos permitirá recorrer todos los archivos, y con código auxiliar importaremos la información que queremos en R

plots <- data.frame()  # variable que contendrá la información de parcelas
directory <- list.dirs(path = ".")  # variable que contendrá los nombres de las subcarpetas

for (folder in directory){  # para cada carpeta dentro del directorio...
        
        # generamos una subcarpeta y la establecemos como directorio actual
        specific_dir <- paste(general_dir, "substract", folder, sep = "")
        specific_dir <- gsub("substract.", "", specific_dir)
        setwd(specific_dir)
        
        # extraemos el nombre de los archivos .xlsx (OJO, asegúrate de que solo tienes ahí los resultados de SIMANFOR)
        files_list <- list.files(specific_dir, pattern="xlsx")
        
        # ahora accedemos a cada uno de los archivos...
        for (doc in files_list) {
                
                plot_data <- read_excel(doc, sheet = "Parcelas")  # leemos la información de la hoja "Parcelas"
                
                plot_data$Nombre_fichero_origen <- doc  # creamos una columna en donde añadimos el nombre del archivo

                # añadimos la información a la variable "plots"
                ifelse(length(plots) == 0, plots <- rbind(plot_data), plots <- rbind(plots, plot_data))
        }
}



#### Manejo de datos inicial - evolución de la masa ####


# ahora que ya tenemos los datos de SIMANFOR en R, vamos a trabajar un poco con ellos
df <- plots  # vamos a copiar los datos para conservar los orginales


# las edades de las parcelas son muy diferentes, por lo que, para simplificar, vamos a agruparlas en grupos de edad de 5 años
redondeo <- function(x, base){  # esta función nos permitirá redondear la edad de la masa a múltiplos de 5 años
        base * round(x/base)
}                                 
df$T <- redondeo(df$T, 5)  # utilizamos la función anterior


df <- df[!df$Accion == "Carga Inicial", ]  # la primera línea de datos no es necesaria, así que vamos a eliminarla


# para identificar cada uno de los escenarios, vamos a extraer el nº de escenario y crear una columna con su valor

## OJO, ejecuta solo en comando correcto en los siguientes:
df$n_scnr <- substr(df$Nombre_fichero_origen, 38, 39)  # ejemplo de calidad de estación
df$n_scnr <- substr(df$Nombre_fichero_origen, 0, 4)  # ejemplo de distintos escenarios



#### Cálculo de la evoluación promedio de las parcelas para cada escenario ####


# si has introducido en R información de varias parcelas, la siguiente parte del código te permitirá hacer la media para 
# algunos de los valores más importantes a nivel de parcela


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
# OJO! Abre tus datos y mira qué clasificación de productos tiene el modelo que has utilizado
# En el segundo grupo de cálculo puedes activar algunos productos que aparecen silenciados por defecto, hazlo si tienes los datos
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-

mean_evo_by_scnr <- ddply(df, c('n_scnr', 'T'), summarise,  # agrupamos la información por nº de escenario y edad de parcela

                          # ahora calcularemos algunas variables generales...                          
                          N = mean(N, na.rm = TRUE),  # calculamos la densidad media                    
                          dg = mean(dg, na.rm = TRUE),  # diámetro medio cuadrático
                          Ho = mean(Ho, na.rm = TRUE),  # altura dominante
                          V = mean(V_con_corteza, na.rm = TRUE),  # volumen
                          WT = mean(WT, na.rm = TRUE),  # biomasa total
                          G = mean(G, na.rm = TRUE),  # área basimétrica
                          
                          # y la clasificación de productos
                          #V_desenrollo = mean(V_desenrollo, na.rm = TRUE),  # volumen desenrollo
                          #V_chapa = mean(V_chapa, na.rm = TRUE),  # volumen chapa
                          V_sierra_gruesa = mean(V_sierra_gruesa, na.rm = TRUE),  # volumen sierra gruesa
                          V_sierra = mean(V_sierra, na.rm = TRUE),  # volumen sierra
                          V_sierra_canter = mean(V_sierra_canter, na.rm = TRUE),  # volumen sierra cánter
                          #V_postes = mean(V_postes, na.rm = TRUE),  # volumen postes
                          #V_estacas = mean(V_estacas, na.rm = TRUE),  # volumen estacas
                          V_trituracion = mean(V_trituracion, na.rm = TRUE)  # volumen trituracion
)



#### Graficar resultados - Densidad y Área basimétrica de la masa ####


## Ahora que ya tenemos los datos que necesitamos, vamos a hacer unos gráficos que nos muestren la evolución de la parcela 
## bajo distintos escenarios selvícolas. Para ello utilizaremos la librería ggplot2



# Densidad de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = N,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución de la densidad de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Densidad (pies/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos



# Área basimétrica de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = G,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
        
       # ponemos las etiquetas   
       labs(title = "Evolución del área basimétrica de la masa",  # título
             # subtitle = "",  # subtítulo
             x = "Edad de la masa (años)",  # eje x
             y = "Área basimétrica (m2/ha)"  # eje y 
        ) +
        
        # modificamos las etiquetas
        theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                      hjust=0.5),  # centramos título
              plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                         hjust=0.5),  # centramos subtítulo
              axis.title = element_text(size = 15),  # tamaño ejes
              legend.title = element_text(size = 15),  # tamaño título leyenda
              legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
              
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda

        # y dibujamos lo datos
        geom_point() +  # nube de puntos
        #geom_smooth(method='lm', )  # regresión lineal
        geom_line()  # línea uniendo puntos



# Área basimétrica del árbol

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = G/N,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del área basimétrica del árbol promedio",  # título
       # subtitle = "",  # subtítulo
       x = "Edad del árbol (años)",  # eje x
       y = "Área basimétrica (m2)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos



#### Graficar resultados - Volúmenes comerciales de la masa ####

## Antes de lanzarte a hacer los gráficos, revisa qué variables tienes disponibles en tus resultados


# Volumen de desenrollo de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_desenrollo,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de desenrollo de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen desenrollo (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de chapa de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_chapa,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de chapa de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen chapa (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de sierra gruesa de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_sierra_gruesa,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de sierra gruesa de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen sierra gruesa (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de sierra cánter de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_sierra_canter,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de sierra cánter de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen sierra cánter (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de sierra de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_sierra,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de sierra de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen sierra (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de postes de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_postes,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de postes de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen postes (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de estacas de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_estacas,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de estacas de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen estacas (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos


# Volumen de trituración de la masa

ggplot(mean_evo_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = T, y = V_trituracion,  # eje X e Y
           group = n_scnr, colour = n_scnr)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Evolución del volumen de trituración de la masa",  # título
       # subtitle = "",  # subtítulo
       x = "Edad de la masa (años)",  # eje x
       y = "Volumen trituración (m3/ha)"  # eje y 
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # modificamos la leyenda
  scale_color_discrete('Escenario') +  # damos nombre a la leyenda
  
  # y dibujamos lo datos
  geom_point() +  # nube de puntos
  #geom_smooth(method='lm', )  # regresión lineal
  geom_line()  # línea uniendo puntos



#### Manejo de datos inicial - madera acumulada ####

## para este caso, vamos a trabajar con el volumen total y el área basimétrica
## para ello, verás que repetimos los mismos cálculos para las dos variables

df_2 <- plots  # reutilizo los datos iniciales

cortas <- filter(df_2, Accion == "Corta")  # extraigo información de las cortas
crecimientos <- filter(df_2, Accion == "Ejecución")  # extraigo información de los crecimientos

# me quedo únicamente con el valor del último crecimiento
crecimiento_final <- crecimientos[crecimientos$Edad_de_escenario == max(crecimientos$Edad_de_escenario), ]

cortas <- filter(cortas, !is.na(V_extraido))  # elimino procesos de corta en los que no se extrae nada
cortas <- filter(cortas, V_extraido != 0)  # elimino procesos de corta en los que no se extrae nada

# calculo el volumen y área basimétrica de la corta en cada proceso
cortas$v_cortado <- cortas$V_con_corteza * cortas$V_extraido / (100 - cortas$V_extraido) 
cortas$g_cortada <- cortas$G * cortas$G_extraida / (100 - cortas$G) 

# sumo los datos de las cortas
cortas <- ddply(cortas, c('Nombre_fichero_origen'), summarise,  # agrupo filas por código de escenario
              v_cortado_sum = sum(v_cortado, na.rm = TRUE),  # sumo el volumen cortado en cada parcela
              g_cortada_sum = sum(g_cortada, na.rm = TRUE),  # sumo el área basimétrica cortada en cada parcela
)  

# uno ambas bases de datos, cortas y ejecuciones
final_plots <- merge(crecimiento_final, cortas, by = 'Nombre_fichero_origen', all = TRUE)

final_plots[is.na(final_plots)] <- 0  # para evitar celdas vacías, le doy a estas el valor 0 (evitar errores de cálculo)
final_plots$Vfinal <- final_plots$V_con_corteza + final_plots$v_cortado_sum  # calculo el volumen final (cortado y en pie)
final_plots$Gfinal <- final_plots$G + final_plots$g_cortada_sum  # calculo el área basimétrica final (cortado y en pie)

# para identificar cada uno de los escenarios, vamos a extraer el nº de escenario y crear una columna con su valor

## OJO, ejecuta solo en comando correcto en los siguientes:
final_plots$Escenario <- substr(final_plots$Nombre_fichero_origen, 38, 39)  # ejemplo de calidad de estación
final_plots$Escenario <- substr(final_plots$Nombre_fichero_origen, 0, 4)  # ejemplo de calidad de estación

# calculamos ahora el promedio, por escenario, de volumen y área basimétrica acumulada
mean_acum_by_scnr <- ddply(final_plots, c('Escenario'), summarise,  # agrupamos por código de escenario
                           V_acum = mean(Vfinal, na.rm = TRUE),  # volumen acumulado por escenario
                           G_acum = mean(Gfinal, na.rm = TRUE))  # área basimétrica acumulada por escenario


#### Graficar resultados - Área basimétrica y Volumen acumulado de la masa ####


# Área basimétrica de la masa

ggplot(mean_acum_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = Escenario, y = G_acum,  # eje X e Y
           fill = Escenario)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Área basimétrica acumulada durante el escenario",  # título
       # subtitle = "",  # subtítulo
       x = "",  # eje x 
       y = "Área basimétrica (m2/ha)"  # eje y       
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # y dibujamos lo datos
  geom_bar(stat="identity")  # barras


# Volumen de la masa

ggplot(mean_acum_by_scnr,  # seleccionamos los datos a utilizar 
       
       # selección de variables
       aes(x = Escenario, y = V_acum,  # eje X e Y
           fill = Escenario)) +  # agrupamos por tipo de escenario, asignando un color distinto a cada uno
  
  # ponemos las etiquetas   
  labs(title = "Volumen acumulado durante el escenario",  # título
       # subtitle = "",  # subtítulo
       x = "",  # eje x 
       y = "Volumen (m3/ha)"  # eje y       
  ) +
  
  # modificamos las etiquetas
  theme(plot.title=element_text(size = 20,  # cambiamos el tamaño del título
                                hjust=0.5),  # centramos título
        plot.subtitle=element_text(size = 15,  # tamaño subtítulo
                                   hjust=0.5),  # centramos subtítulo
        axis.title = element_text(size = 15),  # tamaño ejes
        legend.title = element_text(size = 15),  # tamaño título leyenda
        legend.text = element_text(size = 12)) +  # tamaño contenido leyenda
  
  # y dibujamos lo datos
  geom_bar(stat="identity")  # barras
