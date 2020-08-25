# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/25 13:09:05 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/25 17:51:57 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Environnement Variables
# WP_PASS <- password of the wordpress mysql account
# MYSQL_IP <- IP or FQDN of mysql

cat << EOF > /srv/www/wp-config.php
<?php
// ** Réglages MySQL - Votre hébergeur doit vous fournir ces informations. ** //
/** Nom de la base de données de WordPress. */
define('DB_NAME', 'wordpress');

/** Utilisateur de la base de données MySQL. */
define('DB_USER', 'wpuser');

/** Mot de passe de la base de données MySQL. */
define('DB_PASSWORD', '$WP_PASS');

/** Adresse de l’hébergement MySQL. */
define('DB_HOST', '$MYSQL_IP');

/** Jeu de caractères à utiliser par la base de données lors de la création des tables. */
define('DB_CHARSET', 'utf8');

/** Type de collation de la base de données.
  * N’y touchez que si vous savez ce que vous faites.
  */
define('DB_COLLATE', '');

define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');


$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF

php -S 0.0.0.0:5050 -t /srv/www/wordpress/wordpress

tail -F /dev/null
