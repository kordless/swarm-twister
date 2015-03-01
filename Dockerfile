FROM debian:wheezy

MAINTAINER Kord Campbell <kordless@stackgeek.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
	apt-get -y -q install \ 
	git automake autoconf libtool build-essential \ 
	libboost-all-dev libssl-dev libdb++-dev libminiupnpc-dev  

RUN git clone https://github.com/miguelfreitas/twister-core.git

WORKDIR /twister-core

# configure and make core
RUN ./autotool.sh
RUN ./configure 
RUN make
RUN make install

# cofigure web gui
RUN mkdir ~/.twister
RUN echo -e "rpcuser=user\nrpcpassword=pwd" > ~/.twister/twister.conf
RUN chmod 600 ~/.twister/twister.conf
RUN git clone https://github.com/miguelfreitas/twister-html.git ~/.twister/html

ENTRYPOINT ["twisterd", "-rpcuser=user", "-rpcpassword=pwd", "-rpcallowip=127.0.0.1"]

EXPOSE 28332
