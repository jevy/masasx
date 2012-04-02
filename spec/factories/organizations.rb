FactoryGirl.define do

  factory :organization do
    name 'Awesome ogranization'
    department 'Important department'
    division 'Division'
    sub_division 'Sub-division'
    address_line_1 'Nowhere 42'
    telephone '555-42-42-42'
    website 'http://www.example.com'
    references_language 'English'
    references 'We are good.'
    questions 'What is the meaning of 42?'
    agreements [1, 2, 3]
  end

  factory :organization_pending_approval, parent: :organization do
    status 'completed'
    association :primary_organization_administrator,   factory: :organization_admin
    association :secondary_organization_administrator, factory: :organization_admin
  end

end
