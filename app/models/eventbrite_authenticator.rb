class EventbriteAuthenticator
  def initialize
    @client = OAuth2::Client.new(
      ENV.fetch("EVENTBRITE_OAUTH_ID"),
      ENV.fetch("EVENTBRITE_OAUTH_SECRET"),
      site: "https://www.eventbrie.com/oauth/authorize"
    )
  end

  def exchange_token(token)
    begin
      @client.auth_code.get_token(
        token,
        redirect_uri: callback_url
      ).token
    rescue OAuth2::Error
      false
    end
  end

  def auth_url
    @client.auth_code.authorize_url(
      redirect_uri: callback_url
    )
  end

  private

  def callback_url
    Rails.application.routes.url_helpers.new_callback_url(
      host: ENV.fetch("HOST")
    )
  end
end
