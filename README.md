# aria2-alpine

it's a barebone aria2 alpine docker image, like official alpine build but with gzip/sftp support.

reserved folder:
* `/etc/aria2/` as config folder
* `/srv/aria2/` as downloads folder

example docker-compose.yml:
```yml
version: "3"
services:
  aria2:
    image: miaulightouch/aria2-alpine
    container_name: aria2
    command: --conf-path=/etc/aria2/aria2.conf
    volumes:
      - /etc/aria2:/etc/aria2
      - /srv/aria2:/srv/aria2
    ports:
      - 127.0.0.1:6800:6800
      - 6801-6999:6801-6999
      - 6801-6999:6801-6999/udp
```

example aria2.conf:
```
summary-interval=0
enable-rpc=true
dir=/srv/aria2
input-file=/etc/aria2/aria2.session
save-session=/etc/aria2/aria2.session
save-session-interval=1
auto-save-interval=1
listen-port=6801-6999
dht-file-path=/etc/aria2/dht.dat
dht-file-path6=/etc/aria2/dht6.dat
dht-listen-port=6801-6999
```
