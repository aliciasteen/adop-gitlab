#!/usr/bin/env bash
# Script heavily based on https://gist.github.com/michaellihs/5ef5e8dbf48e63e2172a573f7b32c638
# This script logs in as both the Jenkins LDAP user then the adopC LDAP user so they become visible to the root user.
# Exporting data for jenkins user
export GITLAB_HOST=http://gitlab/gitlab

export GITLAB_USERNAME=${JENKINS_USER}
export GITLAB_PASSWORD=${JENKINS_PASSWORD}
gitlab_host=$GITLAB_HOST
gitlab_user=$GITLAB_USERNAME
gitlab_password=$GITLAB_PASSWORD

# 1. curl for the login page to get a session cookie and the sources with the auth tokens
echo "[Token generation script]: Curling login page......."
body_header=$(curl -c cookies.txt -i "${gitlab_host}/users/sign_in" -s)

# grep the auth token for the user login for
echo "[Token generation script]: Extracting the CSRF token from the login page......."
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
echo "[Token generation script]: Extracted the CSRF token for the login page: $csrf_token"

# 2. send login credentials with curl, using cookies and token from previous request
echo "[Token generation script]: Logging in to Gitlab......."
curl -b cookies.txt -c cookies.txt -i "${gitlab_host}/users/auth/ldapmain/callback" \
                        --data "username=${gitlab_user}&password=${gitlab_password}" \
                        --data-urlencode "authenticity_token=${csrf_token}"

echo "Jenkins user logged in"

echo "##########################################"

# Logging in with the ADOP initial admin user
echo "Initializing ADOP initial admin user in Gitlab"
export GITLAB_USERNAME=${INITIAL_ADMIN_USER}
export GITLAB_PASSWORD=${INITIAL_ADMIN_PASSWORD}
gitlab_user=$GITLAB_USERNAME
gitlab_password=$GITLAB_PASSWORD

# 1. curl for the login page to get a session cookie and the sources with the auth tokens
echo "[Token generation script]: Curling login page......."
body_header=$(curl -c cookies.txt -i "${gitlab_host}/users/sign_in" -s)

# grep the auth token for the user login for
echo "[Token generation script]: Extracting the CSRF token from the login page......."
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
echo "[Token generation script]: Extracted the CSRF token for the login page: $csrf_token"

# 2. send login credentials with curl, using cookies and token from previous request
echo "[Token generation script]: Logging in to Gitlab......."
curl -b cookies.txt -c cookies.txt -i "${gitlab_host}/users/auth/ldapmain/callback" \
                        --data "username=${gitlab_user}&password=${gitlab_password}" \
                        --data-urlencode "authenticity_token=${csrf_token}"
echo "ADOP initial admin user logged in"