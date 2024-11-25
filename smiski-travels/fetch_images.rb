# Created 2024-11-24 with lots of elp from Github and Gemini

require 'net/http'
require 'json'

def fetch_images(url, output_file)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  if response.code == '200'
    image_data = JSON.parse(response.body)

    # Open the output JSON file for writing
    File.open(output_file, 'w') do |file|
      file.write(JSON.pretty_generate(image_data))
    end

    puts "Image data has been successfully written to #{output_file}."
  else
    puts "Error fetching images: #{response.code}"
    puts response.body
  end
end

# Replace with your Cloudflare Worker API endpoint
url = 'https://smiski-photos-worker.metalphan.workers.dev/?album_id=ALbRIU_103UAj7do5yTn8_h49i8AlymjoWa6Oa9UQFMRYr9uM_aWe5r3QP1o4C3dLSAFdcVFshRz4wD3gvrQLJe6PxNPsWml3w'

# Output file to save the JSON data
output_file = 'import_data.json'

fetch_images(url, output_file)
