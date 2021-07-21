FROM jenkins/jenkins:2.289.2-lts

USER root

# Install Docker
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Subversion and Maven
RUN apt-get install subversion maven -y

USER jenkins

# Install plugins 
RUN jenkins-plugin-cli --plugins sonar:2.13.1 docker-plugin:1.2.2 docker-workflow:1.26