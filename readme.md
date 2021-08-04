# Entorno de integración continua con *Jenkins* y *Sonarqube*.
> Configuración de *Sonarqube* para análisis de código C y C++
## Overview
Este repositorio contiene lo necesario para generar de forma automática un `entorno de integración continua con Jenkins y Sonarqube Community` utilizando contenedores `Docker`.

Además, se ha instalado lo necesario para poder **analizar un proyecto en lenguaje C y C++** desde *Sonarqube*:
+ [`SonarScanner`](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/) herramienta necesaria para poder lanzar el análisis del código desde *Jenkins*. 
+ [`Plugin sonar-cxx`](https://github.com/SonarOpenCommunity/sonar-cxx) que proporciona soporte a *Sonarqube* a código en lenguaje C y C++.

## Requisitos
Este proyecto únicamente necesita:
-	Instalación de [*Docker*](https://docs.docker.com/engine/install/) y [*Docker-Compose*](https://docs.docker.com/compose/install/) en cualquier sistema operativo.

## QuickStart
Para levantar el entorno se siguen los siguientes pasos:
1. Ejecutar el script `install.sh` para descargar los paquetes y plugins necesarios para la configuración de los contenedores.
```sh
$ ./install.sh
```
2. Descargar y construir las nuevas imágenes.
```sh
$ docker-compose build
```
3. Levantar los contenedores.
```sh
$ docker-compose up
```
Para acceder a la interfaz gráfica:
+ Jenkins: http://localhost/8080
+ SonarQube: http://localhost/9000

---
# Wiki del entorno
En este repositorio se ha diseñado e implementado un entorno de integración continua que tiene como objetivo alcanzar el mayor grado de automatización en el ciclo de vida del desarrollo software para ahorrar tiempo al desarrollador y mejorar la calidad del código.

Se utiliza `Docker` como herramienta principal que permite levantar y gestionar contenedores con enorme facilidad, reproducibilidad y portabilidad.


## Entorno del proyecto
El entorno está formado por un servidor `Jenkins` que se encarga de automatizar las tareas desde el sistema de control de versiones hasta el despliegue del proyecto y un servidor `Sonarqube` que lleva a cabo el análisis estático del código. 

Para levantar el entorno aislado con varios contenedores conectados se usa `Docker-Compose`, que con un simple archivo crea y levanta los servicios configurados.


### Arquitectura
La arquitectura del entorno parte de las imágenes:

1. **Imagen Jenkins**

	Se crea una nueva imagen nombrada `Jenkins/docker` que parte de la imagen de [**Jenkins**](https://hub.docker.com/r/jenkins/jenkins) **con JDK 11**. En el archivo `jenkins/Dockerfile` se configura la nueva imagen donde se instala:
	+ *Docker* para lanzar contenedores desde *Jenkins*.
	+ *Subversion* para descargar el repositorio del proyecto. 
	+ *Cppcheck* herramienta para analizar el código para lenguajes C y C++.
	+ Se configuran los plugins necesarios que utiliza *Jenkins*: `sonar`, `docker-plugins` y `docker-workflow`.
2. **Imagen Sonarqube Community**
	
	[Sonarqube](https://www.sonarqube.org/) es una herramienta *open source* de revisión automática de código para detectar errores, vulnerabilidades y *code smells* en el código. Permite ser integrada en el flujo de trabajo para inspeccionar de forma continua el código en el proyecto.
	
	El entorno parte de la imagen de **sonarqube:8.9.1-community** que se encuentra en su [dockeHub oficial](https://hub.docker.com/_/sonarqube). Esta versión es compatible con la última versión del plugins [sonar-cxx](https://github.com/SonarOpenCommunity/sonar-cxx) y se instala en el servidor a través de un volumen. 
	
	`Sonar-cxx` es un plugin que da soporte de C++ a *Sonarqube* con el objetivo de integrar las herramientas de C++ existentes. 

Una vez creadas las imágenes, se configura el entorno utilizando el archivo YAML `Docker-compose.yml` donde se define los servicios (*Jenkins* y *Sonarqube*), la red y los volúmenes para el entorno *Docker*.
+  **Version**: Se elige la [Versión 3.8](https://docs.docker.com/compose/compose-file/compose-versioning/#version-38), última recomendada.
+ **Network**: Se define una red en modo **brigde** con una dirección IP fija para cada contenedor permitiendo conectar los contenedores independientes entre si.
+ **Service**: Se fija la información que se aplica a cada contenedor al levantar el entorno. Se configura el nombre (*container_name*), los puertos (*ports*) desde donde son accesibles y la red (*network*). Como se ha dicho, el entorno está formado por dos contenedores:
	+ **Jenkins**. Este contenedor parte de la imagen creada donde se ha instalado *Docker*, *Subversion* y *Cppcheck*. El puerto que utiliza es el 8080 y se especifica como usuario *root* para que otorgarle permiso para modificar y eliminar archivos en el *workspace*. Los volúmenes configurados para esta aplicación son los siguientes:
		+ `./jenkins_home` donde se almacena toda la instalación de *Jenkins* (plugins y configuración) de forma persistente. 
		+ `/docker.sock` se comparte el archivo de *socket* de *Docker* para poder lanzar contenedores desde *Jenkins*. 
		+ `/sonar-server` instala ***SonarScanner*** en *Jenkins*. Esta herramienta es necesaria para poder lanzar el análisis del código en Sonarqube desde *Jenkins*.
	+ **SonarQube**. Este contenedor parte de la imagen oficial de Sonarqube Community. Los volúmenes configurados son: 
		+ `./sonarqube`: Volúmenes para almacenar de forma persistente la información del contentedor. 
		+ `./plugins` instala el ***plugin sonar-cxx***.