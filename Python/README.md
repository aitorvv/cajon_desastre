<center>

# **Código Python para ser utilizado en local o en Colab**

</center>
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre)

</center>

---

Para configurar tu nuevo ordenador instalando las librerías que tenías en tu ordenador antiguo, basta con aplicar dos sencillos comandos. En tu ordenador antiguo, ejecuta lo siguiente (en el terminal) para recopilar las librerías y versiones que tienes instaladas:
```
pip list > python_packages.txt
```
De esta manera se recopilarán en ese archivo .txt. Ahora, en tu ordenador nuevo, basta con instalarlas para tener Python configurado tal cual lo dejaste (escribe esto en el terminal):
```
pip install -r python_packages.txt
```
Y con estos pasos ya tendrías todas las librerías instaladas.


Contenido:
* **colab_basicos.ipynb**: comandos básicos para leer y exportar datos de Colab / *basic comands to read and export data from Colab* - **english**
* **crear_QRcode.py**: código para crear un código QR a partir de un enlace web / *code useful to create a QR image from an url* - **spanish**
* **get_GEE_images.ipynb**: código para descargar imágenesde satélite MDT, Sentinel-1 y Sentinel-2 de Google Earth Engine utilizando Colab / *code to download MDT, Sentinel-1 and Sentinel-2 satellite images from Google Earth Engine with Colab* - **english**
* **manage_tasks_on_GEE.ipynb**: comandos básicos para utilizar Google Earth Engine en Colab / *basic comands to use Google Earth Engine in Colab* - **english**
* **split_csv.ipynb**: código para dividir un archivo .csv en archivos más pequeños en una carpeta de Google Drive utilizando Colab / *code to divide a .csv file into smaller files on a Google Drive folder with Colab* - **english**
* **split_csv.py**: código para dividir un archivo .csv en archivos más pequeños. Ejecútalo, introduce la ruta de tu archivo .csv y el número de filas máxima de cada archivo para hacerlo funcionar / *code to divide a csv file into smaller files. Execute it and enter the path of the .csv file you want to split and the number of rows of the split files* - **english** 
  - *en Linux:*
```
python3 split_csv.py
Paste here the path of your csv file: ./Descargas/test.csv
How many rows do you want to obtain per file?: 5
```
  the result is 3 different files with the names test_1_5.csv / test_6_10.csv / test_11_12.csv with their corresponding contents
* **youtube_downloads.ipynb**: código para descargar un vídeo o una playlist de Youtube utilizando Colab / *code to download a Youtube video or playlist by using Colab* - **english**
* **yt_download_playlist.py**: código python para descargar una lista de reproducción de Youtube en local / *code to download a Youtube playlist from local* - **english**
* **yt_download_video.py**: código python para descargar un vídeo de Youtube en local / *code to download a Youtube video from local* - **english**

---
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre) - [Aitor Vázquez Veloso](https://www.linkedin.com/in/aitorvazquezveloso)

</center>

