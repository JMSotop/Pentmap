## Introduccion

Este es el trabajo de final de curso de servicios, consiste en un script de nmap el cual lo primero de todo escanea una red la cual tu proporciona, despues te enumera y escanea todos los puertos abierto. Para escanear utiliza un script el cual viene por defecto en nmap una vez termina (que suelen ser unos 5min) te muestra todas las vulnerabilidades encontradas en pantalla

## Motivación

El principal motivo el cual hice este script es porque la enumeración de muertos suele ser siempre igual y hay muy pocas veces que varié es decir que es muy fácil automatizar todo para no tener que estar en todo el rato escribiendo los m ismos comandos una y otra vez

## Esquema

El esquema del script es el siguiente

1. Personalización del script
2. Escaneo de puertos
3. Escaneo de vulnerabilidades

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2d2b9e1c-215d-4909-996f-f78745b897d1/51cac2ec-2d9a-45e3-ab41-d379d0392ba1/Untitled.png)

## Desarrollo

En el desarrollo profundizare mas como y que hace cada cosa

1. Personalización del script
    
    En este apartado del script personaliza el script como cambiando los colores de cuando hacemos un echo, esto se consigue de la siguiente forma
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2d2b9e1c-215d-4909-996f-f78745b897d1/6f965108-596f-4a1d-aa94-38f99cc05c03/Untitled.png)
    
    La variable es lo que guardara la secuencia de escape y gracias a esto podremos llamarlo fácilmente para cambiar el color en este caso de un echo de la siguiente manera
    
    `echo -e "${azul}[+] Puertos abiertos:${azul}"` 
    
    para que se guarde el cambio hay que poner -e para que habilite la interceptación de secuencias dentro de la cadena de texto
    
    La secuencia de escape se utiliza para cambiar el formato del texto que se muestra
    
    - **`\e`**: Indica el inicio de una secuencia de escape.
    - **`[`**: Marca el inicio de los códigos de control.
    - **`1`**: Indica que se va a utilizar un formato de texto intenso (en este caso, texto en negrita).
    - **`;`**: Separador de códigos de control.
    - **`31`**: Código para el color rojo.
    - **`m`**: Marca el final de la secuencia de escape.
        
        ```bash
        # #Coloricos :)
        
        rojo="\e[1;31m"
        verde="\x1b[0;32m"
        amarillo="\e[1;33m"
        azul="\e[1;34m"
        morado="\e[1;35m"
        cian="\e[1;36m"
        blanco="\e[1;37m"
        
        echo Puertos abiertos > PuertosAbiertos.txt
        ```
        
    
    Y por ultimo la línea `echo Puertos abiertos > PuertosAbiertos.txt`  asegura que el archivo puertosabiertos.txt este vacío, es decir, que si se a utilizado ya el script no haya problemas de falsos positivos por haberlo hecho antes con otra ip
    
    Y despues hay un `cat title` esto es un archivo que hay que instalar con el script y lo que hace es mostrar una portada con el nombre de la herramienta
    
2. Escaneo de puertos
    
    Esta parte del script es la mas importante de todo el script ya que permite saber que puertos están abiertos y gracias a esta información podremos buscar las vulnerabilidades
    
    El código comienza preguntando una ip o una url
    
    `read -p "Introduzca la URL o IP: " url` 
    
    - El comando `read` se utiliza para leer la entrada del usuario desde la terminal
    - `-p` Esta opcion se usa para mostrar un mensaje de prompt antes de que el usuario ingrese la entrada
    - `"Introduzca la URL o IP: "` Esta frase se imprimira en pantalla y se guardara en la variable `url`
    
    Luego te mostrara el siguiente mensaje `[+] Escaneando los puertos en $url` , gracias al siguiente comando `echo -e "${azul}[+] Escaneando los puertos en $url${azul}"` 
    
    Despues teniendo la ip o url empezaremos con el escaneo de puertos mas simple de todos ya que solo necesitamos saber si están abiertos o no, el comando será el siguiente
    
    nmap "$url" > /home/kali/Documents/nmap/Escaneo.txt
    
    - `nmap "$url"` Ejecuta el comando de nmap a la url o ip que has dado antes
    - `> /home/kali/Documents/nmap/escaneo.txt` Redirige la salida del comando al archivo Escaneo.txt para que luego sea mas fácil imprimir los puertos de forma bonita
    
    Por ultimo definimos una variable con la ruta del archivos donde se guardan los puertos
    
    `puertos_abiertos="/home/kali/Documents/nmap/PuertosAbiertos.txt"` 
    
    - `puertos_abiertos` Esta es la variable
    - `"/home/kali/Documents/nmap/PuertosAbiertos.txt"` Ruta del archivo que guarda los puertos
    
    ```bash
    read -p "Introduzca la URL o IP: " url
    
    echo -e "${azul}[+] Escaneando los puertos en $url${azul}"
    
    nmap "$url" > /home/kali/Documents/nmap/Escaneo.txt
    
    echo -e "${azul}[+] Puertos abiertos:${azul}"
    
    puertos_abiertos="/home/kali/Documents/nmap/PuertosAbiertos.txt"
    ```
    
