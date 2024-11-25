require 'googleauth'
require 'googleauth/transport/requests'
require 'googleapiclient'
require '.env'

# Replace with your credentials
CLIENT_ID = CLIENT_ID
CLIENT_SECRET = CLIENT_SECRET
REFRESH_TOKEN = 'YOUR_REFRESH_TOKEN'

# Authenticate
creds = Google::Auth::Credentials.new(
  CLIENT_ID,
  CLIENT_SECRET,
  refresh_token: REFRESH_TOKEN
)

service = Google::Apis::PhotoslibraryV1::PhotoslibraryService.new
service.authorization = creds

# Get album details
album_id = 'YOUR_ALBUM_ID'
album = service.albums().get(albumId: album_id).execute

# Get media items in the album
media_items = service.mediaItems().list(albumId: album_id, pageSize: 100).execute

# Write image URLs to a file
File.open('image_urls.txt', 'w') do |file|
  media_items['mediaItems'].each do |item|
    base_url = item['baseUrl']
    image_url = "#{base_url}=w1024" # Adjust size as needed
    file.write("#{image_url}\n")
  end
end