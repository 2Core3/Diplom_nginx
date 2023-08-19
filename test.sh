#!/bin/bash

# Чтение содержимого файла index.html
html_content=$(cat index.html)

# Поиск цифр внутри тегов <h1> и <p> с использованием grep
if echo "$html_content" | grep -qE '<h1>.*[0-9].*</h1>|<p>.*[0-9].*</p>'; then
    echo "fail"
else
    echo "ok"
fi

