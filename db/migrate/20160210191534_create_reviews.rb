class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :location_id
      t.string :visit_id
      t.integer :rating
      t.string :comment
      t.boolean :flagged
      t.boolean :allowed
      t.timestamps null: false
    end
  end
end
