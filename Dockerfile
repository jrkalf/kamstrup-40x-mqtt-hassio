ARG BUILD_FROM                                                                                                                                
FROM $BUILD_FROM                                                                                                                              
                                                                                                                                              
ENV LANG C.UTF-8                                                                                                                              
WORKDIR /data                                                                                                                                 
RUN apk add --no-cache --virtual .build-dependencies udev git python3 py3-yaml py3-paho-mqtt py3-pyserial && \                                
    mkdir -p /opt/kamstrup/logs && \
    touch /opt/kamstrup/logs/debug.log && \
    git clone https://github.com/matthijsvisser/kamstrup-402-mqtt.git /opt/kamstrup &&  \                                                     
    apk del git --quiet                                                                                                                       
                                                                                                                                              
# Copy data for add-on                                                                                                                        
COPY run.sh /                                                                                                                                 
RUN chmod a+x /run.sh                                                                                                                         
                                                                                                                                              
CMD [ "/run.sh" ]
