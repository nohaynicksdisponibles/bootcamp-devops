#!/bin/bash

# Detectar y actualizar el sistema
if which apt > /dev/null 2>&1; then
    echo "Gestor de paquetes: apt (Debian/Ubuntu)"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y apache2
elif which yum > /dev/null 2>&1; then
    echo "Gestor de paquetes: yum (Red Hat/CentOS)"
    sudo yum update -y && sudo yum upgrade -y
    sudo yum install -y httpd
elif which dnf > /dev/null 2>&1; then
    echo "Gestor de paquetes: dnf (Fedora)"
    sudo dnf update -y && sudo dnf upgrade -y
    sudo dnf install -y httpd
elif which pacman > /dev/null 2>&1; then
    echo "Gestor de paquetes: pacman (Arch Linux)"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm apache
elif which zypper > /dev/null 2>&1; then
    echo "Gestor de paquetes: zypper (openSUSE)"
    sudo zypper refresh && sudo zypper update -y
    sudo zypper install -y apache2
else
    echo "Gestor de paquetes no reconocido."
    exit 1
fi

# Modificar el archivo index.html
WEB_ROOT=""
if [ -d "/var/www/html" ]; then
    WEB_ROOT="/var/www/html"
elif [ -d "/srv/http" ]; then
    WEB_ROOT="/srv/http"
elif [ -d "/usr/share/nginx/html" ]; then  # En caso de que alguna configuración personalizada lo utilice
    WEB_ROOT="/usr/share/nginx/html"
else
    echo "No se encontró el directorio raíz de documentos web de Apache."
    exit 1
fi

sudo bash -c "cat > ${WEB_ROOT}/index.html" <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bootcamp DevOps</title>
</head>
<body>
<h1>Bootcamp DevOps Engineer</h1>
</body>
</html>
EOL

echo "El archivo index.html ha sido modificado con éxito."

# Habilitar y arrancar el servicio de Apache después de la modificación del archivo
if which systemctl > /dev/null 2>&1; then
    sudo systemctl enable apache2 || sudo systemctl enable httpd
    sudo systemctl start apache2 || sudo systemctl start httpd
elif which service > /dev/null 2>&1; then
    sudo service apache2 start || sudo service httpd start
else
    echo "No se pudo arrancar el servicio de Apache automáticamente."
fi
