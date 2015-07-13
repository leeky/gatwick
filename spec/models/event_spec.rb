require "rails_helper"

describe Event do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :attendees }

  describe "#activate!" do
    it "activate an event" do
      event = create(:event)
      event.activate!

      expect(event.active).to be_truthy
    end
  end

  describe "#deactivate!" do
    it "deactivates an event" do
      event = create(:event, active: true)
      event.deactivate!

      expect(event.active).to be_falsey
    end
  end
end
