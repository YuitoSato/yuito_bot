class GoogleCloudVisionService
  attr_accessor :endpoint_uri, :file_path

  def initialize(file_path)
    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_VISION_KEY']}"
    @file_path = file_path
  end

  def request
    http_client = HTTPClient.new
    content = Base64.strict_encode64(File.new(file_path, 'rb').read)
    response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
    descriptions = fetch_descriptions(response)
  end

  def request_json(content)
    {
      requests: [{
        image: {
          content: content
        },
        features: [{
          type: "LABEL_DETECTION",
          maxResults: 100
        }]
      }]
    }.to_json
  end

  def fetch_descriptions(response)
    result = JSON.parse(response)['responses'].first
    result['labelAnnotations'].map{ |label| label['description'] }
  end
end
