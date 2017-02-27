class YahooKeyphraseService
  attr_reader :endpoint_uri, :query

  def initialize(sentence)
    @endpoint_uri = "https://jlp.yahooapis.jp/KeyphraseService/V1/extract?appid=#{ENV['YAHOO_APP_ID']}"
    @query        = {sentence: sentence}
  end

  def execute
    http_client = HTTPClient.new
    response    = http_client.post(endpoint_uri, body: query)
    results     = Hash.from_xml(response.body)['ResultSet']['Result']
    results     = [results] if results.instance_of?(Hash)
  end
end
