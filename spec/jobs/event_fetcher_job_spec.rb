require "rails_helper"

describe EventFetcherJob do
  describe "#perform" do
    it "fetches event details from Eventbrite" do
      user = create(:user, :eventbrite_authenticated)

      stub_event_list

      expect{ EventFetcherJob.perform_now(user) }.
        to change{ user.events.size }.
        by(2)

      expect(user.events.first.name).to eq "event name"
      expect(user.events.first.description).to eql "event description"
      expect(user.events.first.event_url).
        to eql "http://www.eventbrite.com/e/event-name-1234"
      expect(user.events.first.eventbrite_id).to eql "1234"
    end
  end

  def stub_event_list
    dummy_events = {
      "pagination": {
        "object_count": 18,
        "page_number": 1,
        "page_size": 50,
        "page_count": 1
      },
      "events": [
        {
          "id": "1234",
          "name": { "text": "event name" },
          "description": { "text": "event description" },
          "url": "http://www.eventbrite.com/e/event-name-1234"
        },
        {
          "id": "1235",
          "name": { "text": "another event name" },
          "description": { "text": "another event description" },
          "url": "http://www.eventbrite.com/e/another-event-name-1235"
        }
      ]
    }.to_json

    stub_request(:get, "https://www.eventbriteapi.com/v3/users/me/owned_events").
      to_return(
        status: 200,
        body: dummy_events,
        headers: {}
      )
  end
end
