#!/usr/bin/env bash
# Set the root password, bypassing the password reset screen
# Run from inside the GitLab container
gitlab_host="http://gitlab/gitlab"

body_header=$(curl -v -L -H "Content-Type: application/json" -c cookies.txt -i "${gitlab_host}" -s)

# Generating the CSRF token and password reset tokens required by GitLab
echo "[Token generation script]: Extracting the CSRF token from the login page..."
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/')

echo "[Token generation script]: Extracted the CSRF token for the login page: $csrf_token"
reset_password_token=$(echo $body_header | perl -ne 'print "$1\n" if /input[[:blank:]]type="hidden"[[:blank:]]value="(.+?)"/')

echo "[Token generation script]: Extracted the password token for the login page: $reset_password_token"

# Curls the password reset with the provided tokens. Refreshing GitLab will now re-direct to the standard sign-on.
# Also changes the root password to the INITIAL_ADMIN_PASSWORD variable
curl -L -X POST -H "application/x-www-form-urlencoded" -b cookies.txt -c cookies.txt -i "${gitlab_host}/users/password" --data-urlencode "authenticity_token=${csrf_token}" --data "_method=put&user[reset_password_token]=${reset_password_token}&user[password]=${INITIAL_ADMIN_PASSWORD}&[password_confirmation]=${INITIAL_ADMIN_PASSWORD}"

# Returns a 400 code but does successfully reset the password for root account.