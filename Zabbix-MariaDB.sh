#! /bin/bash

# Zabbix Download
wget https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-2+debian$(cut -d"." -f1 /etc/debian_version)_all.deb
dpkg -i zabbix-release_6.2-2+debian$(cut -d"." -f1 /etc/debian_version)_all.deb
apt update
apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Instalando MariaDB database:

apt -y install mariadb-server

# Habilitando e iniciando serviços MariaDB

systemctl start mariadb
systemctl enable mariadb

# Configurado MariaDB
mysql_secure_installation

# Create database
mysql -uroot -p'rootDBpass' -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -p'rootDBpass' -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixDBpass';"

# Importe esquema e dados iniciais

zcat  /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p'zabbixDBpass' zabbix

echo "# This is a configuration file for Zabbix server daemon
    2 # To get more information about Zabbix, visit http://www.zabbix.com
    3 
    4 ############ GENERAL PARAMETERS #################
    5 
    6 ### Option: ListenPort
    7 #   Listen port for trapper.
    8 #
    9 # Mandatory: no
   10 # Range: 1024-32767
   11 # Default:
   12 # ListenPort=10051
   13 
   14 ### Option: SourceIP
   15 #   Source IP address for outgoing connections.
   16 #
   17 # Mandatory: no
   18 # Default:
   19 # SourceIP=
   20 
   21 ### Option: LogType
   22 #   Specifies where log messages are written to:
   23 #       system  - syslog
   24 #       file    - file specified with LogFile parameter
   25 #       console - standard output
   26 #
   27 # Mandatory: no
   28 # Default:
   29 # LogType=file
   30 
   31 ### Option: LogFile
   32 #   Log file name for LogType 'file' parameter.
   33 #
   34 # Mandatory: yes, if LogType is set to file, otherwise no
   35 # Default:
   36 # LogFile=
   37 
   38 LogFile=/tmp/zabbix_server.log
   39 
   40 ### Option: LogFileSize
   41 #   Maximum size of log file in MB.
   42 #   0 - disable automatic log rotation.
   43 #
   44 # Mandatory: no
   45 # Range: 0-1024
   46 # Default:
   47 # LogFileSize=1
   48 
   49 ### Option: DebugLevel
   50 #   Specifies debug level:
   51 #   0 - basic information about starting and stopping of Zabbix processes
   52 #   1 - critical information
   53 #   2 - error information
   54 #   3 - warnings
   55 #   4 - for debugging (produces lots of information)
   56 #   5 - extended debugging (produces even more information)
   57 #
   58 # Mandatory: no
   59 # Range: 0-5
   60 # Default:
   61 # DebugLevel=3
   62 
   63 ### Option: PidFile
   64 #   Name of PID file.
   65 #
   66 # Mandatory: no
   67 # Default:
   68 # PidFile=/tmp/zabbix_server.pid
   69 
   70 ### Option: SocketDir
   71 #   IPC socket directory.
   72 #       Directory to store IPC sockets used by internal Zabbix services.
   73 #
   74 # Mandatory: no
   75 # Default:
   76 # SocketDir=/tmp
   77 
   78 ### Option: DBHost
   79 #   Database host name.
   80 #   If set to localhost, socket is used for MySQL.
   81 #   If set to empty string, socket is used for PostgreSQL.
   82 #   If set to empty string, the Net Service Name connection method is used to connect to Oracle database; also see
   83 #   the TNS_ADMIN environment variable to specify the directory where the tnsnames.ora file is located.
   84 #
   85 # Mandatory: no
   86 # Default:
   87 # DBHost=localhost
   88 
   89 ### Option: DBName
   90 #   Database name.
   91 #   If the Net Service Name connection method is used to connect to Oracle database, specify the service name from
   92 #   the tnsnames.ora file or set to empty string; also see the TWO_TASK environment variable if DBName is set to
   93 #   empty string.
   94 #
   95 # Mandatory: yes
   96 # Default:
   97 # DBName=
   98 
   99 DBName=zabbix
  100 
  101 ### Option: DBSchema
  102 #   Schema name. Used for PostgreSQL.
  103 #
  104 # Mandatory: no
  105 # Default:
  106 # DBSchema=
  107 
  108 ### Option: DBUser
  109 #   Database user.
  110 #
  111 # Mandatory: no
  112 # Default:
  113 # DBUser=
  114 
  115 DBUser=zabbix
  116 
  117 ### Option: DBPassword
  118 #   Database password.
  119 #   Comment this line if no password is used.
  120 #
  121 # Mandatory: no
  122 # Default:
  123   DBPassword=zabbixDBpass
  124 
  125 ### Option: DBSocket
  126 #   Path to MySQL socket.
  127 #
  128 # Mandatory: no
  129 # Default:
  130 # DBSocket=
  131 
  132 ### Option: DBPort
  133 #   Database port when not using local socket.
  134 #   If the Net Service Name connection method is used to connect to Oracle database, the port number from the
  135 #   tnsnames.ora file will be used. The port number set here will be ignored.
  136 #
  137 # Mandatory: no
  138 # Range: 1024-65535
  139 # Default:
  140 # DBPort=
  141 
  142 ### Option: AllowUnsupportedDBVersions
  143 #   Allow server to work with unsupported database versions.
  144 #       0 - do not allow
  145 #       1 - allow
  146 #
  147 # Mandatory: no
  148 # Default:
  149 # AllowUnsupportedDBVersions=0
  150 
  151 ### Option: HistoryStorageURL
  152 #   History storage HTTP[S] URL.
  153 #
  154 # Mandatory: no
  155 # Default:
  156 # HistoryStorageURL=
  157 
  158 ### Option: HistoryStorageTypes
  159 #   Comma separated list of value types to be sent to the history storage.
  160 #
  161 # Mandatory: no
  162 # Default:
  163 # HistoryStorageTypes=uint,dbl,str,log,text
  164 
  165 ### Option: HistoryStorageDateIndex
  166 #   Enable preprocessing of history values in history storage to store values in different indices based on date.
  167 #   0 - disable
  168 #   1 - enable
  169 #
  170 # Mandatory: no
  171 # Default:
  172 # HistoryStorageDateIndex=0
  173 
  174 ### Option: ExportDir
  175 #   Directory for real time export of events, history and trends in newline delimited JSON format.
  176 #   If set, enables real time export.
  177 #
  178 # Mandatory: no
  179 # Default:
  180 # ExportDir=
  181 
  182 ### Option: ExportFileSize
  183 #   Maximum size per export file in bytes.
  184 #   Only used for rotation if ExportDir is set.
  185 #
  186 # Mandatory: no
  187 # Range: 1M-1G
  188 # Default:
  189 # ExportFileSize=1G
  190 
  191 ### Option: ExportType
  192 #   List of comma delimited types of real time export - allows to control export entities by their
  193 #   type (events, history, trends) individually.
  194 #   Valid only if ExportDir is set.
  195 #
  196 # Mandatory: no
  197 # Default:
  198 # ExportType=events,history,trends
  199 
  200 ############ ADVANCED PARAMETERS ################
  201 
  202 ### Option: StartPollers
  203 #   Number of pre-forked instances of pollers.
  204 #
  205 # Mandatory: no
  206 # Range: 0-1000
  207 # Default:
  208 # StartPollers=5
  209 
  210 ### Option: StartIPMIPollers
  211 #   Number of pre-forked instances of IPMI pollers.
  212 #       The IPMI manager process is automatically started when at least one IPMI poller is started.
  213 #
  214 # Mandatory: no
  215 # Range: 0-1000
  216 # Default:
  217 # StartIPMIPollers=0
  218 
  219 ### Option: StartPreprocessors
  220 #   Number of pre-forked instances of preprocessing workers.
  221 #       The preprocessing manager process is automatically started when preprocessor worker is started.
  222 #
  223 # Mandatory: no
  224 # Range: 1-1000
  225 # Default:
  226 # StartPreprocessors=3
  227 
  228 ### Option: StartPollersUnreachable
  229 #   Number of pre-forked instances of pollers for unreachable hosts (including IPMI and Java).
  230 #   At least one poller for unreachable hosts must be running if regular, IPMI or Java pollers
  231 #   are started.
  232 #
  233 # Mandatory: no
  234 # Range: 0-1000
  235 # Default:
  236 # StartPollersUnreachable=1
  237 
  238 ### Option: StartHistoryPollers
  239 #   Number of pre-forked instances of history pollers.
  240 #   Only required for calculated checks.
  241 #   A database connection is required for each history poller instance.
  242 #
  243 # Mandatory: no
  244 # Range: 0-1000
  245 # Default:
  246 # StartHistoryPollers=5
  247 
  248 ### Option: StartTrappers
  249 #   Number of pre-forked instances of trappers.
  250 #   Trappers accept incoming connections from Zabbix sender, active agents and active proxies.
  251 #   At least one trapper process must be running to display server availability and view queue
  252 #   in the frontend.
  253 #
  254 # Mandatory: no
  255 # Range: 0-1000
  256 # Default:
  257 # StartTrappers=5
  258 
  259 ### Option: StartPingers
  260 #   Number of pre-forked instances of ICMP pingers.
  261 #
  262 # Mandatory: no
  263 # Range: 0-1000
  264 # Default:
  265 # StartPingers=1
  266 
  267 ### Option: StartDiscoverers
  268 #   Number of pre-forked instances of discoverers.
  269 #
  270 # Mandatory: no
  271 # Range: 0-250
  272 # Default:
  273 # StartDiscoverers=1
  274 
  275 ### Option: StartHTTPPollers
  276 #   Number of pre-forked instances of HTTP pollers.
  277 #
  278 # Mandatory: no
  279 # Range: 0-1000
  280 # Default:
  281 # StartHTTPPollers=1
  282 
  283 ### Option: StartTimers
  284 #   Number of pre-forked instances of timers.
  285 #   Timers process maintenance periods.
  286 #   Only the first timer process handles host maintenance updates. Problem suppression updates are shared
  287 #   between all timers.
  288 #
  289 # Mandatory: no
  290 # Range: 1-1000
  291 # Default:
  292 # StartTimers=1
  293 
  294 ### Option: StartEscalators
  295 #   Number of pre-forked instances of escalators.
  296 #
  297 # Mandatory: no
  298 # Range: 1-100
  299 # Default:
  300 # StartEscalators=1
  301 
  302 ### Option: StartAlerters
  303 #   Number of pre-forked instances of alerters.
  304 #   Alerters send the notifications created by action operations.
  305 #
  306 # Mandatory: no
  307 # Range: 1-100
  308 # Default:
  309 # StartAlerters=3
  310 
  311 ### Option: JavaGateway
  312 #   IP address (or hostname) of Zabbix Java gateway.
  313 #   Only required if Java pollers are started.
  314 #
  315 # Mandatory: no
  316 # Default:
  317 # JavaGateway=
  318 
  319 ### Option: JavaGatewayPort
  320 #   Port that Zabbix Java gateway listens on.
  321 #
  322 # Mandatory: no
  323 # Range: 1024-32767
  324 # Default:
  325 # JavaGatewayPort=10052
  326 
  327 ### Option: StartJavaPollers
  328 #   Number of pre-forked instances of Java pollers.
  329 #
  330 # Mandatory: no
  331 # Range: 0-1000
  332 # Default:
  333 # StartJavaPollers=0
  334 
  335 ### Option: StartVMwareCollectors
  336 #   Number of pre-forked vmware collector instances.
  337 #
  338 # Mandatory: no
  339 # Range: 0-250
  340 # Default:
  341 # StartVMwareCollectors=0
  342 
  343 ### Option: VMwareFrequency
  344 #   How often Zabbix will connect to VMware service to obtain a new data.
  345 #
  346 # Mandatory: no
  347 # Range: 10-86400
  348 # Default:
  349 # VMwareFrequency=60
  350 
  351 ### Option: VMwarePerfFrequency
  352 #   How often Zabbix will connect to VMware service to obtain performance data.
  353 #
  354 # Mandatory: no
  355 # Range: 10-86400
  356 # Default:
  357 # VMwarePerfFrequency=60
  358 
  359 ### Option: VMwareCacheSize
  360 #   Size of VMware cache, in bytes.
  361 #   Shared memory size for storing VMware data.
  362 #   Only used if VMware collectors are started.
  363 #
  364 # Mandatory: no
  365 # Range: 256K-2G
  366 # Default:
  367 # VMwareCacheSize=8M
  368 
  369 ### Option: VMwareTimeout
  370 #   Specifies how many seconds vmware collector waits for response from VMware service.
  371 #
  372 # Mandatory: no
  373 # Range: 1-300
  374 # Default:
  375 # VMwareTimeout=10
  376 
  377 ### Option: SNMPTrapperFile
  378 #   Temporary file used for passing data from SNMP trap daemon to the server.
  379 #   Must be the same as in zabbix_trap_receiver.pl or SNMPTT configuration file.
  380 #
  381 # Mandatory: no
  382 # Default:
  383 # SNMPTrapperFile=/tmp/zabbix_traps.tmp
  384 
  385 ### Option: StartSNMPTrapper
  386 #   If 1, SNMP trapper process is started.
  387 #
  388 # Mandatory: no
  389 # Range: 0-1
  390 # Default:
  391 # StartSNMPTrapper=0
  392 
  393 ### Option: ListenIP
  394 #   List of comma delimited IP addresses that the trapper should listen on.
  395 #   Trapper will listen on all network interfaces if this parameter is missing.
  396 #
  397 # Mandatory: no
  398 # Default:
  399 # ListenIP=0.0.0.0
  400 
  401 ### Option: HousekeepingFrequency
  402 #   How often Zabbix will perform housekeeping procedure (in hours).
  403 #   Housekeeping is removing outdated information from the database.
  404 #   To prevent Housekeeper from being overloaded, no more than 4 times HousekeepingFrequency
  405 #   hours of outdated information are deleted in one housekeeping cycle, for each item.
  406 #   To lower load on server startup housekeeping is postponed for 30 minutes after server start.
  407 #   With HousekeepingFrequency=0 the housekeeper can be only executed using the runtime control option.
  408 #   In this case the period of outdated information deleted in one housekeeping cycle is 4 times the
  409 #   period since the last housekeeping cycle, but not less than 4 hours and not greater than 4 days.
  410 #
  411 # Mandatory: no
  412 # Range: 0-24
  413 # Default:
  414 # HousekeepingFrequency=1
  415 
  416 ### Option: MaxHousekeeperDelete
  417 #   The table "housekeeper" contains "tasks" for housekeeping procedure in the format:
  418 #   [housekeeperid], [tablename], [field], [value].
  419 #   No more than 'MaxHousekeeperDelete' rows (corresponding to [tablename], [field], [value])
  420 #   will be deleted per one task in one housekeeping cycle.
  421 #   If set to 0 then no limit is used at all. In this case you must know what you are doing!
  422 #
  423 # Mandatory: no
  424 # Range: 0-1000000
  425 # Default:
  426 # MaxHousekeeperDelete=5000
  427 
  428 ### Option: CacheSize
  429 #   Size of configuration cache, in bytes.
  430 #   Shared memory size for storing host, item and trigger data.
  431 #
  432 # Mandatory: no
  433 # Range: 128K-64G
  434 # Default:
  435 # CacheSize=32M
  436 
  437 ### Option: CacheUpdateFrequency
  438 #   How often Zabbix will perform update of configuration cache, in seconds.
  439 #
  440 # Mandatory: no
  441 # Range: 1-3600
  442 # Default:
  443 # CacheUpdateFrequency=60
  444 
  445 ### Option: StartDBSyncers
  446 #   Number of pre-forked instances of DB Syncers.
  447 #
  448 # Mandatory: no
  449 # Range: 1-100
  450 # Default:
  451 # StartDBSyncers=4
  452 
  453 ### Option: HistoryCacheSize
  454 #   Size of history cache, in bytes.
  455 #   Shared memory size for storing history data.
  456 #
  457 # Mandatory: no
  458 # Range: 128K-2G
  459 # Default:
  460 # HistoryCacheSize=16M
  461 
  462 ### Option: HistoryIndexCacheSize
  463 #   Size of history index cache, in bytes.
  464 #   Shared memory size for indexing history cache.
  465 #
  466 # Mandatory: no
  467 # Range: 128K-2G
  468 # Default:
  469 # HistoryIndexCacheSize=4M
  470 
  471 ### Option: TrendCacheSize
  472 #   Size of trend write cache, in bytes.
  473 #   Shared memory size for storing trends data.
  474 #
  475 # Mandatory: no
  476 # Range: 128K-2G
  477 # Default:
  478 # TrendCacheSize=4M
  479 
  480 ### Option: TrendFunctionCacheSize
  481 #   Size of trend function cache, in bytes.
  482 #   Shared memory size for caching calculated trend function data.
  483 #
  484 # Mandatory: no
  485 # Range: 128K-2G
  486 # Default:
  487 # TrendFunctionCacheSize=4M
  488 
  489 ### Option: ValueCacheSize
  490 #   Size of history value cache, in bytes.
  491 #   Shared memory size for caching item history data requests.
  492 #   Setting to 0 disables value cache.
  493 #
  494 # Mandatory: no
  495 # Range: 0,128K-64G
  496 # Default:
  497 # ValueCacheSize=8M
  498 
  499 ### Option: Timeout
  500 #   Specifies how long we wait for agent, SNMP device or external check (in seconds).
  501 #
  502 # Mandatory: no
  503 # Range: 1-30
  504 # Default:
  505 # Timeout=3
  506 
  507 Timeout=4
  508 
  509 ### Option: TrapperTimeout
  510 #   Specifies how many seconds trapper may spend processing new data.
  511 #
  512 # Mandatory: no
  513 # Range: 1-300
  514 # Default:
  515 # TrapperTimeout=300
  516 
  517 ### Option: UnreachablePeriod
  518 #   After how many seconds of unreachability treat a host as unavailable.
  519 #
  520 # Mandatory: no
  521 # Range: 1-3600
  522 # Default:
  523 # UnreachablePeriod=45
  524 
  525 ### Option: UnavailableDelay
  526 #   How often host is checked for availability during the unavailability period, in seconds.
  527 #
  528 # Mandatory: no
  529 # Range: 1-3600
  530 # Default:
  531 # UnavailableDelay=60
  532 
  533 ### Option: UnreachableDelay
  534 #   How often host is checked for availability during the unreachability period, in seconds.
  535 #
  536 # Mandatory: no
  537 # Range: 1-3600
  538 # Default:
  539 # UnreachableDelay=15
  540 
  541 ### Option: AlertScriptsPath
  542 #   Full path to location of custom alert scripts.
  543 #   Default depends on compilation options.
  544 #   To see the default path run command "zabbix_server --help".
  545 #
  546 # Mandatory: no
  547 # Default:
  548 # AlertScriptsPath=${datadir}/zabbix/alertscripts
  549 
  550 ### Option: ExternalScripts
  551 #   Full path to location of external scripts.
  552 #   Default depends on compilation options.
  553 #   To see the default path run command "zabbix_server --help".
  554 #
  555 # Mandatory: no
  556 # Default:
  557 # ExternalScripts=${datadir}/zabbix/externalscripts
  558 
  559 ### Option: FpingLocation
  560 #   Location of fping.
  561 #   Make sure that fping binary has root ownership and SUID flag set.
  562 #
  563 # Mandatory: no
  564 # Default:
  565 # FpingLocation=/usr/sbin/fping
  566 
  567 ### Option: Fping6Location
  568 #   Location of fping6.
  569 #   Make sure that fping6 binary has root ownership and SUID flag set.
  570 #   Make empty if your fping utility is capable to process IPv6 addresses.
  571 #
  572 # Mandatory: no
  573 # Default:
  574 # Fping6Location=/usr/sbin/fping6
  575 
  576 ### Option: SSHKeyLocation
  577 #   Location of public and private keys for SSH checks and actions.
  578 #
  579 # Mandatory: no
  580 # Default:
  581 # SSHKeyLocation=
  582 
  583 ### Option: LogSlowQueries
  584 #   How long a database query may take before being logged (in milliseconds).
  585 #   Only works if DebugLevel set to 3, 4 or 5.
  586 #   0 - don't log slow queries.
  587 #
  588 # Mandatory: no
  589 # Range: 1-3600000
  590 # Default:
  591 # LogSlowQueries=0
  592 
  593 LogSlowQueries=3000
  594 
  595 ### Option: TmpDir
  596 #   Temporary directory.
  597 #
  598 # Mandatory: no
  599 # Default:
  600 # TmpDir=/tmp
  601 
  602 ### Option: StartProxyPollers
  603 #   Number of pre-forked instances of pollers for passive proxies.
  604 #
  605 # Mandatory: no
  606 # Range: 0-250
  607 # Default:
  608 # StartProxyPollers=1
  609 
  610 ### Option: ProxyConfigFrequency
  611 #   How often Zabbix Server sends configuration data to a Zabbix Proxy in seconds.
  612 #   This parameter is used only for proxies in the passive mode.
  613 #
  614 # Mandatory: no
  615 # Range: 1-3600*24*7
  616 # Default:
  617 # ProxyConfigFrequency=300
  618 
  619 ### Option: ProxyDataFrequency
  620 #   How often Zabbix Server requests history data from a Zabbix Proxy in seconds.
  621 #   This parameter is used only for proxies in the passive mode.
  622 #
  623 # Mandatory: no
  624 # Range: 1-3600
  625 # Default:
  626 # ProxyDataFrequency=1
  627 
  628 ### Option: StartLLDProcessors
  629 #   Number of pre-forked instances of low level discovery processors.
  630 #
  631 # Mandatory: no
  632 # Range: 1-100
  633 # Default:
  634 # StartLLDProcessors=2
  635 
  636 ### Option: AllowRoot
  637 #   Allow the server to run as 'root'. If disabled and the server is started by 'root', the server
  638 #   will try to switch to the user specified by the User configuration option instead.
  639 #   Has no effect if started under a regular user.
  640 #   0 - do not allow
  641 #   1 - allow
  642 #
  643 # Mandatory: no
  644 # Default:
  645 # AllowRoot=0
  646 
  647 ### Option: User
  648 #   Drop privileges to a specific, existing user on the system.
  649 #   Only has effect if run as 'root' and AllowRoot is disabled.
  650 #
  651 # Mandatory: no
  652 # Default:
  653 # User=zabbix
  654 
  655 ### Option: Include
  656 #   You may include individual files or all files in a directory in the configuration file.
  657 #   Installing Zabbix will create include directory in /usr/local/etc, unless modified during the compile time.
  658 #
  659 # Mandatory: no
  660 # Default:
  661 # Include=
  662 
  663 # Include=/usr/local/etc/zabbix_server.general.conf
  664 # Include=/usr/local/etc/zabbix_server.conf.d/
  665 # Include=/usr/local/etc/zabbix_server.conf.d/*.conf
  666 
  667 ### Option: SSLCertLocation
  668 #   Location of SSL client certificates.
  669 #   This parameter is used only in web monitoring.
  670 #   Default depends on compilation options.
  671 #   To see the default path run command "zabbix_server --help".
  672 #
  673 # Mandatory: no
  674 # Default:
  675 # SSLCertLocation=${datadir}/zabbix/ssl/certs
  676 
  677 ### Option: SSLKeyLocation
  678 #   Location of private keys for SSL client certificates.
  679 #   This parameter is used only in web monitoring.
  680 #   Default depends on compilation options.
  681 #   To see the default path run command "zabbix_server --help".
  682 #
  683 # Mandatory: no
  684 # Default:
  685 # SSLKeyLocation=${datadir}/zabbix/ssl/keys
  686 
  687 ### Option: SSLCALocation
  688 #   Override the location of certificate authority (CA) files for SSL server certificate verification.
  689 #   If not set, system-wide directory will be used.
  690 #   This parameter is used in web monitoring, SMTP authentication, HTTP agent items and for communication with Vault.
  691 #
  692 # Mandatory: no
  693 # Default:
  694 # SSLCALocation=
  695 
  696 ### Option: StatsAllowedIP
  697 #   List of comma delimited IP addresses, optionally in CIDR notation, or DNS names of external Zabbix instances.
  698 #   Stats request will be accepted only from the addresses listed here. If this parameter is not set no stats requests
  699 #   will be accepted.
  700 #   If IPv6 support is enabled then '127.0.0.1', '::127.0.0.1', '::ffff:127.0.0.1' are treated equally
  701 #   and '::/0' will allow any IPv4 or IPv6 address.
  702 #   '0.0.0.0/0' can be used to allow any IPv4 address.
  703 #   Example: StatsAllowedIP=127.0.0.1,192.168.1.0/24,::1,2001:db8::/32,zabbix.example.com
  704 #
  705 # Mandatory: no
  706 # Default:
  707 # StatsAllowedIP=
  708 StatsAllowedIP=127.0.0.1
  709 
  710 ####### LOADABLE MODULES #######
  711 
  712 ### Option: LoadModulePath
  713 #   Full path to location of server modules.
  714 #   Default depends on compilation options.
  715 #   To see the default path run command "zabbix_server --help".
  716 #
  717 # Mandatory: no
  718 # Default:
  719 # LoadModulePath=${libdir}/modules
  720 
  721 ### Option: LoadModule
  722 #   Module to load at server startup. Modules are used to extend functionality of the server.
  723 #   Formats:
  724 #       LoadModule=<module.so>
  725 #       LoadModule=<path/module.so>
  726 #       LoadModule=</abs_path/module.so>
  727 #   Either the module must be located in directory specified by LoadModulePath or the path must precede the module name.
  728 #   If the preceding path is absolute (starts with '/') then LoadModulePath is ignored.
  729 #   It is allowed to include multiple LoadModule parameters.
  730 #
  731 # Mandatory: no
  732 # Default:
  733 # LoadModule=
  734 
  735 ####### TLS-RELATED PARAMETERS #######
  736 
  737 ### Option: TLSCAFile
  738 #   Full pathname of a file containing the top-level CA(s) certificates for
  739 #   peer certificate verification.
  740 #
  741 # Mandatory: no
  742 # Default:
  743 # TLSCAFile=
  744 
  745 ### Option: TLSCRLFile
  746 #   Full pathname of a file containing revoked certificates.
  747 #
  748 # Mandatory: no
  749 # Default:
  750 # TLSCRLFile=
  751 
  752 ### Option: TLSCertFile
  753 #   Full pathname of a file containing the server certificate or certificate chain.
  754 #
  755 # Mandatory: no
  756 # Default:
  757 # TLSCertFile=
  758 
  759 ### Option: TLSKeyFile
  760 #   Full pathname of a file containing the server private key.
  761 #
  762 # Mandatory: no
  763 # Default:
  764 # TLSKeyFile=
  765 
  766 ####### For advanced users - TLS ciphersuite selection criteria #######
  767 
  768 ### Option: TLSCipherCert13
  769 #   Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3.
  770 #   Override the default ciphersuite selection criteria for certificate-based encryption.
  771 #
  772 # Mandatory: no
  773 # Default:
  774 # TLSCipherCert13=
  775 
  776 ### Option: TLSCipherCert
  777 #   GnuTLS priority string or OpenSSL (TLS 1.2) cipher string.
  778 #   Override the default ciphersuite selection criteria for certificate-based encryption.
  779 #   Example for GnuTLS:
  780 #       NONE:+VERS-TLS1.2:+ECDHE-RSA:+RSA:+AES-128-GCM:+AES-128-CBC:+AEAD:+SHA256:+SHA1:+CURVE-ALL:+COMP-NULL:+SIGN-ALL:+CTYPE-X.509
  781 #   Example for OpenSSL:
  782 #       EECDH+aRSA+AES128:RSA+aRSA+AES128
  783 #
  784 # Mandatory: no
  785 # Default:
  786 # TLSCipherCert=
  787 
  788 ### Option: TLSCipherPSK13
  789 #   Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3.
  790 #   Override the default ciphersuite selection criteria for PSK-based encryption.
  791 #   Example:
  792 #       TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
  793 #
  794 # Mandatory: no
  795 # Default:
  796 # TLSCipherPSK13=
  797 
  798 ### Option: TLSCipherPSK
  799 #   GnuTLS priority string or OpenSSL (TLS 1.2) cipher string.
  800 #   Override the default ciphersuite selection criteria for PSK-based encryption.
  801 #   Example for GnuTLS:
  802 #       NONE:+VERS-TLS1.2:+ECDHE-PSK:+PSK:+AES-128-GCM:+AES-128-CBC:+AEAD:+SHA256:+SHA1:+CURVE-ALL:+COMP-NULL:+SIGN-ALL
  803 #   Example for OpenSSL:
  804 #       kECDHEPSK+AES128:kPSK+AES128
  805 #
  806 # Mandatory: no
  807 # Default:
  808 # TLSCipherPSK=
  809 
  810 ### Option: TLSCipherAll13
  811 #   Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3.
  812 #   Override the default ciphersuite selection criteria for certificate- and PSK-based encryption.
  813 #   Example:
  814 #       TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
  815 #
  816 # Mandatory: no
  817 # Default:
  818 # TLSCipherAll13=
  819 
  820 ### Option: TLSCipherAll
  821 #   GnuTLS priority string or OpenSSL (TLS 1.2) cipher string.
  822 #   Override the default ciphersuite selection criteria for certificate- and PSK-based encryption.
  823 #   Example for GnuTLS:
  824 #       NONE:+VERS-TLS1.2:+ECDHE-RSA:+RSA:+ECDHE-PSK:+PSK:+AES-128-GCM:+AES-128-CBC:+AEAD:+SHA256:+SHA1:+CURVE-ALL:+COMP-NULL:+SIGN-ALL:+CTYPE-X.509
  825 #   Example for OpenSSL:
  826 #       EECDH+aRSA+AES128:RSA+aRSA+AES128:kECDHEPSK+AES128:kPSK+AES128
  827 #
  828 # Mandatory: no
  829 # Default:
  830 # TLSCipherAll=
  831 
  832 ### Option: DBTLSConnect
  833 #   Setting this option enforces to use TLS connection to database.
  834 #   required    - connect using TLS
  835 #   verify_ca   - connect using TLS and verify certificate
  836 #   verify_full - connect using TLS, verify certificate and verify that database identity specified by DBHost
  837 #                 matches its certificate
  838 #   On MySQL starting from 5.7.11 and PostgreSQL following values are supported: "required", "verify_ca" and
  839 #   "verify_full".
  840 #   On MariaDB starting from version 10.2.6 "required" and "verify_full" values are supported.
  841 #   Default is not to set any option and behavior depends on database configuration
  842 #
  843 # Mandatory: no
  844 # Default:
  845 # DBTLSConnect=
  846 
  847 ### Option: DBTLSCAFile
  848 #   Full pathname of a file containing the top-level CA(s) certificates for database certificate verification.
  849 #   Supported only for MySQL and PostgreSQL
  850 #
  851 # Mandatory: no
  852 #   (yes, if DBTLSConnect set to one of: verify_ca, verify_full)
  853 # Default:
  854 # DBTLSCAFile=
  855 
  856 ### Option: DBTLSCertFile
  857 #   Full pathname of file containing Zabbix server certificate for authenticating to database.
  858 #   Supported only for MySQL and PostgreSQL
  859 #
  860 # Mandatory: no
  861 # Default:
  862 # DBTLSCertFile=
  863 
  864 ### Option: DBTLSKeyFile
  865 #   Full pathname of file containing the private key for authenticating to database.
  866 #   Supported only for MySQL and PostgreSQL
  867 #
  868 # Mandatory: no
  869 # Default:
  870 # DBTLSKeyFile=
  871 
  872 ### Option: DBTLSCipher
  873 #   The list of encryption ciphers that Zabbix server permits for TLS protocols up through TLSv1.2
  874 #   Supported only for MySQL
  875 #
  876 # Mandatory no
  877 # Default:
  878 # DBTLSCipher=
  879 
  880 ### Option: DBTLSCipher13
  881 #   The list of encryption ciphersuites that Zabbix server permits for TLSv1.3 protocol
  882 #   Supported only for MySQL, starting from version 8.0.16
  883 #
  884 # Mandatory no
  885 # Default:
  886 # DBTLSCipher13=
  887 
  888 ### Option: Vault
  889 #   Specifies vault:
  890 #       HashiCorp - HashiCorp KV Secrets Engine - Version 2
  891 #       CyberArk  - CyberArk Central Credential Provider
  892 #
  893 # Mandatory: no
  894 # Default:
  895 # Vault=HashiCorp
  896 
  897 ### Option: VaultToken
  898 #   Vault authentication token that should have been generated exclusively for Zabbix server with read only permission
  899 #   to paths specified in Vault macros and read only permission to path specified in optional VaultDBPath
  900 #   configuration parameter.
  901 #   It is an error if VaultToken and VAULT_TOKEN environment variable are defined at the same time.
  902 #
  903 # Mandatory: no
  904 #   (yes, if Vault is explicitly set to HashiCorp)
  905 # Default:
  906 # VaultToken=
  907 
  908 ### Option: VaultURL
  909 #   Vault server HTTP[S] URL. System-wide CA certificates directory will be used if SSLCALocation is not specified.
  910 #
  911 # Mandatory: no
  912 # Default:
  913 # VaultURL=https://127.0.0.1:8200
  914 
  915 ### Option: VaultDBPath
  916 #   Vault path or query depending on the Vault from where credentials for database will be retrieved by keys.
  917 #   Keys used for HashiCorp are 'password' and 'username'.
  918 #   Example path:
  919 #       secret/zabbix/database
  920 #   Keys used for CyberArk are 'Content' and 'UserName'.
  921 #   Example query:
  922 #       AppID=zabbix_server&Query=Safe=passwordSafe;Object=zabbix_server_database
  923 #   This option can only be used if DBUser and DBPassword are not specified.
  924 #
  925 # Mandatory: no
  926 # Default:
  927 # VaultDBPath=
  928 
  929 ### Option: VaultTLSCertFile
  930 #   Name of the SSL certificate file used for client authentication. The certificate file must be in PEM1 format.
  931 #   If the certificate file contains also the private key, leave the SSL key file field empty. The directory
  932 #   containing this file is specified by configuration parameter SSLCertLocation.
  933 #
  934 # Mandatory: no
  935 # Default:
  936 # VaultTLSCertFile=
  937 
  938 ### Option: VaultTLSKeyFile
  939 #   Name of the SSL private key file used for client authentication. The private key file must be in PEM1 format.
  940 #   The directory containing this file is specified by configuration parameter SSLKeyLocation.
  941 #
  942 # Mandatory: no
  943 # Default:
  944 # VaultTLSKeyFile=
  945 
  946 ### Option: StartReportWriters
  947 #   Number of pre-forked report writer instances.
  948 #
  949 # Mandatory: no
  950 # Range: 0-100
  951 # Default:
  952 # StartReportWriters=0
  953 
  954 ### Option: WebServiceURL
  955 #   URL to Zabbix web service, used to perform web related tasks.
  956 #   Example: http://localhost:10053/report
  957 #
  958 # Mandatory: no
  959 # Default:
  960 # WebServiceURL=
  961 
  962 ### Option: ServiceManagerSyncFrequency
  963 #   How often Zabbix will synchronize configuration of a service manager (in seconds).
  964 #
  965 # Mandatory: no
  966 # Range: 1-3600
  967 # Default:
  968 # ServiceManagerSyncFrequency=60
  969 
  970 ### Option: ProblemHousekeepingFrequency
  971 #   How often Zabbix will delete problems for deleted triggers (in seconds).
  972 #
  973 # Mandatory: no
  974 # Range: 1-3600
  975 # Default:
  976 # ProblemHousekeepingFrequency=60
  977 
  978 ## Option: StartODBCPollers
  979 #   Number of pre-forked ODBC poller instances.
  980 #
  981 # Mandatory: no
  982 # Range: 0-1000
  983 # Default:
  984 # StartODBCPollers=1
  985 
  986 ####### For advanced users - TCP-related fine-tuning parameters #######
  987 
  988 ## Option: ListenBacklog
  989 #       The maximum number of pending connections in the queue. This parameter is passed to
  990 #       listen() function as argument 'backlog' (see "man listen").
  991 #
  992 # Mandatory: no
  993 # Range: 0 - INT_MAX (depends on system, too large values may be silently truncated to implementation-specified maximum)
  994 # Default: SOMAXCONN (hard-coded constant, depends on system)
  995 # ListenBacklog=
  996 
  997 
  998 ####### High availability cluster parameters #######
  999 
 1000 ## Option: HANodeName
 1001 #   The high availability cluster node name.
 1002 #   When empty, server is working in standalone mode; a node with empty name is registered with address for the frontend to connect to.
 1003 #
 1004 # Mandatory: no
 1005 # Default: 
 1006 # HANodeName=
 1007 
 1008 ## Option: NodeAddress
 1009 #   IP or hostname with optional port to specify how frontend should connect to the server.
 1010 #   Format: <address>[:<port>]
 1011 #
 1012 #   If IP or hostname is not set, then ListenIP value will be used. In case ListenIP is not set, localhost will be used.
 1013 #   If port is not set, then ListenPort value will be used. In case ListenPort is not set, 10051 will be used.
 1014 #   This option can be overridden by address specified in frontend configuration.
 1015 #
 1016 # Mandatory: no
 1017 # Default: 
 1018 # NodeAddress=localhost:10051" > /etc/zabbix/zabbix_server.conf

# Habilitando e iniciando serviços Zabbix

systemctl restart zabbix-server zabbix-agent 
systemctl enable zabbix-server zabbix-agent

# Habilitando e iniciando serviços Apache2

systemctl restart apache2
systemctl enable apache2
