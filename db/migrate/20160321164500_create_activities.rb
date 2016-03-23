class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.string :username
      # photo, friend, visit, review,
      t.string :activity_type
      t.text :data
      t.timestamps null: false
    end
  end
end
