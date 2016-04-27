class CreatePhotoFlags < ActiveRecord::Migration
  def change
    create_table :photo_flags do |t|
      t.integer :photo_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
