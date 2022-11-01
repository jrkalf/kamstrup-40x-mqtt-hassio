ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8
WORKDIR /opt/kamstrup
RUN apk add --no-cache --virtual .build-dependencies udev git python3 py3-yaml py3-paho-mqtt py3-pyserial && \
    mkdir -p /opt/kamstrup && \
    git clone https://github.com/matthijsvisser/kamstrup-402-mqtt.git /opt/kamstrup &&  \
    apk del git --quiet

# run the wrapper
WORKDIR /opt/kamstrup

CMD ["/usr/bin/python3 /opt/kamstrup/daemon.py"]
