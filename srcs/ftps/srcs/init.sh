# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 12:28:41 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/04 17:31:18 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Env variables
# FTPS_USER <- Username of the user you want to create
# FTPS_PASS <- The password of the user

# --- FTPS setup ---
openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:1024 -keyout \
/etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem

if [ ! -d "/ftp/$FTPS_USER" ]
then
	mkdir -p /ftp/$FTPS_USER &> /dev/null
fi

echo -e "$FTPS_PASS\n$FTPS_PASS" | adduser -h /ftp/$FTPS_USER $FTPS_USER
chown $FTPS_USER:$FTPS_USER /ftp/$FTPS_USER

# -- Start FTP server ---
printf "FTPS server is starting !\n"
exec /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21004 -opasv_address=192.168.99.230 /etc/vsftpd/vsftpd.conf &
tail -F /dev/null
