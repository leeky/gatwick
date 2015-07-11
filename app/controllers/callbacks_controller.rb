class CallbacksController < ApplicationController
  before_action :require_login

  def new
    if params[:code].nil?
      return redirect_to signed_in_root_path, alert: t(".eventbrite_failure")
    end

    token = exchange_token(params[:code])

    if token
      current_user.update(eventbrite_token: token)
      redirect_to signed_in_root_path, notice: t(".eventbrite_success")
    else
      redirect_to signed_in_root_path, alert: t(".eventbrite_failure")
    end
  end

  private

  def exchange_token(token)
    client = OAuth2::Client.new(
      ENV.fetch("EVENTBRITE_OAUTH_ID"),
      ENV.fetch("EVENTBRITE_OAUTH_SECRET"),
      site: "https://www.eventbrite.com/oauth/authorize"
    )

    begin
      client.auth_code.get_token(token, redirect_uri: new_callback_url).token
    rescue OAuth2::Error
      false
    end
  end
end
