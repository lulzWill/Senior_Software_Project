class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      
      t.string :name
      t.integer :trip_id
      t.Date :start_date
      t.Date :end_date
      t.timestamps null: false
    end
  end
end
