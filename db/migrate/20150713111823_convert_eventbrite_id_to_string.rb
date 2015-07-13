class ConvertEventbriteIdToString < ActiveRecord::Migration
  def change
    change_column :events, :eventbrite_id, :string, limit: 64
  end
end
