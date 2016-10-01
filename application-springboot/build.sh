#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Compiling Application and Generating WAR file and uploading to AWS s3"
mvn clean deploy
echo "Finished: $(date)"
