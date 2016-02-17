class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.integer :location_id
      t.string :title
      t.string :data
      t.string :description
      t.integer :album_id
      t.timestamps null: false
    end
  end
end
