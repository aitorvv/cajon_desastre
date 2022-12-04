<center>

# **Código en R**

</center>
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre)

</center>

---

Para configurar tu nuevo ordenador instalando las librerías que tenías en tu ordenador antiguo, basta con aplicar dos sencillos comandos. En tu ordenador antiguo, abre R y ejecuta lo siguiente para recopilar las librerías y versiones que tienes instaladas:
```
pkg.list <- installed.packages()[is.na(installed.packages()[ , "Priority"]), 1]
save(pkg.list, file="pkglist.Rdata")
```
De esta manera se recopilarán en ese archivo .RData. Ahora, en tu ordenador nuevo, basta con instalarlas para tener R configurado tal cual lo dejaste (ejecuta lo siguiente):
```
load("pkglist.Rdata")
install.packages(pkg.list)
```
Y con estos pasos ya tendrías todas las librerías de R instaladas. [Aquí](https://es.stackoverflow.com/questions/116203/de-que-forma-trasladar-todos-los-paquetes-de-r-de-una-instalaci%C3%B3n-a-otra) la fuente original.


Contenido:
- 3_axis_graph.R: plantilla para desarrollar gráficos de 3 ejes con ggplot2 / *a template to develop 3 axis graphs with ggplot2* - **spanish**
- qplot_intro: archivos .R, .Rmd, .pdf y .html (el mismo archivo) explicando los argumentos básicos de la función de R *qplot* (gráfico rápido, de la librería ggplot2) / *files .R, .Rmd, .pdf and .html (the same file) explaining basic arguments of the R function qplot (quick plot, from the library ggplot2)* - **spanish**
- read_pdf_content: carpeta con código para leer archivos .pdf y buscar las líneas donde aparece una determinada palabra / *folder with a code to read pdf files and find the lines where some words are written. It includes 2 pdf files as an example* - **english**
- simanfor: carpeta que contiene contenido relacionado con [SIMANFOR](https://www.simanfor.es/), simulador selvícola de gestión forestal / *folder with code related to [SIMANFOR](https://www.simanfor.es/), a forest simulator of silvicultural management* - **spanish**
- xlsx-json: carpeta que contiene el código que convierte archivos .xlsx en archivos .json y viceversa, en ambos casos manteniendo la estructura de los datos. Contiene datos de ejemplo / *folder with code that converts .xlsx files to .json files and .json files to .xlsx files, in both cases maintaining the structure. It includes example data* - **spanish**
- xlsx-yml: carpeta que contiene el código que convierte archivos .xlsx en .yml y viceversa, en ambos casos manteniendo la estructura de los datos. Incluye datos de ejemplo / *folder with code that converts .xlsx files to .yml files and .yml files to .xlsx files, in both cases maintaining the structure. It includes example data* - **spanish**
  
Otros recursos / *Other resources*:
- ggplot2 package resources: [1](https://cran.r-project.org/web/packages/ggplot2/index.html) / [2](https://ggplot2-book.org/)
- [plot function explanation](https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/plot)
- [qplot function explanation](https://github.com/aitorvv96/graficos_con_R)
- [R functions to plot](https://www.rdocumentation.org/search?q=plot)


---
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre) - [Aitor Vázquez Veloso](https://www.linkedin.com/in/aitorvazquezveloso)

</center>

