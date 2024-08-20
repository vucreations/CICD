#!/bin/bash


PROJDIR="/home/ubuntu/CICD/src"
PIDFILE="/home/ubuntu/uwsgi.pid"
VENVDIR="/home/ubuntu/test_env"

cd $PROJDIR

if [ -f $PIDFILE ]; then
        kill -9 `cat -- $PIDFILE`
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

