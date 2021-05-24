#!/bin/bash

FOLDER=$1
OUT=$2

pushd "$FOLDER"
FILES=$(ls | sort -V)

echo $FILES
convert $FILES +repage -resize x128 -set page '+%[fx:u[t-1]page.x+u[t-1].w]+0' -background none -layers merge +repage $OUT

popd

mv "$FOLDER/$OUT" .
