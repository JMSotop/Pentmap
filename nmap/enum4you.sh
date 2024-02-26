#!/bin/bash

# Coloricos :)
rojo="\e[1;31m"
verde="\x1b[0;32m"
amarillo="\e[1;33m"
azul="\e[1;34m"
morado="\e[1;35m"
cian="\e[1;36m"
blanco="\e[1;37m"




echo Puertos abiertos > PuertosAbiertos.txt

# Escaneo de puertos
read -p "Introduzca la URL o IP: " url

echo -e "${azul}[+] Escaneando los puertos en $url${azul}"

nmap "$url" > /home/kali/Documents/nmap/Escaneo.txt

echo -e "${azul}[+] Puertos abiertos:${azul}"

# Archivo para almacenar los puertos abiertos
puertos_abiertos="/home/kali/Documents/nmap/PuertosAbiertos.txt"

# Función para imprimir y guardar puertos abiertos
imprimir_puerto() {
    if grep -q "$1/tcp" /home/kali/Documents/nmap/Escaneo.txt 2>/dev/null; then
        echo -e "${verde}[+] Puerto $1 abierto (${2})${verde}"
        echo "$1/tcp - $2" >> "$puertos_abiertos"
    else
        echo -e "${rojo}[-] Puerto $1 cerrado${rojo}"
    fi
}

imprimir_puerto 20 "FTP - Datos"
imprimir_puerto 21 "FTP - Control"
imprimir_puerto 22 "SSH"
imprimir_puerto 25 "SMTP"
imprimir_puerto 53 "DNS"
imprimir_puerto 80 "HTTP"
imprimir_puerto 123 "NTP"
imprimir_puerto 179 "BGP"
imprimir_puerto 443 "HTTPS"
imprimir_puerto 500 "ISAKMP"
imprimir_puerto 587 "SMTP Seguro"
imprimir_puerto 3389 "RDP"

echo -e "${blanco}[+] Escaneo completado${blanco}"
echo -e "${blanco}[+] Puertos abiertos guardados en $puertos_abiertos${blanco}"

# Escaneo de vulnerabilidades
echo -e "${azul}[+] Escaneando vulnerabilidades${azul}"


Escaneo_puertos() {
    while read -r line; do
        puerto=$(echo "$line" | cut -d' ' -f1 | awk -F' |/' '{print $1}')
        servicio=$(echo "$line" | cut -d' ' -f3-)

        # Para saber si no esta vacio
        if [ -n "$puerto" ]; then
            echo -e "${azul}[+] Escaneando vulnerabilidades en el puerto $puerto (${servicio})${azul}"

            nmap --script "vuln" -p"$puerto" "$url"

            echo -e "${verde}[+] Vulnerabilidades escaneadas con éxito en el puerto $puerto (${servicio})${verde}"
        else
		echo "${rojo}${rojo}"
        fi
    done < "$puertos_abiertos"
}

Escaneo_puertos
echo $puerto
