FROM openjdk:8u282-slim-buster AS base
WORKDIR /root
RUN mkdir .m2
COPY m2.tar.gz .m2
RUN cd .m2 && tar xzf m2.tar.gz
RUN rm -rf .m2/m2.tar.gz

FROM openjdk:8u282-slim-buster
RUN addgroup --gid 1700 builder
RUN adduser --ingroup builder --uid 1700 builder
COPY --chown=builder:builder --from=base /root/.m2 /home/builder/.m2
RUN apt update
RUN apt install -y wget gnupg
RUN echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list.d/debian.list
RUN sh -c 'echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list'
RUN wget https://packages.atlassian.com/api/gpg/key/public
RUN apt-key add public
RUN apt update
RUN apt install -y atlassian-plugin-sdk
RUN apt install -y locales locales-all sudo procps
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN apt install -y --no-install-recommends firefox libxcomposite1 libxcursor1 libxi6 libxtst6 libxss1 \
    libgbm-dev libasound2 xvfb
RUN apt install -y xauth

