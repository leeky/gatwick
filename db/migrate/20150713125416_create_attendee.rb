class CreateAttendee < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :name
      t.string :email
      t.string :cell_phone
      t.string :eventbrite_attendee_id, null: false
      t.string :eventbrite_barcode
      t.string :eventbrite_status
      t.references :event
    end

    add_index :attendees, :eventbrite_attendee_id
  end
end
