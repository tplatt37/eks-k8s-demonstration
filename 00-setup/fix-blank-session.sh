#!/bin/bash

#
# Cloud9 has a problem. It will sometimes inject a blank aws_session_token= line to the credentials file.
# This will cause kubectl commands to fail, presuably because it cannot create a token 
# 
# The error will look like this - anytime you run a kubectl command:
#
# error: You must be logged in to the server (Unauthorized)
#
#
# This happens REGARDLESS of whether or not Managed temporary credentials are enabled.
# This seems more likely to occur after/during you poking around in Cloud9 Settings.
#
# When there is a problem, the credentials file will look like this:
#[default]
#aws_access_key_id = AKIA2EXAMPLE12345678
#aws_secret_access_key = IEXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLE9999
#aws_session_token =
#
#
# The fix?  Simply REMOVE the blank aws_session_token= line.
#

echo "Removing any phantom aws_session_token lines..."
# sed=Stream Editor
sed -i '/aws_session_token =/d' ~/.aws/credentials

#
# This is another way to do it, less elegant, but it works
#cat  ~/.aws/credentials | grep -v aws_session_token > ~/.aws/credentials-fixed
#mv ~/.aws/credentials-fixed ~/.aws/credentials