class LineBotClient < Line::Bot::Client
  def initialize
    @channel_token  = ENV['LINE_CHANNEL_TOKEN']
    @channel_secret = ENV['LINE_CHANNEL_SECRET']
  end

  def response(body)
    parse_events_from(body).each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # keyphrase =
          #   YahooKeyphraseService.new(event.message['text']).execute.try(:first).try(:fetch, 'Keyphrase') ||
          #   YahooMAService.new(event.message['text']).execute.select{|word| word["pos"] == "形容詞" || word["pos"] == "感動詞" || word["pos"] == "副詞"}.first.try(:fetch, 'surface')
          # text      = keyphrase ? keyphrase + 'っすね' : 'ちょっと何言ってるか分からないっすw'
          # text.insert(0, "つまり") if event.message['text'].length > 26
          res = GoogleCustomSearchApi.search(event.message['text']).items.try(:first)
          image = res.pagemap.cse_thumbnail.try(:first).try(:fetch, 'src') if res['cse_thumbnail']
          # text = res.try(:fetch, 'title') + '\\n' + res.try(:fetch, 'link')
          message = {
            "type": "template",
            "altText": "this is a buttons template",
            "template": {
                "type": "buttons",
                "thumbnailImageUrl": image,
                "title": res.title,
                "text": res.snippet[0, 60],
                "actions": [
                    {
                      "type": "uri",
                      "label": "Click here",
                      "uri": res.link
                    }
                ]
            }
          }

          response = reply_message(event['replyToken'], message)
          if response.instance_of?(Net::HTTPBadRequest)
            binding.pry
            message = {
              type: 'text',
              text: 'エラーしたよ'
            }
            reply_message(event['replyToken'], message)
          end
        end
      end
    end
  end
end
