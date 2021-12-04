#!/usr/bin/env bash

echo "WARNING: next paths will be removed:

/etc/sphinx
/etc/logrotate.d/sphinx
/var/lib/sphinx/data
/var/log/sphinx
/usr/local/bin/indexer
/usr/local/bin/indextool
/usr/local/bin/searchd
/usr/local/bin/wordbreaker
/usr/lib/systemd/system/sphinx.service

"

echo -n "Press [Y] to continie or any key to cancel: "

read CONFIRM

if [[ "${CONFIRM}" != "y" && "${CONFIRM}" != "Y" ]]; then
    echo "Canceled..."
    exit 1
fi

systemctl stop sphinx.service
systemctl disable sphinx.service

rm -r /etc/sphinx /etc/logrotate.d/sphinx /var/lib/sphinx/data /var/log/sphinx /usr/local/bin/indexer /usr/local/bin/indextool /usr/local/bin/searchd /usr/local/bin/wordbreaker /usr/lib/systemd/system/sphinx.service
