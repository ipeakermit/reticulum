FROM ubuntu:20.04

RUN apt update && apt -y dist-upgrade

# Set the locale
RUN apt -y install locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install keyboard-configuration

# Elixir
RUN apt update && apt -y install wget gnupg
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb
RUN apt update && apt -y install esl-erlang
RUN apt update && apt -y install elixir
RUN mix local.hex --force
RUN mix archive.install hex phx_new --force

RUN apt update && apt -y install git

WORKDIR /root
COPY . .
RUN mix local.rebar

RUN apt update && apt -y install vim telnet

RUN mix deps.get
#RUN mix ecto.create
#RUN mkdir -p storage/dev
