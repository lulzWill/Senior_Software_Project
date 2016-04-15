class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|

      t.string :name
      t.integer :main_user_id
      t.string :description
      t.Date :start_date
      t.Date :end_date
      t.timestamps null: false
    end
  end
end
