# For testing with vagrant, you need to specify some secret info such as
# the client_id, client_secret, and upsteams variables.
# Obviously we don't want these in our code repo, so specify these 
# sensative items in secrets.yaml in this directory and it will be 
# picked up by hiera and used

# example:
# secrets.yaml
# ---
# google_auth_proxy::client_id: 123456.apps.googlecontent.com
# google_auth_proxy::client_secret: asdfasd2345qwerasdgfadgq43wry3567gjwer

include ::google_auth_proxy

