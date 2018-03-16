FROM selenium/standalone-chrome 
RUN sudo apt-get -y update
RUN sudo apt-get install -y openssh-server
RUN sudo mkdir -p /var/run/sshd
COPY setup-sshd /usr/local/bin/setup-sshd
COPY ./configs/sshd_config /etc/ssh/sshd_config
EXPOSE 22
CMD ["setup-sshd"]