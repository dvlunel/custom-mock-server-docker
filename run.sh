#!/bin/bash

CONTAINER_NAME="mockserver"

case "$1" in
    start)
        echo "Merging mock JSON files..."
        ./merge_mocks.sh
        echo "Starting MockServer..."
        docker-compose up -d
        ;;
    stop)
        echo "Stopping MockServer..."
        docker-compose down
        ;;
    restart)
        echo "Restarting MockServer..."
        ./merge_mocks.sh
        docker-compose down
        docker-compose up -d
        ;;
    logs)
        echo "Showing logs for MockServer..."
        docker logs -f $CONTAINER_NAME
        ;;
    status)
        echo "Checking if MockServer is running..."
        docker ps | grep $CONTAINER_NAME
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs|status}"
        exit 1
        ;;
esac
