class GoogleCloudVisionService
  attr_accessor :endpoint_uri, :binary

  def initialize(binary)
    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_VISION_KEY']}"
    @binary      = binary
  end

  def execute
    http_client = HTTPClient.new
    content     = Base64.strict_encode64(binary)
    response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
    result = JSON.parse(response)['responses']
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
end
