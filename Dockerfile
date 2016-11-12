FROM scorpil/rust

RUN apt-get update -qq && \
      apt-get install --no-install-recommends --fix-missing -y \
      nasm grub-pc xorriso bsdmainutils make \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
