FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    gcc \
    g++ \
    libc6-dev \
    libtool \
    xz-utils
RUN apt-get remove -y autotools-dev

RUN mkdir /deps

COPY ../docker_deps/*.deb /deps/

RUN dpkg -i /deps/autotools*.deb
RUN dpkg -i /deps/autoconf*.deb
RUN dpkg -i /deps/automake*.deb

CMD ["cd /binutils/ld && autoconf && automake"]
