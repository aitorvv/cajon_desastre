#############################################################
# Desarrollo de un gráfico de densidad de 3 ejes con ggplot2
# Aitor Vázquez Veloso
# Septiembre de 2021
# Fuente original: https://github.com/aitorvv96/cajon_desastre
# R Version: 4.2.0  -  File encoding: UTF-8
#############################################################

# Directorio de trabajo
setwd("")

# Librerías
library(ggplot2)
library(scales)

# Variables necesarias  
Dg <- c(10:35)  # establecemos los rangos de diámetro medio cuadrático (cm)
Nmax <- exp(11.9358)*Dg^(-1.605)  # calculamos la densidad máxima

# Añadimos esta información y las líneas adicinales a un dataframe
df <- data.frame(Dg = c(10:35), Nmax = exp(11.9358)*Dg^(-1.605), N60<-0.60*Nmax, N35<-0.35*Nmax, N25<-0.25*Nmax)
# N60<-0.60*Nmax #lower limit or self-thinning 
# N35<-0.35*Nmax #lower limit of ‘full site occupancy’ 
# N25<-0.25*Nmax #On-set of competition (initial crown closure)

# Graficamos

# Fuentes:
# https://es.stackoverflow.com/questions/423811/eje-secundario-con-ggplot
# https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf


# Gráfico con ggplot2

# seleccionamos dataframe
ggplot(df) +  
        
        # ponemos las etiquetas que queramos al gráfico
        labs(title = "Comparación de SDI máximo actual (real) y con cambio climático (hipotético)",  # título
             #subtitle = "Subtítulo",  # subtítulo
             caption = "SDI = N(25/Dg)⁻¹ ⁶⁰⁵",  # pie de gráfico
             x = "Dg (cm)",  # eje x
             y = "Densidad (pies/ha)"  # eje y
             #tag = waiver()  # etiqueta en la parte superior izquierda del gráfico
        ) +
        
        # centrado de título
        theme(plot.title = element_text(hjust = 0.5, face = "bold")) +  # centrar título y ponerlo en negrita``
        
        # transformo los ejes a logaritmo y creo un eje secundario
        scale_x_continuous(trans = 'log') +  # transformación logarítmica del eje x 
        scale_y_continuous(trans = 'log',   # transformación logarítmica del eje y
                           labels = comma_format(digits = 0),  # sin decimales
                           sec.axis = sec_axis(~.*2,  # crear eje y'
                                               name = 'SDI',  # nombrar eje y'
                                               labels = comma_format(digits = 0))) +  # eliminar decimales

        # añado las líneas de datos
        geom_line(aes(x = Dg, y = Nmax), col='black') +
        geom_line(aes(x = Dg, y = N60), col='blue') +
        geom_line(aes(x = Dg, y = N35), col='darkgreen') +
        geom_line(aes(x = Dg, y = N25), col='red') +
        
        # añado puntos de datos
        #geom_point(aes(x = Dg, y = Nmax), col='black') +
        #geom_point(aes(x = Dg, y = N60), col='blue') +
        #geom_point(aes(x = Dg, y = N35), col='darkgreen') +
        #geom_point(aes(x = Dg, y = N25), col='red') +
        
        # incluyo las líneas guía del eje x        
        geom_vline(xintercept = 15, col="grey", lty = 4) +
        geom_vline(xintercept = 20, col="grey", lty = 4) +        
        geom_vline(xintercept = 25, col="grey", lty = 4) +
        geom_vline(xintercept = 30, col="grey", lty = 4) +
        geom_vline(xintercept = 35, col="grey", lty = 4) +
        
        # incluyo las líneas guía del eje y
        geom_hline(yintercept = 200, col="grey", lty = 4) +        
        geom_hline(yintercept = 500, col="grey", lty = 4) +
        geom_hline(yintercept = 1000, col="grey", lty = 4) +
        geom_hline(yintercept = 1500, col="grey", lty = 4) +
        
        # incluyo el texto en las posiciones del gráfico que quiero
        annotate("text", x = 20, y = 1400, col = "black", label = "SDImax") +
        annotate("text", x = 22.5, y = 750, col = "blue", label = "60% SDImax") +
        annotate("text", x = 25, y = 375, col = "darkgreen", label = "35% SDImax") +
        annotate("text", x = 27.5, y = 150, col = "red", label = "25% SDImax") 
        