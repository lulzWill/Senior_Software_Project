class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :user_id
      t.string :location_id
      t.integer :rating
      t.string :comment
      t.integer :flags
      t.boolean :allowed
      t.timestamps null: false
    end
  end
end
