#!/bin/bash
set -e

GO_WORK_DIR=${GO_WORK_DIR:-$GOPATH/src}

USER_ID=${USER_ID:-1000}
USERNAME=${USERNAME:-'dev'}
GROUP_ID=${GROUP_ID:-1000}
GROUPNAME=${GROUPNAME:-'dev'}
HOMEDIR=${HOMEDIR:-"/home/$USERNAME"}

if [ -z "`getent group $GROUP_ID`" ]; then
    addgroup -g $GROUP_ID $GROUPNAME
else
    groupmod -n $GROUPNAME `getent group $GROUP_ID | cut -d: -f1`
fi

if [ -z "`getent passwd $USER_ID`" ]; then
    adduser -u $USER_ID -G $GROUPNAME -h $HOMEDIR -D -s /bin/bash $USERNAME
else
    usermod -l $USERNAME -g $GROUP_ID -s /bin/bash -d $HOMEDIR -m `getent passwd $USER_ID | cut -d: -f1`
fi

mkdir -p $HOMEDIR/.ssh

cat > $HOMEDIR/.ssh/config <<EOL
Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOL

if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "$SSH_PRIVATE_KEY" > $HOMEDIR/.ssh/id_rsa
    chmod 0600 $HOMEDIR/.ssh/id_rsa

    if [ -n "$SSH_PUBLIC_KEY" ]; then
        echo "$SSH_PUBLIC_KEY" > $HOMEDIR/.ssh/id_rsa.pub
        chmod 0640 $HOMEDIR/.ssh/id_rsa.pub
    fi
fi

chown -R $USERNAME:$GROUPNAME $HOMEDIR
if [ -n "$GIT_USER_NAME" ]; then
    gosu $USERNAME git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "$GIT_USER_EMAIL" ]; then
    gosu $USERNAME /usr/bin/git config --global user.email "$GIT_USER_EMAIL"
fi

mkdir -p $GO_WORK_DIR
chown -R $USERNAME:$GROUPNAME $GO_WORK_DIR

gosu $USERNAME "$@"
