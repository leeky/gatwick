class ActivationsController < ApplicationController
  def create
    @event = current_user.events.find(params[:event_id])
    @event.activate!

    redirect_to :back
  end
end
