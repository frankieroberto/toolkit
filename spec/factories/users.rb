# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  full_name              :string(255)     not null
#  display_name           :string(255)
#  role                   :string(255)     not null
#  encrypted_password     :string(128)     default("")
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  disabled_at            :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:full_name) {|n| "User #{n}" }
    sequence(:password) {|n| "password#{n}" }
    sequence(:password_confirmation) {|n| "password#{n}" }
    after_build {|u| u.skip_confirmation! }

    trait :admin do
      role "admin"
    end

    trait :with_profile do
      after_build {|u| FactoryGirl.build(:user_profile, user: u) }
    end

    factory :stewie do
      email "stewie@example.com"
      full_name "Stewie Griffin"
      display_name "Stewie"
      password "Victory is mine!"
      password_confirmation "Victory is mine!"
      admin
    end

    factory :brian do
      email "brian@example.com"
      full_name "Brian Griffin"
      display_name "Brian"
      password "BRI-D0G"
      password_confirmation "BRI-D0G"
    end

    factory :stewie_with_profile, traits: [:with_profile]
  end
end
