<center>

# **Recopilación de comandos bash**

</center>
<center>

[Cajón desastre](https://github.com/aitorvv/cajon_desastre)

</center>

---

# Copiar y pegar en el terminal de Linux:

Usa **Ctrl + Shift + C** para copiar.
 
Usa **Ctrl + Shift + V** para pegar.

# Consultar el directorio en el que nos encontramos:

```
pwd
```
---

# Consultar el tamaño de archivos y carpetas

### Tamaño total de la carpeta (incluyendo subcarpetas)

```
du -sh nombre_de_la_carpeta
```

### Listado detallado del tamaño de cada archivo y subcarpeta

```
du -ah nombre_de_la_carpeta
```

### istar los archivos más grandes en la carpeta y subcarpetas

```
du -ah nombre_de_la_carpeta | sort -rh | head -n 20
```

### Mostrar solo archivos (excluir directorios)

```
find nombre_de_la_carpeta -type f -exec du -h {} + | sort -rh | head -n 20
```

---

# Incluir una línea nueva en un archivo cuando se detecta un patrón, sea este una línea completa o una palabra

Para incluir tras la palabra "pattern" o bien una línea de texto que lo sustituya una nueva línea de código, se puede hacer utilizando el siguiente comando:

```
sed -i '/pattern/a\Your new line here' path/test.txt
```

# Reemplazar una cadena de texto por otra dentro de un archivo:

Para sustituir contenido de los archivos de una determinnada carpeta desde el terminal usa:

```
find /test/ -name "*.txt" -print | xargs sed -i "s/SYSADMIT/--SYSADMIT--/g"

```

ejemplo con ficheros .py y con ficheros .yml:

```
find /media/my_user/my_folder/ -name "*.py" -print | xargs sed -i "s/my_actual_string/my_new_string/g"
find /media/my_user/my_folder/ -name "*.yml" -print | xargs sed -i "s/my_actual_string/my_new_string/g"

```

Para sustituir el contenido de un archivo en concreto, desde el terminal, usa:

```
sed -i 's/texto-a-buscar/texto-a-reemplazar/g' "Fichero o directorio"
```

[Fuente](https://www.sysadmit.com/2015/07/linux-reemplazar-texto-en-archivos-con-sed.html)

---

# Buscar donde se encuentra una determinada palabra en un directorio:

```
grep -r "palabra"
```

---

# Para renombrar archivos...
Renombrar extensiones:

```
rename ‘s/.txt/.php/’ *.txt
```

Renombrar nombre archivos:

```
rename 'y/ /_/' *
```

---

# Pasar de mayúscula a minúscula y viceversa:

```
rename 'y/A-Z/a-z/' *
rename 'y/a-z/A-Z/' *
```

---

# Eliminar archivos desde el terminal Linux: 

Eliminar un único archivo de Linux

```
rm eliminame.odt
```

Eliminar varios archivos en Linux

```
rm eliminame.odt eliminame2.odt
```

Eliminar los archivos de Linux con un formato determinado

```
rm *eliminar*
```

Eliminar tipos de archivo determinados

```
rm *.odt
```

[Fuente](https://www.ionos.es/digitalguide/servidores/configuracion/eliminar-archivos-en-linux/)

---

# Problemas con "sudo apt-get update" -> NO_PUBKEY

Para resolver este problema debemos ir a **Software y actualizaciones :arrow_right: Otro software" y desactivar lo que nos esté dando problemas. A continuación podemos repetir el comando *sudo apt-get update*.

---

# Cuando tenemos paquetes retenidos con "sudo apt-get upgrade"

Cuando aplicamos *sudo apt-get upgrade* y tenemos paquetes retenidos como en el siguiente ejemplo:

```
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Calculando la actualización... Hecho
Los siguientes paquetes se han retenido:
  python3-update-manager update-manager update-manager-core
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 3 no actualizados.
```

debemos instalar los paquetes con la siguiente orden:

```
sudo apt-get install <lista de paquetes retenidos>
```

por ejemplo

```
sudo apt-get install python3-update-manager update-manager update-manager-core
```

y a continuación podemos actualizar todo de nuevo sin problemas usando

```
sudo apt-get update && sudo apt-get upgrade
```

---
<center>

[Cajón desastre](https://github.com/aitorvv/cajon_desastre) - [Aitor Vázquez Veloso](https://www.linkedin.com/in/aitorvazquezveloso)

</center>

