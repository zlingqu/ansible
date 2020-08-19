FROM golang
RUN git clone https://github.com/NVIDIA/gpu-monitoring-tools.git && \
    cd gpu-monitoring-tools && \
    git checkout -b 2.0.0-rc.12 && \
    make binary && \
    make install

#docker build . -t quzl

#docker run -it -v /tmp/:/tmp --rm quzl sh
#cp /usr/bin/dcgm-exporter /tmp
