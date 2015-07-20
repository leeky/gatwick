class CallbacksController < ApplicationController
  before_action :require_login

  def new
    if params[:code].nil?
      return redirect_with_failure
    end

    token = EventbriteAuthenticator.new.exchange_token(params[:code])

    unless token
      return redirect_with_failure
    end

    current_user.update(eventbrite_token: token)

    EventFetcherJob.perform_later(current_user)

    redirect_with_success
  end

  private

  def redirect_with_success
    redirect_to signed_in_root_path, notice: t("eventbrite_success")
  end

  def redirect_with_failure
    redirect_to signed_in_root_path, alert: t("eventbrite_failure")
  end
end
