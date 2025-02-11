FROM ubuntu:18.04
#FROM ubuntu:20.04

COPY 02proxy /etc/apt/apt.conf.d/

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

# Erlang
RUN apt update && apt -y install wget gnupg
#RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb
#RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.3.4.9-1~ubuntu~focal_amd64.deb
RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.3.4.9-1~ubuntu~bionic_amd64.deb && apt install -y ./esl-erlang_22.3.4.9-1~ubuntu~bionic_amd64.deb
#RUN apt install -y ./esl-erlang_23.3.4.5-1~ubuntu~focal_amd64.deb
#RUN wget https://github.com/erlang/otp/releases/download/OTP-22.3.4.9/otp_src_22.3.4.9.tar.gz
#RUN dpkg -i esl-erlang_22.3.4.9-1~ubuntu~xenial_amd64.deb || apt -f -y install
RUN apt update && apt -y install erlang-src erlang-dev erlang-parsetools
# https://github.com/elixir-lang/elixir/archive/refs/tags/v1.8.2.tar.gz

# install asdf
RUN apt update && apt install -y git less vim telnet lsof curl
RUN apt update && apt install -y build-essential git wget libssl-dev libreadline-dev libncurses5-dev zlib1g-dev m4 curl wx-common libwxgtk3.0-dev autoconf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.4
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
SHELL ["/bin/bash", "-c"]
RUN /root/.asdf/bin/asdf plugin-add erlang
RUN /root/.asdf/bin/asdf plugin-add elixir
RUN /root/.asdf/bin/asdf install erlang 22.0.7
RUN /root/.asdf/bin/asdf install elixir 1.8.2-otp-22

# install phoenix
RUN mix local.hex --force
#RUN mix archive.install hex phx_new --force
RUN mix archive.install hex phx_new 1.4.17 --force
##RUN mix archive.install hex phx_new 1.5.13 --force
#RUN mix archive.install hex phx_new 1.6.6 --force

WORKDIR /root
COPY . .
RUN mix local.rebar


RUN mix deps.get
#RUN mix ecto.create
RUN mkdir -p storage/dev

#COPY mycerts/key.pem /certs/key.pem
#COPY mycerts/cert.pem /certs/cert.pem
