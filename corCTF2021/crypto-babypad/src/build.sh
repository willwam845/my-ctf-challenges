#!/bin/bash
docker rm -f babypad
docker build --tag=babypad . && \
docker run -p 1006:1337 --restart=on-failure --name=babypad --detach babypad
