require 'googleauth'
require 'googleauth/transport/requests'  # Correct path to the file
require 'googleapiclient'
require 'dotenv'
dotenv.load

# Replace with your credentials
CLIENT_ID = ENV[CLIENTID]
CLIENT_SECRET =ENV[CLIENTSECRET]
REDIRECT_URI = 'http://localhost:8080/auth/callback'  # Replace with your actual redirect URI

# Create an authorization URL
auth_url = Google::Auth::Authorization.new(
  client_id: CLIENT_ID,
  scope: 'https://www.googleapis.com/auth/photoslibrary.readonly',
  redirect_uri: REDIRECT_URI
).url

# Redirect the user to the authorization URL (logic for this depends on your framework)
puts "Please visit this URL to authorize your Google Photos access:"
puts auth_url

# ... (rest of your code to handle the authorization code and get access/refresh tokens)