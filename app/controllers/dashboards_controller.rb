class DashboardsController < ApplicationController
  before_action :require_login

  def show
    unless current_user.eventbrite_token?
      @eventbrite_auth_url = eventbrite_auth_url
    end

    @events = current_user.events.all
  end

  private

  def eventbrite_auth_url
    EventbriteAuthenticator.new.auth_url
  end
end
