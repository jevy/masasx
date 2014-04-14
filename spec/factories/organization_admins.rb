FactoryGirl.define do
  factory :organization_admin do
    sequence :email do |n|
      "email_#{n}@example.com"
    end
    language 'en'
    first_name 'First Name'
    last_name 'Last Name'
    office_phone '555-342-1233'
    address_line_1 '123 Main St.'
    city 'Ottawa'
    state 'Ontario'
    country 'CA'
    postal_code 'K1J 1A6'
  end
end
