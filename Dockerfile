FROM condaforge/miniforge3:22.9.0-3
ENV DEBIAN_FRONTEND noninteractive
ENV OPTEE_VERSION 3.21.0
RUN apt-get update && \
    apt-get -y install \
      ssh \
      android-tools-adb \
      android-tools-fastboot \
      autoconf \
      automake \
      bc \
      bison \
      build-essential \
      ccache \
      cscope \
      curl \
      device-tree-compiler \
      expect \
      flex \
      ftp-upload \
      gdisk \
      iasl \
      libattr1-dev \
      libcap-dev \
      libfdt-dev \
      libftdi-dev \
      libglib2.0-dev \
      libgmp3-dev \
      libhidapi-dev \
      libmpc-dev \
      libncurses5-dev \
      libpixman-1-dev \
      libssl-dev \
      libtool \
      make \
      mtools \
      netcat \
      ninja-build \
      rsync \
      unzip \
      uuid-dev \
      xdg-utils \
      xterm \
      xz-utils \
      zlib1g-dev \
      # extra for Docker only \
      cpio \
      git \
      nano \
      cmake gcc-aarch64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf \
      wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install crypto cryptography pyelftools serial

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

RUN mkdir repo && \
    cd repo && \
    repo init -u https://github.com/OP-TEE/manifest.git -m rockpi4.xml -b ${OPTEE_VERSION} && \
    repo sync -j`nproc` && \
    rm -rf .repo && \
    cd build && \
    make toolchains -j`nproc`
