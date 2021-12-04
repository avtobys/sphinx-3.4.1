# Sphinx service
Fast and automatic configuration of the sphinxsearch search service with the creation of a test base, indexes, service unit file, log rotation, and a simple php api

The service is automatically installed into the system on next paths

/etc/sphinx/sphinx.conf  
/etc/logrotate.d/sphinx  
/var/lib/sphinx/data  
/var/log/sphinx  
/usr/local/bin/indexer  
/usr/local/bin/indextool  
/usr/local/bin/searchd  
/usr/local/bin/wordbreaker  
/usr/lib/systemd/system/sphinx.service

Install SQL drivers before installing  

    apt install libmysqlclient-dev libpq-dev unixodbc-dev
    apt install libmariadb-client-lgpl-dev-compat

And run everything you need with one command
    chmod +x ./install.sh
    ./install.sh

Service management via systemctl

    systemctl start sphinx.service
    systemctl stop sphinx.service
    systemctl restart sphinx.service

Example easy install

    root@kali:~/sphinx-3.4.1# systemctl start mysql
    root@kali:~/sphinx-3.4.1# ./install.sh
    Enter MySQL root password(default is empty string):
    Check MySQL version...
    10.3.24-MariaDB-2
    Loading example dump from etc/example.sql
    Path will be created:

    /etc/sphinx (sphinx.conf will be hosted here)
    /var/lib/sphinx/data (paths to index and binlog files)
    /var/log/sphinx (paths to log files)

    WARNING: If directories exist, their contents will be removed

    Next files:

    bin/indexer
    bin/indextool
    bin/searchd
    bin/wordbreaker

    will be copied here:

    /usr/local/bin/indexer
    /usr/local/bin/indextool
    /usr/local/bin/searchd
    /usr/local/bin/wordbreaker

    will be created service unit file:

    /usr/lib/systemd/system/sphinx.service

    will be created logrotate file:

    /etc/logrotate.d/sphinx


    Press [Y] to continie or any key to cancel: y
    Failed to stop sphinx.service: Unit sphinx.service not loaded.
    Failed to disable unit: Unit file sphinx.service does not exist.
    Testing indexer... Create indexes sphinx_test.documents
    Sphinx 3.4.1 (commit efbcc65)
    Copyright (c) 2001-2021, Andrew Aksyonoff
    Copyright (c) 2008-2016, Sphinx Technologies Inc (http://sphinxsearch.com)

    using config file '/etc/sphinx/sphinx.conf'...
    indexing index 'index_documents'...
    collected 4 docs, 0.0 MB
    sorted 0.0 Mhits, 100.0% done
    total 4 docs, 0.2 Kb
    total 0.1 sec, 1.7 Kb/sec, 35 docs/sec


    Copy unit service file... /usr/lib/systemd/system/sphinx.service
    and start sphinx.service

    Created symlink /etc/systemd/system/multi-user.target.wants/sphinx.service > /lib/systemd/system/sphinx.service.
    ? sphinx.service - Sphinx service
        Loaded: loaded (/lib/systemd/system/sphinx.service; enabled; vendor preset: disabled)
        Active: active (running) since Sat 2021-12-04 11:30:03 MSK; 20ms ago
        Process: 1996 ExecStart=/usr/local/bin/searchd -c /etc/sphinx/sphinx.conf (code=exited, status=0/SUCCESS)
    Main PID: 1999 (searchd)
        Tasks: 9 (limit: 4620)
        Memory: 17.1M
            CPU: 17ms
        CGroup: /system.slice/sphinx.service
                +-1998 /usr/local/bin/searchd -c /etc/sphinx/sphinx.conf
                L-1999 /usr/local/bin/searchd -c /etc/sphinx/sphinx.conf

    ��� 04 11:30:03 kali searchd[1999]: listening on 127.0.0.1:9812
    ��� 04 11:30:03 kali searchd[1999]: Sphinx 3.4.1 (commit efbcc65)
    ��� 04 11:30:03 kali searchd[1999]: Copyright (c) 2001-2021, Andrew Aksyonoff
    ��� 04 11:30:03 kali searchd[1999]: Copyright (c) 2008-2016, Sphinx Technologies Inc (http://sphinxsearch.com)
    ��� 04 11:30:03 kali searchd[1999]: precaching index 'index_documents'
    ��� 04 11:30:03 kali searchd[1996]: Sphinx 3.4.1 (commit efbcc65)
    ��� 04 11:30:03 kali searchd[1996]: Copyright (c) 2001-2021, Andrew Aksyonoff
    ��� 04 11:30:03 kali searchd[1996]: Copyright (c) 2008-2016, Sphinx Technologies Inc (http://sphinxsearch.com)
    ��� 04 11:30:03 kali systemd[1]: sphinx.service: Supervising process 1999 which is not our child. We'll most likely not notice when it exits.
    ��� 04 11:30:03 kali systemd[1]: Started Sphinx service.
    Check Sphinx version...
    +------------------------+
    | 3.4.1 (commit efbcc65) |
    +------------------------+
    Check Sphinx index_documents...
    +-----------------+-------+
    | index_documents | local |
    +-----------------+-------+
    Check match query to mysql api...
    +------+------+------------+-----------------+---------------------------------------------------------------------------+
    |    1 |    5 | 1638606596 | test one        | this is my test document number one. also checking search within phrases. |
    |    2 |    6 | 1638606596 | test two        | this is my test document number two                                       |
    |    4 |    8 | 1638606596 | doc number four | this is to test groups                                                    |
    +------+------+------------+-----------------+---------------------------------------------------------------------------+
    Check match query to php api...
    {
        "error": "",
        "warning": "",
        "status": 0,
        "fields": [
            "title",
            "content"
        ],
        "attrs": {
            "group_id": 1,
            "date_added": 1,
            "title": 7,
            "content": 7,
            "snippet": 7
        },
        "matches": {
            "1": {
                "weight": "20539",
                "attrs": {
                    "group_id": 5,
                    "date_added": 1638606596,
                    "title": "test one",
                    "content": "this is my test document number one. also checking search within phrases.",
                    "snippet": "this is my <b>test<\/b> document number one.  ... "
                }
            },
            "2": {
                "weight": "20539",
                "attrs": {
                    "group_id": 6,
                    "date_added": 1638606596,
                    "title": "test two",
                    "content": "this is my test document number two",
                    "snippet": "this is my <b>test<\/b> document number two"
                }
            },
            "4": {
                "weight": "10392",
                "attrs": {
                    "group_id": 8,
                    "date_added": 1638606596,
                    "title": "doc number four",
                    "content": "this is to test groups",
                    "snippet": "this is to <b>test<\/b> groups"
                }
            }
        },
        "total": "3",
        "total_found": "3",
        "time": "0.001",
        "words": {
            "*test*": {
                "docs": "3",
                "hits": "5"
            },
            "=test": {
                "docs": "3",
                "hits": "5"
            },
            "test": {
                "docs": "3",
                "hits": "5"
            }
        }
    }
    root@kali:~/sphinx-3.4.1#


--------


Example uninstall output  

    root@kali:~/sphinx-3.4.1# ./uninstall.sh
    WARNING: next paths will be removed:

    /etc/sphinx
    /etc/logrotate.d/sphinx
    /var/lib/sphinx/data
    /var/log/sphinx
    /usr/local/bin/indexer
    /usr/local/bin/indextool
    /usr/local/bin/searchd
    /usr/local/bin/wordbreaker
    /usr/lib/systemd/system/sphinx.service


    Press [Y] to continie or any key to cancel: y
    Removed /etc/systemd/system/multi-user.target.wants/sphinx.service.
    root@kali:~/sphinx-3.4.1#

