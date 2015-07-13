class AttendeeFetcherJob < ActiveJob::Base
  queue_as :default

  def perform(event)
    @event = event

    Eventbrite.token = @event.eventbrite_token

    if all_attendees.size > 0
      @event.attendees.delete_all

      all_attendees.each do |attendee|
        create_attendee(attendee)
      end
    end
  end

  private

  def all_attendees
    attendees = Eventbrite::Attendee.all(event_id: @event.eventbrite_id)
    all_attendees = attendees.attendees

    while attendees.next?
      attendees = Eventbrite::Attendee.all(
        event_id: @event.eventbrite_id,
        page: attendees.next_page
      )

      all_attendees.concat(attendees.attendees)
    end

    all_attendees
  end

  def create_attendee(attendee)
    @event.attendees.create(
      name: attendee.profile.name,
      email: attendee.profile.email,
      cell_phone: attendee.profile.cell_phone,
      eventbrite_attendee_id: attendee.id,
      eventbrite_status: attendee.status,
      eventbrite_barcode: attendee.barcodes.first.barcode
    )
  end
end
