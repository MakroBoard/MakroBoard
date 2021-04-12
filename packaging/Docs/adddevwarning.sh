#!/bin/bash
for file in $(find ./Docs -name '*.md' -type f); do echo -e "\n$file: ";  sed -i '1i\\' $file && sed -i '1i\\' $file && sed -i '1i>This is a dev version of our homepage! Please use [makroboard.app](https://makroboard.app) insted.\' $file && sed -i '1i>[!WARNING]\' $file ; done
