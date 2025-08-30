#!/bin/bash
# docker-test-local.sh
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.dev.yml up --build