3. Imprimir los puertos abiertos 
    
    Esta apartado en si es la continuación del punto 2 ya que imprime el comando principal que se ejecuta en ese punto
    
    Esta parte del script comienza creando una función llamada `imprimir_puerto` , esta función toma dos argumentos: el numero de puerto y la descripción del servicio asociado con ese puerto, luego con el siguiente comando `if grep -q "$1/tcp" /home/kali/Documents/nmap/Escaneo.txt 2>/dev/null; then` busca el puerto seguido de /tcp en el archivo, si encuentra coincidencia lo imprime indicando que esta abierto y guarda la informacion en un archivo en cambio si no lanza un echo y dice que esta cerrado
    
    ```bash
    if grep -q "$1/tcp" /home/kali/Documents/nmap/Escaneo.txt 2>/dev/null; then
    ```
    
    - `grep` El comando grep se utiliza para filtrar o encontrar palabras en archivos o comandos
    - `-q` Esta opción indica que el grep debe ejecutarse en modo silencioso, es decir, que no imprimirá nada, ni siquiera coincidencias encontradas
    - `"$1/tcp"` Indica que el primer argumento pasado por la funcion `'imprimir puerto'`  seguido de /tcp
    
    ```bash
    echo -e "${verde}[+] Puerto $1 abierto (${2})${verde}"
    ```
    
    - Imprime un mensaje indicando que el puerto está abierto
    
    ```bash
    echo "$1/tcp - $2" >> "$puertos_abiertos"
    ```
    
    - Guarda la información del puerto abierto en el archivo **`$puertos_abiertos`**. El formato es "Número de puerto/tcp - Descripción del servicio".
    
    ```bash
    echo -e "${rojo}[-] Puerto $1 cerrado${rojo}"
    ```
    
    - Imprime un mensaje indicando que el puerto está cerrado
    
    Despues de haber terminado el condicional muestra todos los puertos en pantalla (Porque recordemos que el grep tiene el modo silencioso y aun no ha enseñado nada), para hacer esto llamamos la la funcion `imprimir_puerto()` y muestra el estado de los puertos
    
    ```bash
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
    ```
    
    Y para terminar muestra un echo el cual confirma que se ha completado el escaneo de puertos y guarda los puertos en **$puertos_abiertos**
    
4. Escaneo de vulnerabilidades
    
    En esta parte del script escanea todas las vulnerabilidades de todos los puertos abiertos anteriormente guardados
    
    - `Escaneo_puertos()`  Define una función llamada Escaneo_puertos que ejecuta el escaneo de vulnerabilidades en los puertos abiertos.
    
    ```bash
    while read -r line; do
    puerto=$(echo "$line" | cut -d' ' -f1 | awk -F' |/' '{print $1}')
    servicio=$(echo "$line" | cut -d' ' -f3-)
    ```
    
    - `while` Es un comando que inicia un bucle y continuara ejecutándose hasta que se cumpla una condición
    - `read -r line` El comando read se utiliza para leer una linea de entrada y asignarla a la variable $line, La opción `-r` indica que se debe realizar una lectura cruda, lo que significa que los caracteres de escape que hemos visto antes como ‘/’ no se interpretan
    - `do` Indica el inicio del bloque de comandos que se ejecutara mientras la condición del bucle sea verdadera
    - `puerto=$(echo "$line" | cut -d' ' -f1 | awk -F' |/' '{print $1}')` Extrae el número de puerto de la línea actual. Utiliza el comando **`cut`** para dividir la línea en campos utilizando el espacio como delimitador (**`-d' '`**), y luego selecciona el primer campo (**`-f1`**). Luego, utiliza **`awk`** para dividir el campo resultante en subcampos utilizando el espacio o la barra inclinada como delimitadores (**`-F' |/'`**), y selecciona el primer subcampo (**`'{print $1}'`**).
    - `servicio=$(echo "$line" | cut -d' ' -f3-)` Extrae el nombre del servicio asociado con el puerto de la línea actual. Utiliza el comando **`cut`** para dividir la línea en campos utilizando el espacio como delimitador (**`-d' '`**), y luego selecciona desde el tercer campo hasta el final (**`-f3-`**).
    
    Luego tenemos que comprobar si el puerto esta vacio o no para ello esta 
    
    ```bash
      if [ -n "$puerto" ]; then
            echo -e "${azul}[+] Escaneando vulnerabilidades en el puerto $puerto (${servicio})${azul}"
    ```
    
    - **`if [ -n "$puerto" ]; then ... else echo "${rojo}${rojo}" fi`** Si el puerto no está vacío, se procede con el escaneo de vulnerabilidades. De lo contrario, no se realiza ninguna acción y se imprime una cadena vacía en rojo
    
    Si el puerto no esta vacío se ejecutara el comando el cual busca vulnerabilidades en los puertos abiertos
    
    ```bash
    nmap --script "vuln" -p"$puerto" "$url"
    ```
    
    - `nmap` Nmap es una herramienta de escaneo de equipos
    - `--script "Vuln"`  Esta opción permite ejecutar scripts y en este caso ejecuta el script llamado Vuln
    - `-p”$puerto”` La opcion `-p`  indica el protocolo el cual vas a escanear y `“$puerto”` es la variable en la cual almacena todos los puertos
    - `“$url”`  Es donde se almacena la ip que hemos puesto en el principio del script
    
    Una vez que se ejecuta con éxito el escaneo de nmap hace un echo para confirmarlo`echo -e "${verde}[+] Vulnerabilidades escaneadas con éxito en el puerto $puerto ${servicio}) ${verde}"` 
    
    Y lo ultimo que hará el script es quitamos todos los puertos del archivo con `done < "$puertos_abiertos"`
    

