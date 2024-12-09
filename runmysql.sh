#!/usr/bin/env bash
podman run --rm --detach \
  --name mariadb_devcontainer \
  -e MARIADB_ROOT_PASSWORD=easypass \
  -v ./mysql-data/:/var/lib/postgresql/mysql-data:Z \
  -p 8080:8080 \
  mariadb:latest

