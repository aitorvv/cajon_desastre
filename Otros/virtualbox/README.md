<center>

# **VirtualBox en Linux**

</center>
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre)

</center>

---

Mi ordenador tiene SO Linux (Ubuntu), pero para algunas tareas utilizo Microsoft Word por ser la plataforma "más popular" y evitarme problemas con el descolocado de contenidos de los archivos y demás. Para ello me he instalado una máquina virtual [VirtualBox](https://www.virtualbox.org/wiki/Downloads), me he descargado la iso de [Windows 11](https://www.microsoft.com/es-es/software-download/windows11), y he seguido este [tutorial](https://www.youtube.com/watch?v=9TaUw03h_sk&ab_channel=RetroTech) para hacer la instalación. Tras esto, he tenido algún problema del que dejo aquí la solución:
- Problema: *RTR3InitEx failed with rc=-1912 (fRtFlags=0x10000) (rc=-1912)*
  - Solución [aquí](https://askubuntu.com/questions/900794/virtualbox-rtr3initex-failed-with-rc-1912-rc-1912)
- Problema: *Kernel driver not installed (rc=-1908)*
  - Solución [aquí](https://ubuntinux.blogspot.com/2020/04/solucion-error-de-virtualbox-kernel.html) o [aquí](https://gacimartin.com/2019/04/15/modprobe-error-could-not-insert-vboxdrv-operation-not-permitted-where-suplibosinit-what-3-verr_vm_driver_not_installed-1908-the-support-driver-is-not-installed-on-linux-open-returned/)


Para que la máquina virtual reconozca un usb, entonces tendremos que hacer lo que recoge este [post](https://ubunlog.com/usb-habilitarlo-en-virtualbox/#Instalacion_de_VirtualBox_Extension_Pack) o este [otro](https://www.solvetic.com/tutoriales/article/4063-como-configurar-usb-maquina-virtual-virtualbox/). Además, en el tipo de controlador te recomiendo seleccionar *Controlador USB 3.0 (xHCI)* para asegurarte de que tu dispositivo lo va a reconocer.

Por otro lado, en ocasiones mi máquina virtual no muestra los símbolos de dispositivo, audio, usb... ya sabes, esos simbolitos tan característicos de la máquina virtual. Para solucionarlo, accede en tu máquina virtual a *Configuración* > *Interfaz de usuario* y cambia el estado de visualización de *escalado* a *normal* (por algún motivo en el modo escalado desaparecen).

[Aquí](https://www.virtualbox.org/wiki/Download_Old_Builds) puedes descargarte versiones anteriores de virtualbox y su correspondiente pack de extensiones.

---
<center>

[Cajón desastre](https://github.com/aitorvv96/cajon_desastre) - [Aitor Vázquez Veloso](https://www.linkedin.com/in/aitorvazquezveloso)

</center>

