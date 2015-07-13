class EventFetcherJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    return true if user.eventbrite_token.empty?

    Eventbrite.token = user.eventbrite_token

    return if user_events.size.zero?

    user.events.delete_all

    user_events.each do |event|
      user.events.create(
        name: event.name.text,
        description: event.description.text,
        event_url: event.url,
        eventbrite_id: event.id
      )
    end
  end

  private

  def user_events
    events = Eventbrite::User.owned_events(user_id: "me")
    events.events
  end
end
