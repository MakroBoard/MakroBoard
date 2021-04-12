#!/bin/bash
echo "list docs"
find ./Docs -name *.md -type f
echo "list docs without type"
find ./Docs -name *.md
echo "execute"
for file in $(find ./Docs -name *.md -type f); do echo -e "\n$file: ";  sed -i '1i\\' $file && sed -i '1i\\' $file && sed -i '1i>This is a dev version of our homepage! Please use [makroboard.app](https://makroboard.app) insted.\' $file && sed -i '1i>[!WARNING]\' $file ; done
