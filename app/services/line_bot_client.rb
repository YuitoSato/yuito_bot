class LineBotClient < Line::Bot::Client
  def initialize
    @channel_token  = ENV['LINE_CHANNEL_TOKEN']
    @channel_secret = ENV['LINE_CHANNEL_SECRET']
  end

  def response(body)
    parse_events_from(body).each do |event|
      line_id = event['source']['userId'] || event['source']['groupId']
      user    = User.where(line_id: line_id).first_or_create
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text']

          case text
          when 'モードオフ'
            user.talk!
          when 'ググって'
            user.search!
          else
            message = case user.mode
            when 'talk'
              Line::TalkService.new(text).execute
            when 'search'
              Line::SearchService.new(text).execute
            end
          end

        when Line::Bot::Event::MessageType::Image
          response = get_message_content(event.message['id'])
          message  = Line::ImageService.new(response.body).execute
        end

        reply_message(event['replyToken'], message)
      end
    end
  end
end
