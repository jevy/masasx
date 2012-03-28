FactoryGirl.define do

  factory :contact do
    name 'John Doe'
    title 'Dr.'
    language 'English'
    office_email 'office@example.com'
    office_phone '555-42-42-42'
    mobile_email 'mobile@example.com'
    mobile_phone '555-24-24-24'
  end

end
