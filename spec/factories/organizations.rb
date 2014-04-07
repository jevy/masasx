FactoryGirl.define do

  factory :organization do
    name 'Awesome ogranization'
    department 'Important department'
    address_line_1 'Nowhere 42'
    telephone '555-42-42-42'
    website 'http://www.example.com'
    references 'We are good.'
    questions 'What is the meaning of 42?'
    agreements [1, 2, 3]
    postal_code 'K1J 234'
    state 'Ontario'
    city 'Ottawa'
    country 'CA'
  end

  factory :organization_new, parent: :organization do
    status 'new'
  end

  factory :organization_in_progress, parent: :organization do
    status 'in_progress'
  end

  factory :organization_on_hold, parent: :organization do
    status 'on_hold'
  end

  factory :organization_with_contacts, parent: :organization_new do
    after_create do |organization|
      FactoryGirl.create(:organization_admin, organization: organization, role: 'Primary', last_name: 'The admin')
      FactoryGirl.create(:organization_admin, organization: organization, role: 'Secondary', last_name: 'Not as important')
      FactoryGirl.create(:organization_admin, organization: organization, role: 'Authority', last_name: 'Important person')
    end
  end

  factory :organization_approved, parent: :organization do
    status 'approved'
  end

  factory :organization_rejected, parent: :organization do
    status 'rejected'
  end

end
