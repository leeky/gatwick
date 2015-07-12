class EventsController < ApplicationController
  before_action :require_login

  def index
    @events = current_user.events.all
  end
end
