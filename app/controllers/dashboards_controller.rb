class DashboardsController < ApplicationController
  before_action :require_login

  def show
    unless current_user.eventbrite_token?
      @eventbrite_auth_url = eventbrite_auth_url
    end
  end

  private

  def eventbrite_auth_url
    client ||= OAuth2::Client.new(
      ENV.fetch("EVENTBRITE_OAUTH_ID"),
      ENV.fetch("EVENTBRITE_OAUTH_SECRET"),
      site: "https://www.eventbrite.com/oauth/authorize"
    )

    client.auth_code.authorize_url(redirect_uri: new_callback_url)
  end
end
