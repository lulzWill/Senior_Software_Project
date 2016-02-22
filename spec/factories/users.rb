FactoryGirl.define do
  factory :user do
    user_id "admin"
    email  "admin@admin.com"
    password  "admin1"
    password_confirmation "admin1"
  end
end