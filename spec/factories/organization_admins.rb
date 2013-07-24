FactoryGirl.define do
  factory :organization_admin do
    sequence :email do |n|
      "email_#{n}@example.com"
    end
    password 'my_password'
    password_confirmation { |organization_admin| organization_admin.password }
    first_name 'First Name'
    last_name 'Last Name'
    office_phone '555-42-42-42'
    address_line_1 '123 Main St.'
    city 'Ottawa'
    state 'Ontario'
    country 'CA'
    postal_code 'K1J 1A6'
  end

  factory :organization_admin_executive, parent: :organization_admin do
    executive true
  end
end
