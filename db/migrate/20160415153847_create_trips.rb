class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|

      t.string :name
      t.integer :main_user_id
      t.string :description
      t.date :start_date
      t.date :end_date
      t.boolean :show
      t.timestamps null: false
    end
  end
end
