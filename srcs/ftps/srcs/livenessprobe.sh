#! /bin/ash

curl --insecure --ftp-ssl ftp://localhost:21//ftp/ --user "michel:$FTPS_PASS" -l
