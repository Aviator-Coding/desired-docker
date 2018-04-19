FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m desire

#ENV DAEMON_RELEASE="v0.12.2.2"
ENV DAEMON_RELEASE="Desire-v.0.12.2.2"
#ENV DAEMON_RELEASE="master"
ENV DESIRE_DATA=/home/desire/.desire

USER desire

RUN cd /home/desire && \
    mkdir /home/desire/bin && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone --branch $DAEMON_RELEASE https://github.com/lazyboozer/Desire.git desired && \
    cd /home/desire/desired && \
    chmod 777 autogen.sh src/leveldb/build_detect_platform share/genbuild.sh && \
#    sed -i 's/<const\ CScriptID\&/<CScriptID/' rpcrawtransaction.cpp && \
#    make -f makefile.unix && \a
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/desire/db4/lib/" CPPFLAGS="-I/home/desire/db4/include/" && \
    make && \
    cd src/ && \
    strip desired && \
    strip desire-tx && \
    strip desire-cli && \
    mv desired desire-cli desire-tx /home/desire/bin && \
    rm -rf /home/desire/desired
    
EXPOSE 9918 9919

#VOLUME ["/home/desire/.desire"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN wget -O /usr/bin/sentinel https://github.com/ZonnCash/sentinel/releases/download/v1.1.0-win64/sentinel-lin64 && \
    chmod 777 /entrypoint.sh && \
    echo "\n# Some aliases to make the desire clients/tools easier to access\nalias desired='/usr/bin/desired -conf=/home/desire/.desire/desire.conf'\nalias desired='/usr/bin/desired -conf=/home/desire/.desire/desire.conf'\nalias desirecli='/usr/bin/desire-cli -conf=/home/desire/.desire/desire.conf'\n\n[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc && \
    echo "desire (SYNX) Cryptocoin Daemon\n\nUsage:\n desire-cli help - List help options\n desire-cli listtransactions - List Transactions\n\n" > /etc/motd && \
    chmod 755 /home/desire/bin/desired && \
    chmod 755 /home/desire/bin/desire-cli && \
    chmod 755 /home/desire/bin/desire-tx && \
    chmod 755 /usr/bin/sentinel && \
    mv /home/desire/bin/desired /usr/bin/desired && \
    mv /home/desire/bin/desire-cli /usr/bin/desire-cli && \
    mv /home/desire/bin/desire-tx /usr/bin/desire-tx

ENTRYPOINT ["/entrypoint.sh"]

CMD ["desired"]
