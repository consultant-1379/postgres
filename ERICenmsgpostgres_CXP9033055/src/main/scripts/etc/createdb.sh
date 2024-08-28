#!/bin/bash
while [ -z "$(su - postgres -c 'psql -l')"]; do
  sleep 5
done
db_exists=$(su - postgres -c "psql -l | grep sfwkdb")
if [ -z "$db_exists" ]; then
    su - postgres -c "createdb sfwkdb"
        bash -x /ericsson/sfwk_postgres/db/sfwk/install_sfwk_db.sh
fi
db_exists=$(su - postgres -c "psql -l | grep idenmgmt")
if [ -z "$db_exists" ]; then
    su - postgres -c "createdb idenmgmt"
fi
db_exists=$(su - postgres -c "psql -l | grep wfsdb")
if [ -z "$db_exists" ]; then
    su - postgres -c "createdb wfsdb"
    bash -x /ericsson/wfs_postgres/db/wfs/install_wfs_db.sh
fi
