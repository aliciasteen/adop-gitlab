# Script from https://gist.github.com/michaellihs/5ef5e8dbf48e63e2172a573f7b32c638
# Generates a personal access token for the API as the root user

gitlab_host="http://gitlab/gitlab"
gitlab_user="root"
gitlab_password=${INITIAL_ADMIN_PASSWORD}

# 1. curl the login page to get a session cookie and the sources with the auth token
body_header=$(curl -c cookies.txt -i "${gitlab_host}/users/sign_in" -s)

# grep the auth token for the user login for
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

# 2. send login credentials with curl, using cookies and token from previous request
curl -b cookies.txt -c cookies.txt -i "${gitlab_host}/users/sign_in" \
	--data "user[login]=${gitlab_user}&user[password]=${gitlab_password}" \
	--data-urlencode "authenticity_token=${csrf_token}"

# 3. send curl GET request to personal access token page to get auth token
body_header=$(curl -H 'user-agent: curl' -b cookies.txt -i "${gitlab_host}/profile/personal_access_tokens" -s)
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

# 4. curl POST request to send the "generate personal access token form"
# the response will be a redirect, so we have to follow using `-L`
body_header=$(curl -L -b cookies.txt "${gitlab_host}/profile/personal_access_tokens" \
	--data-urlencode "authenticity_token=${csrf_token}" \
	--data 'personal_access_token[name]=gitlab_root_token&personal_access_token[expires_at]=&personal_access_token[scopes][]=api')

# 5. Scrape the personal access token from the response HTML
personal_access_token=$(echo $body_header | perl -ne 'print "$1\n" if /created-personal-access-token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
echo $personal_access_token

# Passes the token value to platform.secrets.sh for use by other scripts.
echo "export root_api_token=$personal_access_token" > /home/resources/adop_scripts/platform.secrets.sh