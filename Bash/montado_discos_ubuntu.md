1. Conectar el disco y obtener el UUID

Conecta tu disco duro externo.

Abre una terminal y ejecuta:

```
lsblk -f
```

Copia el UUID de la partición que quieres montar (no del disco completo, sino de la partición, ej. /dev/sdb1).



2. Crear la carpeta de montaje

Elige un punto de montaje fijo, por ejemplo dentro de /mnt o /media. Ejemplo:

```
sudo mkdir -p /media/mi_disco
```


3. Editar /etc/fstab

Edita el archivo con privilegios de administrador:

```
sudo nano /etc/fstab
```

Añade al final una línea con el formato (usa tabulador en los espacios):

```
UUID=1234-ABCD   /mnt/mi_disco   ext4   defaults,nofail   0   0
```

UUID=1234-ABCD → sustituir por el UUID real de tu disco.

/mnt/mi_disco → carpeta creada en el paso anterior.

ext4 → poner el tipo de sistema de archivos real (ej: ntfs, vfat, exfat, etc., según lo que viste en lsblk -f).

defaults,nofail → opciones de montaje. nofail evita que el sistema falle si el disco no está conectado.

4. Probar la configuración

Refresca la versión de fstab:

```
systemctl daemon-reload
```

Prueba a montar con:

```
sudo mount -a
```



-----------------------


1. Crear la carpeta .Trash-1000 en el disco

GNOME (y la mayoría de escritorios) usa una carpeta oculta en cada unidad montada para la papelera. El nombre depende del UID del usuario (normalmente 1000 en sistemas de escritorio).

Conecta y monta el disco.

Crea la carpeta:

```
mkdir -p /mnt/mi_disco/.Trash-1000/files
```

3. Verificar UID de tu usuario

Por si tu usuario no es el 1000, confirma con:

```
id -u
```

Si devuelve otro número, la carpeta debe llamarse .Trash-[ese número].

Por si tu grupo no es el 1000, confirma con:

```
id -g
```

Confirma el nombre de usuario ($USER) con:

```
whoami
```

Ajusta permisos para tu usuario (suponiendo que tu UID es 1000):

```
sudo chown -R $USER:$USER /mnt/mi_disco/.Trash-1000
chmod 700 /mnt/mi_disco/.Trash-1000
```

Esto hará que Nautilus pueda usar esa carpeta como "Papelera" en lugar de borrar directamente.

2. Montar con las opciones correctas

En tu entrada de /etc/fstab (o en el automontaje), asegúrate de que:

```
sudo nano /etc/fstab
```

Para NTFS con ntfs-3g:

```
UUID=1234-ABCD  /mnt/mi_disco  ntfs-3g  defaults,uid=1000,gid=1000,umask=000,nofail  0  0
```

Para exFAT:

```
UUID=1234-ABCD  /mnt/mi_disco  exfat  defaults,uid=1000,gid=1000,umask=022,nofail  0  0
```

Esto asegura que tu usuario sea el dueño de los archivos y pueda usar la papelera.
