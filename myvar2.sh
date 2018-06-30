#!/bin/sh
echo "MYVAR is: $MYVAR"
MYVAR="hi there"
echo "MYVAR is: $MYVAR"
echo "What's your name?"
read USER_NAME
echo "Hello $USER_NAME, I will create a file called ${USER_NAME}_file"
# touch ${USER_NAME}_file
