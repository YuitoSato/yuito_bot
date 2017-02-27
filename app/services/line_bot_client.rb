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
          keyphrase = YahooKeyphraseService.new(event.message['text']).execute.try(:first).try(:fetch, 'Keyphrase')
          text      = keyphrase ? keyphrase + 'っすね' : 'ちょっと何言ってるか分からないっすw'
          message   = {
            type: 'text',
            text: text
          }
          reply_message(event['replyToken'], message)
        end
      end
    end
  end
end
