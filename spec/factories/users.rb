FactoryGirl.define do
  factory :user do
    user_id "admin"
    email  "admin@admin.com"
    password  "admin1"
    password_confirmation "admin1"
  end
  
  factory :non_logged_user, parent: :user do
    self.session_token = nil
  end
end