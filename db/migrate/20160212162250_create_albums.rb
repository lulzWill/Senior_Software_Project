class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.integer :cover
      t.string :privacy
      t.timestamps null: false
    end
  end
end
