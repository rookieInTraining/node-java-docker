FROM node:10.20-stretch-slim

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.2.1

RUN apt-get -qq update \
  && apt-get install --no-install-recommends -qqy \
  ca-certificates \
  bash \
  unzip \
  wget \
  curl

# Install Java
USER root
RUN echo "deb http://security.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y openjdk-8-jdk

# Install Testim-Cli and Gradle
RUN echo "Downloading Gradle" \
  && wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
  && echo "Installing Gradle" \
  && unzip gradle.zip \
  && rm gradle.zip \
  && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
  && ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

RUN apt-get install unzip -y && \
  apt-get autoremove -y

RUN ["gradle","--version"]

ENTRYPOINT [ "gradle" ]