```bash
#!/bin/bash
 
 
 # #Coloricos :)
 
 rojo="\e[1;31m"
 verde="\x1b[0;32m"
 amarillo="\e[1;33m"
 azul="\e[1;34m"
 morado="\e[1;35m"
 cian="\e[1;36m"
 blanco="\e[1;37m"
 
 echo Puertos abiertos > PuertosAbiertos.txt
 
 cat titulo
 
 # #Escaneo de puertos
 
 read -p "Introduzca la URL o IP: " url
 
 echo -e "${azul}[+] Escaneando los puertos en $url${azul}"
 
 nmap "$url" > /home/kali/Documents/nmap/Escaneo.txt
 
 echo -e "${azul}[+] Puertos abiertos:${azul}"
 
 # #Archivo para almacenar los puertos abiertos
 
 puertos_abiertos="/home/kali/Documents/nmap/PuertosAbiertos.txt"
 
 # #Función para imprimir y guardar puertos abiertos
 
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
 
 # #Escaneo de vulnerabilidades
 
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
 	echo "${rojo}No se ha escaneado con exito${rojo}"
     fi
 done < "$puertos_abiertos"
 }
```

```bash

 _______   ________   ___  ___  _____ ______   ___   ___      ___    ___ ________  ___  ___     
|\  ___ \ |\   ___  \|\  \|\  \|\   _ \  _   \|\  \ |\  \    |\  \  /  /|\   __  \|\  \|\  \    
\ \   __/|\ \  \\ \  \ \  \\\  \ \  \\\__\ \  \ \  \\_\  \   \ \  \/  / | \  \|\  \ \  \\\  \   
 \ \  \_|/_\ \  \\ \  \ \  \\\  \ \  \\|__| \  \ \______  \   \ \    / / \ \  \\\  \ \  \\\  \  
  \ \  \_|\ \ \  \\ \  \ \  \\\  \ \  \    \ \  \|_____|\  \   \/  /  /   \ \  \\\  \ \  \\\  \ 
   \ \_______\ \__\\ \__\ \_______\ \__\    \ \__\     \ \__\__/  / /      \ \_______\ \_______\
    \|_______|\|__| \|__|\|_______|\|__|     \|__|      \|__|\___/ /        \|_______|\|_______|
                                                            \|___|/                             
                                                                                                
                                                                                                

```

## Conclusiones

Este es un script hasta ahora bastante básico y que se puede mejorar mucho aun pero aun así ese era el propósito principal ya que simplemente es ahorrar tiempo en el momento de enumerar, además llevo bastante tiempo utilizando al principio de cada maquina y no me ha dado aun ningún error así que estoy bastante satisfecho con mi trabajo.

## Demo Grabada

[Vídeo sin título ‐ Hecho con Clipchamp (3).mp4](https://prod-files-secure.s3.us-west-2.amazonaws.com/2d2b9e1c-215d-4909-996f-f78745b897d1/0f4b5de9-1504-4276-9453-dc2a6467ad0c/Vdeo_sin_ttulo__Hecho_con_Clipchamp_(3).mp4)

## Referencias

Para hacer este trabajo me he apoyado tanto en chat gpt como en paginas puntuales para conseguir soluciones a errores los cuales chat gpt no podía solucionar, y sobre todo me he ayudado con el man de nmap
