FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
  libcap2-bin \
  build-essential \
  cmake \
  pbuilder \
  ubuntu-dev-tools \
  debootstrap \
  devscripts \
  quilt \
  dh-make \
  fakeroot \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/root
ADD scripts/buildBase.sh /home/root
RUN chmod +x /home/root/buildBase.sh