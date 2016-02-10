class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :location_id
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
