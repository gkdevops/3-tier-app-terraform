#!/bin/bash
yum -y install git postgresql15
# pretend we pull / run your app here
echo "APP Listening on ${APP_PORT}, talking to DB ${DB_HOST}" > /tmp/app.log
