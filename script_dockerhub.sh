#!/bin/bash


if [ -f .env ]; then
    source .env
    
    echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
    
    if [ $? -eq 0 ]; then
        echo "Login Succeeded"
    else
        echo "Login Failed"
    fi
else
    echo "File .env not found."
fi
