#!/bin/sh

cd $APP_DIR
exec npm start >> $LOG_DIR/app.log 2>&1
