#!/usr/bin/env bash
# This script updates the relevant LDAP users to admin status

# Create personal access token from previous script to generate root api token
gitlab_host="http://gitlab/gitlab"
source /home/resources/adop_scripts/platform.secrets.sh

echo "This script will make the LDAP Jenkins user an admin in Gitlab."
echo "Requesting user details from GitLab..."

# api call to get user details
requestbody=$(curl -X GET -H "Private-Token: ${root_api_token}" ${gitlab_host}/api/v4/users?username=${JENKINS_USER})
echo "Received user details, extracting user ID"

# regex the user ID
jenkins_id=$(echo $requestbody | perl -ne 'print "$1\n" if /"id":(\d)/' | sed -n 1p)
echo "The jenkins user ID is: ${jenkins_id}" 

# Change the user ID to admin
curl -X PUT -H "Private-Token: ${root_api_token}" "${gitlab_host}/api/v4/users/${jenkins_id}?admin=true"
echo "Jenkins user is now an admin in Gitlab"
echo "----------------------------------------------------"

echo "Making the ADOP inital admin user an admin in Gitlab"
echo "Requesting user details from GitLab"

# api call to get user details
requestbody=$(curl -X GET -H "Private-Token: ${root_api_token}" ${gitlab_host}/api/v4/users?username=${INITIAL_ADMIN_USER})
echo "Received user details, extracting user ID"

# regex the user ID
adopCuser_id=$(echo $requestbody | perl -ne 'print "$1\n" if /"id":(\d)/' | sed -n 1p)
echo "The adopCuser user ID is: ${adopCuser_id}"

# Change the user ID to admin
curl -X PUT -H "Private-Token: ${root_api_token}" "${gitlab_host}/api/v4/users/${adopCuser_id}?admin=true"
echo "ADOP inital admin user is now an admin in Gitlab"
