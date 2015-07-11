class EventsController < ApplicationController
  before_action :require_login

  def index
    @events = current_user.events.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to events_path, notice: "Event was created!"
    else
      render :new
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path, notice: "Event was updated!"
    else
      render :edit
    end
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end
end
