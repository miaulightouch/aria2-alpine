FROM alpine:latest AS builder

RUN apk update \
  && apk add --no-cache alpine-sdk \
  && adduser -s /bin/ash -G abuild -D builder \
  && addgroup builder wheel \
  && chmod 0600 /etc/sudoers \
  && echo "Set disable_coredump false" >>/etc/sudo.conf \
  && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers \
  && chmod 0440 /etc/sudoers
RUN sudo -u builder sh -c "cd ~ && echo /home/builder/key.rsa | abuild-keygen \
  && echo PACKAGER_PRIVKEY=/home/builder/key.rsa >>/home/builder/.abuild/abuild.conf \
  && sudo cp ~/key.rsa.pub /etc/apk/keys \
  && git clone --depth 1 --branch master git://dev.alpinelinux.org/aports \
  && cd aports/main/aria2 \
  && sed -i 's/makedepends=\"\(.*\)\"/makedepends=\"\1 libssh2-dev zlib-dev\"/' APKBUILD \
  && abuild checksum && abuild -r"


FROM alpine:latest

COPY --from=builder /home/builder/packages/main/x86_64/aria2-1* /tmp
COPY --from=builder /home/builder/aports/main/aria2/aria2.logrotate /etc/logrotate.d/aria2

RUN apk add --allow-untrusted --no-cache /tmp/aria2-1* \
  && rm -fr /tmp/* \
  && mkdir -p /srv/aria2 /etc/aria2

VOLUME ["/srv/aria2", "/etc/aria2"]

ENTRYPOINT ["aria2c"]
