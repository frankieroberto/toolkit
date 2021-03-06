FactoryGirl.define do
  factory :user_location do
    location "POINT(2 2)"
    association :category, factory: :location_category
    association :user

    factory :user_location_with_json_loc do
      loc_json '{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0.14,52.27]}}'
    end
  end
end