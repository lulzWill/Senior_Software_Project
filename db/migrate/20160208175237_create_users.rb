class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :user_id
      t.string :password_digest
      t.string :role
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :profile_pic
      t.string :session_token
      
      t.timestamps null: false
    end
  end
end
