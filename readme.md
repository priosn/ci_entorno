# Entorno de integración continua.

## Introducción
Implementación de un sistema de integración continua que tiene como objetivo alcanzar el mayor grado de automatización posible permitiendo un ahorro de tiempo al equipo de trabajo y mejorando la calidad del código. 

Para llevarlo a cabo se ha utilizado tecnología *Docker*, que permite crear, ejecutar y escalar rápidamente aplicaciones creando contenedores. 

Jenkins se encargará de automatizar todas las tareas como la construcción y entrega de código.

## Entorno del proyecto
Para levantar un entorno aislado formado con varios contenedores conectados se usará *Docker-Compose*, que con un único archivo se puede crear y levantar todos los servicios configurados.

### Requisitos
El entorno puede levantarse en cualquier sistema operativo que tenga instalado el software de *Docker* y *Docker-Compose*.

### Arquitectura
El entorno está compuesto por dos contenedores: el contenedor de jenkins que se encarga de lanzar los diferentes procesos y el contenedor de SonarQube que se encarga del análisis estático del código. Esto se configura en el archivo *docker-compose.yml*.

1. **Jenkins**
Se crea una imagen que parte de la imagen de jenkins (jenkins/jenkins:2.289.2-lts) donde se ha istalado Docker. Esto se configura en el *Dockerfile*, que se encuentra en el directorio Jenkins. El puerto que usa Jenkins es el 8080 y se especifica `user:root` para que Jenkins pueda eliminar archivos en el *workspace*.  Los volúmenes configurados son los siguientes:
	+ `./jenkins_home` donde se almacena toda la instalación de jenkins (plugins y configuración) de forma persistente. 
	+ `/var/run/docker.sock`comparte el socket con el contenedor de Jenkins y así se puedan ejecutar contenedores en su interior como la imagen de compilación. 

	En el Dockerfile también se deben configurar los plugins necesarios:
	1. *subversion*: Para descargar el proyecto del repositorio de subversion.
	2. *docker-plugins*, *docker-workflow*: Necesario para ejecutar contenedores Docker dentro de Jenkins.
	3. *sonar*: Para conectar con el contenedor de SonarQube.