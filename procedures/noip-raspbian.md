Installing the client
---------------------
Run the following commands.

    cd /tmp
    wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
    tar xzf noip-duc-linux.tar.gz
    cd noip-2.1.9-1
    make
    sudo make install

Starting the client at boot time
--------------------------------
Create the following file.

    /etc/init.d/noip

With the following content.

    #! /bin/sh

    ### BEGIN INIT INFO
    # Provides:          noip
    # Required-Start:    $remote_fs $syslog
    # Required-Stop:     $remote_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    ### END INIT INFO

    case "$1" in
      start)
        echo "Starting noip"
        /usr/local/bin/noip2
        ;;
      stop)
        echo "Stopping noip"
        killall noip2
        ;;
      *)
        echo "Usage: /etc/init.d/noip {start|stop}"
        exit 1
        ;;
    esac

    exit 0

Run the following commands.

    sudo chmod 755 /etc/init.d/noip
    sudo update-rc.d noip defaults
