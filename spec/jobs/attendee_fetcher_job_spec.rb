require "rails_helper"

describe AttendeeFetcherJob do
  describe "#perform" do
    it "fetches attendee details from Eventbrite" do
      user = create(:user, :eventbrite_authenticated)
      event = create(:event, user: user, eventbrite_id: "1234")

      stub_attendee_list

      AttendeeFetcherJob.perform_now(event)

      expect(event.attendees.size).to eql 2
      expect(event.attendees.first.name).to eql "Fred Flintstone"
      expect(event.attendees.first.email).to eql "fred@example.com"
      expect(event.attendees.first.eventbrite_attendee_id).to eql "1"
    end
  end

  def stub_attendee_list
    dummy_attendees = {
      "pagination": {
        "object_count": 2,
        "page_number": 1,
        "page_size": 50,
        "page_count": 1
      },
      "attendees": [
        {
          "id": "1",
          "status": "Attending",
          "profile": {
            "name": "Fred Flintstone",
            "email": "fred@example.com",
            "cell_phone": "123-456-7890"
          },
          "barcodes": [
            {
              "barcode": "1234567890"
            }
          ]
        },
        {
          "id": "2",
          "status": "Attending",
          "profile": {
            "name": "Barney Rubble",
            "email": "barney@example.com",
            "cell_phone": "555-123-4567"
          },
          "barcodes": [
            {
              "barcode": "9876543210"
            }
          ]
        }
      ]
    }.to_json

    stub_request(:get, "https://www.eventbriteapi.com/v3/events/1234/attendees").
      to_return(
        status: 200,
        body: dummy_attendees,
        headers: {}
      )
  end
end
