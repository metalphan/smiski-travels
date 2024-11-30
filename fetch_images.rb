# Created 2024-11-24 with lots of help from Github and Gemini

require 'net/http'
require 'json'
require 'fileutils'
require 'open-uri'

def fetch_images(url, output_file, photos_dir)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  if response.code == '200'
    image_data = JSON.parse(response.body)

    # Save the metadata to the output JSON file
    File.open(output_file, 'w') do |file|
      file.write(JSON.pretty_generate(image_data))
    end
    puts "Image metadata has been successfully written to #{output_file}."

    # Ensure the photos directory exists
    FileUtils.mkdir_p(photos_dir)

    # Download each image to the photos directory
    image_data.each do |image|
      image_url = image["url"]
      filename = image["filename"]
      destination_path = File.join(photos_dir, filename)

      puts "Downloading image: #{image_url} to #{destination_path}"

      begin
        # Use OpenURI to download the image and save it
        URI.open(image_url) do |remote_file|
          File.open(destination_path, 'wb') do |local_file|
            local_file.write(remote_file.read)
          end
        end
        puts "Image downloaded successfully: #{destination_path}"
      rescue StandardError => e
        puts "Error downloading image: #{e.message}"
      end
    end
  else
    puts "Error fetching images: #{response.code}"
    puts response.body
  end
end

# Replace with your Cloudflare Worker API endpoint
url = 'https://smiski-photos-worker.metalphan.workers.dev/?album_id=ALbRIU_103UAj7do5yTn8_h49i8AlymjoWa6Oa9UQFMRYr9uM_aWe5r3QP1o4C3dLSAFdcVFshRz4wD3gvrQLJe6PxNPsWml3w'

# Output file for metadata
output_file = 'import_data.json'

# Photos directory relative to the script
photos_dir = 'photos'

fetch_images(url, output_file, photos_dir)
