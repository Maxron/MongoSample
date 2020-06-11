#!/usr/bin/env bash
source .env

cat << EEOF > config/mongo-entrypoint/docker-entrypoint-initdb.sh

#!/usr/bin/env bash
echo "Creating mongo users..."
mongo admin --host localhost -u ${MONGO_INITDB_ROOT_USERNAME} -p ${MONGO_INITDB_ROOT_PASSWORD} --eval "db.createUser({user: '${MONGO_ADMINDB_USERNAME}', pwd: '${MONGO_ADMINDB_USER_PASSWORD}', roles: [{role: 'userAdminAnyDatabase', db: 'admin'}]});"
mongo admin -u ${MONGO_INITDB_ROOT_USERNAME} -p ${MONGO_INITDB_ROOT_PASSWORD} << EOF
use ${MONGO_CUSTOM_DB_NAME} 
db.createUser({user: '${MONGO_CUSTOM_DB_USERNAME}', pwd: '${MONGO_CUSTOM_DB_USER_PASSWORD}', roles:[{role:'readWrite',db:'${MONGO_CUSTOM_DB_NAME}'}]})
EOF
echo "Mongo users created."

EEOF