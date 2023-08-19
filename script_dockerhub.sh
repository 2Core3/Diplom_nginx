#!/bin/bash

# Проверяем наличие файла .env
if [ -f .env ]; then
    # Загружаем переменные из файла .env
    source .env
    
    # Выполняем логин
    echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
    
    # Проверяем статус успешного логина
    if [ $? -eq 0 ]; then
        echo "Login Succeeded"
    else
        echo "Login Failed"
    fi
else
    echo "File .env not found."
fi
