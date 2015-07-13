class ActivationsController < ApplicationController
  def create
    @event = current_user.events.find(params[:event_id])
    @event.activate!

    AttendeeFetcherJob.perform_later(@event)

    redirect_to :back
  end
end
