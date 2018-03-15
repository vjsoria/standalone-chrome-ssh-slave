FROM selenium/standalone-chrome:3.11.0-antimony
LABEL MAINTAINER="Victor Soria <vjsoria@gmail.com>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1001
ARG gid=1001
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN sudo groupadd -g ${gid} ${group} \
    && sudo useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

# setup SSH server
RUN sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y openssh-server \
    && sudo apt-get clean
RUN sudo sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#SyslogFacility.*/SyslogFacility AUTH/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#LogLevel.*/LogLevel INFO/' /etc/ssh/sshd_config
RUN sudo mkdir /var/run/sshd

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

COPY setup-sshd /usr/local/bin/setup-sshd



RUN sudo apt-get update
RUN sudo apt-get install -y curl
RUN sudo curl -sL https://deb.nodesource.com/setup_9.x | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install -y build-essential

EXPOSE 22

CMD ["setup-sshd"]
