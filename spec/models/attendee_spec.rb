require "rails_helper"

describe Attendee do
  it { is_expected.to belong_to :event }
end
