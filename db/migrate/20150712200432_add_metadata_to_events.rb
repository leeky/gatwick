class AddMetadataToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    add_column :events, :event_url, :string
    add_column :events, :eventbrite_id, :integer
    add_column :events, :active, :boolean, default: false
  end
end
