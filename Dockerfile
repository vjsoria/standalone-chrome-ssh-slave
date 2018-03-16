FROM selenium/standalone-chrome 
ARG user=seluser
#ARG group=jenkins
#ARG uid=1001
#ARG gid=1001
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

#RUN sudo groupadd -g ${gid} ${group} \
#    && sudo useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

RUN sudo apt-get -y update
RUN sudo apt-get install -y openssh-server
RUN sudo mkdir -p /var/run/sshd
COPY setup-sshd /usr/local/bin/setup-sshd
COPY ./configs/sshd_config /etc/ssh/sshd_config
VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"
EXPOSE 22
CMD ["sudo","/usr/local/bin/setup-sshd"]
