class AddEventbriteTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :eventbrite_token, :string
  end
end
