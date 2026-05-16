==========================
CentOS Stream 10 por NorTK
==========================
---------------------------------------
Live USB de CentOS Stream 10 para NorTK
---------------------------------------

Descripción
===========
Un recetario para poder generar imágenes ISO (Live y de Instalación) de CentOS Stream 10.


Pre-requisitos
==============
* Fedora 43 o CentOS Stream 10
* kiwi-ng
* GNU make
* qemu-kvm (para pruebas)


Instrucciones
=============
Para construir las imágenes, necesitarás poner estos archivos en un usuario con poderes de sudo.

Para instalar los paquetes necesarios, como root:

.. code-block:: sh

    # instalar requerimientos
    dnf -y install kiwi-cli make qemu-img qemu-kvm edk2-ovmf

Una vez instalados los paquetes, necesitamos crear un usuario normal con poderes de sudo:

.. code-block:: sh

    # agregar al usuario
    useradd renich

    # agregarlo al grupo de wheel
    usermod -aG wheel renich

Luego, te haces el usuario y te vas al directorio que contiene estos archivos y corres los siguientes comandos:

.. code-block:: sh

    # ir a donde está el código
    cd ~/src/cs10-nortk

Construcción
------------

.. code-block:: sh

    # construir el live ISO
    sudo make build-live

    # construir la imagen de disco (OEM/Instalación)
    sudo make build-disk

    # actualizar el archivo cdroot con el tema GRUB
    scripts/update-cdroot.bash

Pruebas
-------

Para probar las imágenes generadas, puedes usar los siguientes comandos de make.

Para la versión Live:

.. code-block:: sh

    make test-live

Para la versión de disco (Instalación):

.. code-block:: sh

    make test-disk

Nota: ``make test-disk`` creará automáticamente un disco virtual temporal de 20GB (``test-disk.qcow2``) y lo eliminará al finalizar la prueba.

Para seguir el proceso de construcción, en otra sesión, puedes usar: ``tail -F result-*/build/image-root.log`` en el directorio en donde iniciaste el proceso.

Limpieza
--------

Para limpiar los archivos temporales de construcción:

.. code-block:: sh

    sudo make clean

Para eliminar todos los resultados (incluyendo las imágenes ISO generadas):

.. code-block:: sh

    sudo make distclean

Tema GRUB
---------

La configuración de GRUB se gestiona de la siguiente manera:

- El Live ISO y el Disco utilizan plantillas de KIWI (``grub.cfg.iso-template``, ``grub.cfg.disk.iso-template``).
- Los activos del tema se encuentran en ``root/boot/grub2/themes/nortk/``.
- Después de realizar cambios en el tema, ejecuta ``scripts/update-cdroot.bash`` para actualizar los archivos en el área de construcción.

Resolución en Sistema Instalado (Workaround)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Debido a que KIWI-ng sobrescribe los valores predeterminados en ``/etc/default/grub`` durante la fase de creación del sistema, la resolución en el sistema instalado cae a ``auto`` (usualmente 1024x768). Para forzar la resolución a 1920x1080, utilizamos una solución alternativa (workaround) en ``root/etc/grub.d/01_nortk_theme``:

.. code-block:: sh

    # Re-initialize gfxterm to apply the new resolution
    echo "terminal_output console"
    echo "terminal_output gfxterm"

Esto obliga a GRUB a reiniciar la terminal gráfica y aplicar el valor de ``gfxmode`` que definimos previamente (1080p), evadiendo el valor predeterminado impuesto por KIWI. Hay un reporte oficial abierto *upstream* respecto a este problema: https://github.com/OSInside/kiwi/issues/2998

Previsualización del Tema
~~~~~~~~~~~~~~~~~~~~~~~~~

Para ver cómo se ve el tema de GRUB sin tener que construir toda la imagen, se recomienda usar ``grub2-theme-preview``.

**Instalación:**

.. code-block:: sh

    # 1. Instalar dependencias del sistema necesarias para generar la ISO de prueba
    sudo dnf install -y grub2-tools-extra xorriso qemu-kvm

    # 2. Instalar la herramienta vía pip
    pip install -U --user grub2-theme-preview

**Uso:**

.. code-block:: sh

    # Previsualizar el tema (asegúrate de que ~/.local/bin esté en tu PATH)
    grub2-theme-preview --add /boot/grub2/themes/nortk=$(pwd)/root/boot/grub2/themes/nortk \
        root/boot/grub2/themes/nortk

También puedes usar el atajo de make, que incluye la resolución recomendada:

.. code-block:: sh

    make theme-preview


Referencias
===========
* https://osinside.github.io/kiwi/
* https://youtu.be/RKeFR4R2IeA
* https://pagure.io/centos-kiwi-examples
