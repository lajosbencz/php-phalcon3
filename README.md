# php-phalcon3
## Image for Phalcon 3

Legacy [Phalcon 3](https://docs.phalcon.io/3.4/introduction/), with an extensive extension list and small image size.

### Components

- tzdata
- locales
- nginx _1.16_
- php _7.3_
- phalcon _3.4.5_

### Build args

- `UID` numeric user id for _app_ user
- `EXTENSIONS` default list of pecl extensions
- `EXTRA_EXTENSIONS` space separated list of extra pecl extensions

### Paths

#### SHOULD override

- `/var/www/app/public` nginx root path

#### MAY override

- `/etc/nginx/nginx.conf` nginx config
- `/etc/nginx/conf.d/default.conf` nginx virtual server config
- `/etc/php7/php-fpm.conf` php-fpm config
- `/etc/php7/php-fpm.d/www.conf` php-fpm pool config

### Extensions

```
[PHP Modules]
amqp
apcu
ast
bcmath
brotli
bz2
calendar
core
ctype
curl
date
dba
dio
dom
ds
enchant
event
exif
fileinfo
filter
ftp
gd
gettext
gmp
grpc
hash
iconv
igbinary
imagick
imap
inotify
intl
json
ldap
libxml
lzf
mailparse
mbstring
mcrypt
memcache
memcached
msgpack
mysqlnd
oauth
odbc
openssl
pcntl
pcre
pdo
pdo_dblib
pdo_mysql
pdo_odbc
pdo_pgsql
pdo_sqlite
pdo_sqlsrv
phalcon
phar
posix
propro
protobuf
pspell
psr
raphf
rar
readline
redis
reflection
session
shmop
simplexml
snmp
soap
sockets
sodium
spl
sqlite3
ssh2
standard
sysvmsg
sysvsem
sysvshm
tidy
timezonedb
tokenizer
uuid
vips
wddx
xml
xmlreader
xmlrpc
xmlwriter
xsl
yaml
zip
zlib
zmq

[Zend Modules]
Zend OPcache
```
