#!/bin/bash
php-fpm --allow-to-run-as-root --nodaemonize
nginx -g "daemon off;"
