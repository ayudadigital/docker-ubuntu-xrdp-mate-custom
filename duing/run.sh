#!/bin/bash
docker run --name duing \
           -p 3389:3389 \
           --shm-size 1g \
           -dit --restart unless-stopped \
           tpbtools/duing
