#!/bin/bash

sudo systemctl stop apache2

sudo systemctl restart nginx

set -e
echo "Starting restart.sh script" > /home/ubuntu/CICD/restart.log
echo "Listing files before restart:" >> /home/ubuntu/CICD/restart.log
ls -l /home/ubuntu/CICD/src/ >> /home/ubuntu/CICD/restart.log

PROJDIR="/home/ubuntu/CICD/src"
PIDFILE="/home/ubuntu/uwsgi.pid"
VENVDIR="/home/ubuntu/test_env"

cd $PROJDIR

# if [ -f $PIDFILE ]; then
#         kill -9 `cat -- $PIDFILE`
#         rm -f -- $PIDFILE
# fi

if [ -f $PIDFILE ]; then
    PID=$(cat -- $PIDFILE)
    if ps -p $PID > /dev/null; then
        kill -9 $PID
    else
        echo "Process $PID not found, removing stale PID file"
    fi
    rm -f -- $PIDFILE
fi

# Activate the virtual environment
#source $VENVDIR/bin/activate

# Activate the virtual environment using Bash shell
if [ -e "$VENVDIR/bin/activate" ]; then
    . "$VENVDIR/bin/activate"
else
    echo "Virtual environment not found at $VENVDIR"
    exit 1
fi

UWSGI_EXECUTABLE="/home/ubuntu/test_env/bin/uwsgi"

$UWSGI_EXECUTABLE --chdir /home/ubuntu/CICD/src --socket /home/ubuntu/try_django.sock --module try_django.wsgi:application --pidfile=/home/ubuntu/uwsgi.pid --master --processes 2 --threads 1 --chmod-socket=666 -b 32768 --daemonize=/home/ubuntu/CICD.log
echo "Proj Restarted."
echo "Listing files after restart:" >> /home/ubuntu/CICD/restart.log
ls -l /home/ubuntu/CICD/src/ >> /home/ubuntu/CICD/restart.log
echo "Restart script completed successfully." >> /home/ubuntu/CICD/restart.log
