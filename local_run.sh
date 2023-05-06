#!/bin/bash

imageName=airflow-image:latest

if (! docker stats --no-stream ); #проверяем, запущен ли докер
then
    echo "\033[0;31mERROR\033[0m"
    set -e
else

    echo "Detach Containers..."
    docker-compose down

    echo "Delete old image..."
    docker image rm $imageName

    echo "Build new image..."
    docker build -t $imageName -f Dockerfile  .

    echo "Up..."
    docker-compose -f docker-compose-local.yaml up -d

    echo Provision Containers... #ждем 5 минут, пока контейнеры встанут в healty
    for i in {1..10}
        do
            if docker ps -f name=airflow | grep '(healthy)' | wc -l | grep -q '3';
            then
                echo "OK: Containers are ready:"
                echo "\033[1;32mAirflow is ready! Please follow\033[0m http://localhost:8080/ \033[1;32mvia web-browser\033[0m"
                break
            else
                if [[ "$i" -eq 10 ]]; then 
                    echo "\033[0;31mERROR:\033[0m Containers did not become healthy. Please try again or check your code."
                    docker-compose down #если не получилось, вырубаем контенеры
                else
                    sleep 30
                fi
            fi
        done
fi