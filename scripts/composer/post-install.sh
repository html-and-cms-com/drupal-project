#!/bin/sh

# Prepare the settings file for installation
if [ ! -f web/sites/default/settings.php ]
  then
    cp web/sites/default/default.settings.php web/sites/default/settings.php
    chmod 644 web/sites/default/settings.php
    echo "\$config_directories[CONFIG_SYNC_DIRECTORY] = '../config/sync';" >> web/sites/default/settings.php
    echo "\$settings['hash_salt'] = '$(php -r 'print bin2hex(openssl_random_pseudo_bytes(32, $cstrong = TRUE));')';" >> web/sites/default/settings.php
fi

# Prepare the services file for installation
if [ ! -f web/sites/default/services.yml ]
  then
    cp web/sites/default/default.services.yml web/sites/default/services.yml
    chmod 644 web/sites/default/services.yml
fi

# Prepare the files directory for installation
if [ ! -d web/sites/default/files ]
  then
    mkdir -m777 web/sites/default/files
fi
