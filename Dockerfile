FROM mono:4.6.2.16

RUN apt-get update && apt-get install -y build-essential make libtool libssl-dev autoconf automake gettext cmake pkg-config

RUN curl -O http://dist.libuv.org/dist/v1.9.1/libuv-v1.9.1.tar.gz && \
    tar -xvzf libuv-v1.9.1.tar.gz && \
    cd libuv-v1.9.1 && \
    sh ./autogen.sh && \
    ./configure && \
    make && \
    make install

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

COPY . /app
WORKDIR /app
RUN mono .paket/paket.exe install
WORKDIR /app/src/KestrelExperiment
RUN xbuild
CMD cd bin/Debug && \
    mono KestrelExperiment.exe