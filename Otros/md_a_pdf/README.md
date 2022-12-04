<center>

# **Transformar un documento con extensión .md a .pdf en Linux**

</center>
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre)

</center>

---

Elaborar un documento explicativo puede resultar suficientemente vistoso en formato *.md*, especialmente si está destinado a ser utilizado en plataformas como GitHub, que permiten su visualización de manera sencilla. No obstante, a pesar de ser una buena herramienta, puede ser un formato poco amigable y desconocido para según qué tipo de usuarios.  

Para resolver esta situación y agradar a las dos partes, una solución es transformar estos archivos *.md* en *.pdf*, formato con el que cualquier usuario está familiarizado y que puede visualizarse de manera sencilla. En Linux, esta transformación se resuelve con tan solo dos líneas en el terminal:

```
pip install grip  
grip your_markdown.md
```

Donde *your_markdown.md* es el archivo que queremos transformar a *.pdf*.

Estos dos comandos nos permitirán instalar *grip* y abrir el documento en nuestro navegador por defecto, de tal manera que para verlo tan solo tenemos que acceder a http://localhost:5000/ desde nuestro navegador, donde se visualizará el documento. Esto nos permitirá hacer los cambios necesarios en nuestro archivo *.md*, referescar el navegador para ver los cambios, e imprimir el documento en *.pdf* de la misma manera que lo haríamos con cualquier página web (Opciones>Imprimir>PDF).
 
Más información [aquí](https://superuser.com/questions/689056/how-can-i-convert-github-flavored-markdown-to-a-pdf)


---
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre) - [Aitor Vázquez Veloso](https://www.linkedin.com/in/aitorvazquezveloso)

</center>

