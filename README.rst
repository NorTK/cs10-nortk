==========================
CentOS Stream 10 por NorTK
==========================
---------------------------------------
Live USB de CentOS Stream 10 para NorTK
---------------------------------------

Descripción
===========
Un recetario para poder generar una "live ISO" de CentOS Stream 10.


Pre-requisitos
==============
* Fedora 43 o CentOS Stream 10
* kiwi-ng
* GNU make


Instrucciones
=============
Para construir la live USB, necesitarás poner estos archivos en un usuario con poderes de sudo.

Para instalar los paquetes necesarios, como root:

.. code-block:: sh

    # instalar requerimientos
    dnf -y install kiwi-cli make

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

    # construir el live ISO
    sudo make build-live

Para seguir el proceso de instalación, en otra sesión, puedes usar: ``tail -F result-*/build/image-root.log`` en el directorio en
donde iniciaste el proceso.


Referencias
===========
* https://osinside.github.io/kiwi/
* https://youtu.be/RKeFR4R2IeA
* https://pagure.io/centos-kiwi-examples

