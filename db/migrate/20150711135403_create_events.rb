class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.references :user
      t.timestamps null: false
    end

    add_foreign_key :events, :users, on_delete: :cascade
  end
end
