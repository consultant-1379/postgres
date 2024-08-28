#!/bin/bash
while [ "$(curl --silent http://localhost:8500/v1/health/service/repo | grep passing)" = "" ]; do
  echo 'Waiting for Dependencies: Repo'
  sleep 5
done