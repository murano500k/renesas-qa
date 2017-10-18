#!/bin/bash
echo "run $@ on jenkins"
sshpass  -p 'jenkins86' $@ jenkins@172.22.89.21