#!/bin/bash -   
#title          :import_gcdb_dump.sh
#description    :Restores the GCDB database from the gcdb_dump.sql file
#============================================================================

# Config Variables:
USER="root"
HOST="localhost"

FILENAME='gcdb_dump.sql'
echo -n "Type mysql root password: "
#read -s PASS
PASS="password"
echo ""

function remove_warning {
    grep -v 'mysql: [Warning] Using a password on the command line interface can be insecure.'
}


# Exit when folder doesn't have .sql files:
if [ "$(ls $FILENAME.sql 2> /dev/null)" == 0 ]; then
  echo "$FILENAME.sql not found"
  exit 0
fi

# Get all database list first
DB_NAME='gcdonline'
DB_USER_QUERY="SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'gcdonline')"
DATABASES="$(docker exec -i project-swoop-mysql-1 mysql -u $USER --password=$PASS -Bse 'show databases')"
USER_EXISTS="$(docker exec -i project-swoop-mysql-1 mysql -u $USER --password=$PASS -Bse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user='gcdonline')")"

skip_create=-1
for existing in $DATABASES
do      
    [ "$DB_NAME" == "$existing" ] && skip_create=1 || :
done

if [ "$skip_create" ==  "1" ] ; then 
    echo "Database: $DB_NAME already exists, skiping create database"
else
    echo "Creating DB: $DB_NAME"
    echo "no warning?"
    docker exec -i project-swoop-mysql-1 mysqladmin create $DB_NAME -u $USER -p$PASS 2>&1 | remove_warning
fi

if [ "$USER_EXISTS" == "1" ]; then
    echo "User: gcdonline already exists, skiping create user"
else
    echo "Creating user"
    docker exec -i project-swoop-mysql-1 mysql -u $USER --password=$PASS -e 'CREATE USER gcdonline' 2>&1 | remove_warning
fi

echo "Granting permissions to gcdonline"
docker exec -i project-swoop-mysql-1 mysql -u $USER --password=$PASS -e 'GRANT ALL ON gcdonline.* TO gcdonline' 2>&1 | remove_warning

echo "Importing Database: $DB_NAME from $FILENAME (this may take some time)"
#docker exec -i project-swoop-mysql-1 mysql $DB_NAME < $FILENAME -u $USER -p$PASS
