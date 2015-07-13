class DeactivationsController < ApplicationController
  def create
    @event = current_user.events.find(params[:event_id])
    @event.deactivate!

    redirect_to :back
  end
end
