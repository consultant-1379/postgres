#!/bin/bash
_LOGGER=/bin/logger
_BASENAME=/bin/basename
_SCRIPT_NAME="${_BASENAME} ${0}"
_LOG_TAG="postgres"
_ENM_GROUP=enm
_POSTGRES_USER=postgres
_POSTGRES_HOME=/home/postgres
_POSTGRES_UID=308
_USERADD=/usr/sbin/useradd

#//////////////////////////////////////////////////////////////
# This function will print an error message to /var/log/messages
# Arguments:
#       $1 - Message
# Return: 0
#//////////////////////////////////////////////////////////////
error()

{
    ${_LOGGER}  -t ${_LOG_TAG} -p user.err "ERROR ( ${_SCRIPT_NAME} ): $1"
}

#//////////////////////////////////////////////////////////////
# This function will print an info message to /var/log/messages
# Arguments:
#       $1 - Message
# Return: 0
#/////////////////////////////////////////////////////////////

info()
{
    ${_LOGGER}  -t ${_LOG_TAG} -p user.notice "INFORMATION ( ${_SCRIPT_NAME} ): $1"
}

#//////////////////////////////////////////////////////////////
# This function will create the postgres user
# Arguments:
#       None
# Return: 0
#/////////////////////////////////////////////////////////////

create_postgres_user_in_enm_group()

{
    info "Creating postgres user in ${_ENM_GROUP}"
    ${_USERADD} -d ${_POSTGRES_HOME} -g ${_ENM_GROUP} -u ${_POSTGRES_UID} ${_POSTGRES_USER} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        info "Addition of ${_POSTGRES_USER} to the ${_ENM_GROUP} group was successful"
    else
        error "Addition of ${_POSTGRES_USER} to the ${_ENM_GROUP} group failed"
    fi
}

exit 0
