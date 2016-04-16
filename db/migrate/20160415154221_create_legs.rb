class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      
      t.string :name
      t.integer :trip_id
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
