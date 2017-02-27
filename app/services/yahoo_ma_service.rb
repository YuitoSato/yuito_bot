class YahooMAService
  attr_reader :endpoint_uri, :query

  def initialize(sentence)
    @endpoint_uri = "https://jlp.yahooapis.jp/MAService/V1/parse?appid=#{ENV['YAHOO_APP_ID']}&results=ma,uniq&uniq_filter=9%7C10"
    @query        = {sentence: sentence}
  end

  def execute
    http_client = HTTPClient.new
    response    = http_client.post(endpoint_uri, body: query)
    results     = Hash.from_xml(response.body)["ResultSet"]["ma_result"]["word_list"]["word"]
    results     = [results] if results.instance_of?(Hash)
    results
  end
end
