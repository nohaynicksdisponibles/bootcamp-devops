#!/bin/bash

#${#mi_array[@]}
#.........................................................................#.......................
#chmod +x asignar_usuarios.sh
#-------------------------------------------------------------------------#-----------------------

grupos=("Desarrollo" "Operaciones" "Ingenieria")
usuarios=("usuario1" "usuario2" "usuario3" "usuario4" "usuario5" "usuario6")
defaultPassword=123456

# Crear grupos
for grupo in "${grupos[@]}"
do
    groupadd $grupo
    logger "se agrego grupo $grupo al sistema"
done

# Crear usuarios y asignar contraseñas
for usuario in "${usuarios[@]}"
do
    useradd -m $usuario
    echo "$usuario:$defaultPassword" | sudo chpasswd
    chown $usuario /home/$usuario
    chmod 770 /home/$usuario
    logger "se agrego usuario $usuario al sistema, se puso un default password, se creo su carpeta en Home, se cambio el ownership a $usuario  y se modifican permisos a 770"
done

keptIndex=0

# Asignar usuarios a grupos
for grupo in "${grupos[@]}"
do
    firstAsignedName=${usuarios[keptIndex]}
    secondAsignedName=${usuarios[$((keptIndex+1))]}
    
    usermod -a -G $grupo $firstAsignedName
    usermod -a -G $grupo $secondAsignedName
    logger "se asignaron los usuarios $firstAsignedName y $secondAsignedName al grupo $grupo"
    keptIndex=$((keptIndex+2))
done
