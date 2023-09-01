#!/bin/bash

#is a test for demonstration, banning the use of numbers in the index.html
html_content=$(cat index.html)

if echo "$html_content" | grep -qE '<h1>.*[0-9].*</h1>|<p>.*[0-9].*</p>'; then
    echo "fail"
else
    echo "ok"
fi

