class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendees

  delegate :eventbrite_token, to: :user, prefix: false

  validates :name, presence: true

  def activate!
    update(active: true)
  end

  def deactivate!
    update(active: false)
  end
end
