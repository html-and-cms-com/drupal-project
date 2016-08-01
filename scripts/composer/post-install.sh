#!/bin/bash

NOTICE="Run drush si command for first installation drupal"
DRUPAL_BOOTSTRAP_KEY="Drupal bootstrap"
DRUPAL_BOOTSTRAP_VALID_VALUE="Successful"

SUCCESS='\033[0;32m'
ERROR='\033[0;31m'
NC='\033[0m'

WORK_PATH=$PWD

cd $WORK_PATH/web
LIST=$(drush status)
IFS=$'\n'

for item in $LIST; do
    PARAM=$(echo $item | cut -d':' -f 1)
    PARAM=${PARAM:1:16}

    if [ "$PARAM" == "$DRUPAL_BOOTSTRAP_KEY" ]; then
        DVSTATUS=$(echo $item | cut -d':' -f 2 | sed 's/ //g')

        if [ "$DVSTATUS" == "$DRUPAL_BOOTSTRAP_VALID_VALUE" ]; then
            echo -e "${SUCCESS}Site already installed:${NC}"
            echo "Starting to updating system.site uuid"
            echo "Get UUID from config sync system.site.yml"
            UUID=$(head -n 1 $WORK_PATH/config/sync/system.site.yml)
            UUID=$(echo $UUID | cut -d':' -f 2 | sed 's/ //g')

            echo "Set UUID into installed database"
            drush -y config-set "system.site" uuid "$UUID"

            DBUUID=$(drush cget system.site uuid | cut -d':' -f 3 | sed 's/ //g')
            if [ $DBUUID=$UUID ]; then
              echo -e "${SUCCESS}UUID was updated from config sync system.site.yml${NC}"
              else
              echo -e "${ERROR}Something went wrong...${NC}"
            fi

            exit 0
        fi
        echo -e "${ERROR}Site Drupal bootstrap not valid${NC}"
        echo $NOTICE
        exit 0
    fi
done
echo -e "${ERROR}Site not installed${NC}"
echo $NOTICE
exit 1