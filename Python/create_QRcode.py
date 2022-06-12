#############################################################
# Crear un código QR con python
# Aitor Vázquez Veloso, junio de 2022
# Fuente original: https://github.com/aitorvv96/cajon_desastre
#############################################################

# Este es un código obtenido de https://mapecode.com/generar-codigo-qr-en-python/
# Sirve para crear un código QR de lo que se desee
# Es necesario instalar los paquetes qrcode y pillow

import qrcode
from PIL import Image

# Generar codigo QR:
cadena = input("Introduzca el texto para el codigo QR: ") # aquí se le pide al usuario la URL 
imagen = qrcode.make(cadena)

# Generar imagen:
nombre_imagen = input("Introduzca el nombre de la imagen: ") + '.png' # aquí se le da nombre a la imagen, y formato png en este caso
archivo_imagen = open(nombre_imagen, 'wb')
imagen.save(archivo_imagen)
archivo_imagen.close()

# Abrir imagen
ruta_imagen = './' + nombre_imagen # aquí se abre el códigoQR generado
Image.open(ruta_imagen).show()
