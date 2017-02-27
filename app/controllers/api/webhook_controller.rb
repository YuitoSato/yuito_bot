class Api::WebhookController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.raw_post
    client ||= LineBotClient.new

    unless client.validate_signature(body, request.env['HTTP_X_LINE_SIGNATURE'])
      render body: nil, status: 470 and return
    end

    client.response(body)

    render body: nil, status: :ok
  end
end
