#!/bin/bash
chown jenkins:jenkins /var/run/docker.sock
chmod 666 /var/run/docker.sock
exec /usr/local/bin/jenkins.sh
