class Event < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true

  def activate!
    update(active: true)
  end

  def deactivate!
    update(active: false)
  end
end
