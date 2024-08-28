#!/bin/bash
_MV=/bin/mv
_SED=/bin/sed
_ECHO=/bin/echo
_CHOWN=/bin/chown
_CHECKCONFIG=/sbin/chkconfig
_SEMANAGE=/usr/sbin/semanage
_RESTORECON=/sbin/restorecon
_SERVICE=/sbin/service
_RM=/bin/rm
_CAT=/bin/cat
_GREP=/bin/grep

# Set init environment
# Why can't we leave it as its original name rather than all of the moves?
${_MV} /opt/rh/postgresql92/root/var/lib/pgsql/.bash_profile /home/postgres/.bash_profile
${_SED} -i "s /var/lib/pgsql/data /ericsson/postgres/data g" /home/postgres/.bash_profile
${_SED} -i "s /opt/rh/postgresql92/root/var/lib/pgsql /home/postgres g" /etc/passwd

${_ECHO} "LD_LIBRARY_PATH=/opt/rh/postgresql92/root/usr/lib
export LD_LIBRARY_PATH
PATH=/opt/rh/postgresql92/root/usr/bin:$PATH
export PATH" >> /etc/profile

# Make sure the directory permissions are correct
${_CHOWN} -R postgres:postgres /home/postgres
${_CHOWN} -R postgres:postgres /ericsson/postgres/data

# Recreate the service with the new name
${_CHECKCONFIG} --del postgresql92-postgresql
# Remove default start script and replace with custom
${_RM} -f /etc/init.d/postgresql92-postgresql
${_MV} /ericsson/3pp/postgres/bin/etc/postgresql01 /etc/init.d/postgresql01
${_CHECKCONFIG} --add postgresql01
${_CHECKCONFIG} postgresql01 on

# Update paths in the service file - moved to scripts/etc/postgresql01
#${_SED} -i "s PGDATA=/opt/rh/postgresql92/root/var/lib/pgsql/data PGDATA=/ericsson/postgres/data g" /etc/init.d/postgresql01
#${_SED} -i "s PGLOG=/opt/rh/postgresql92/root/var/lib/pgsql/pgstartup.log PGLOG=/ericsson/postgres/pgstartup.log g" /etc/init.d/postgresql01

# Add selinux rules
${_SEMANAGE} fcontext -a -t postgresql_db_t "/ericsson"
${_SEMANAGE} fcontext -a -t postgresql_db_t "/ericsson/postgres(/.*)?"
${_RESTORECON} -Rv /ericsson



#Adding postgres initdb and start to rc.local in VM's
${_GREP} -q "${_SERVICE} postgresql01 initdb" /etc/rc.local

if [ $? -ne 0 ] ;then

    ${_ECHO} "#Postgres initdb on VM start-up
    ${_SERVICE} postgresql01 initdb" >> /etc/rc.local

fi

${_GREP} -q "PG Config" /etc/rc.local
if [ $? -ne 0 ] ;then

    ${_ECHO} "#Deliver ENM PG Config
    . /ericsson/3pp/postgres/bin/pg_config.sh" >> /etc/rc.local
fi

${_GREP} -q "${_SERVICE} postgresql01 start" /etc/rc.local
if [ $? -ne 0 ] ;then

    ${_ECHO} "#Start postgres on VM start-up
    ${_SERVICE} postgresql01 start" >> /etc/rc.local
fi

${_GREP} -q "ENM DBs specific" /etc/rc.local
if [ $? -ne 0 ] ;then

    ${_ECHO} "#ENM DBs specific
    . /ericsson/3pp/postgres/bin/createdb.sh" >> /etc/rc.local

fi

exit 0
