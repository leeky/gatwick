class EventFetcherJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    return true if user.eventbrite_token.empty?

    Eventbrite.token = user.eventbrite_token
    user_events = Eventbrite::User.owned_events(user_id: "me")

    if user_events.events.size > 0
      user.events.delete_all

      user_events.events.each do |event|
        user.events.create(
          name: event.name.text,
          description: event.description.text,
          event_url: event.url,
          eventbrite_id: event.id
        )
      end
    end
  end
end
