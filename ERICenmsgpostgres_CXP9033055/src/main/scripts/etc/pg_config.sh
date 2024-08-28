#!/binbash
_RM=/bin/rm
_MV=/bin/mv
_CAT=/bin/cat

#Use ENM specific configuration
if [ -f "/tmp/postgresql.conf" ]; then
  ${_MV} /tmp/postgresql.conf /ericsson/postgres/data/postgresql.conf
fi
if [ -f "/tmp/pg_hba.conf" ]; then
  ${_CAT} /tmp/pg_hba.conf >> /ericsson/postgres/data/pg_hba.conf
  ${_RM} -f /tmp/pg_hba.conf
fi