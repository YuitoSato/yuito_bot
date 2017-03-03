class LineBotClient < Line::Bot::Client
  def initialize
    @channel_token  = ENV['LINE_CHANNEL_TOKEN']
    @channel_secret = ENV['LINE_CHANNEL_SECRET']
  end

  def response(body)
    parse_events_from(body).each do |event|
      user = User.where(line_id: event['source']['userId']).first_or_create
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text']

          case text
          when 'モードオフ'
            user.talk!
          when 'ググって'
            user.search
          else
            message = case user.mode
            when 'talk'
              Line::TalkService.new(text).execute
            when 'search'
              Line::SearchService.new(text).execute
            end
          end

          response = reply_message(event['replyToken'], message)

          if response.instance_of?(Net::HTTPBadRequest)
            message = {
              type: 'text',
              text: 'エラーしたよ'
            }
            push_message(user.line_id, message)
          end
        end
      end
    end
  end
end
