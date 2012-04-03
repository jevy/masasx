FactoryGirl.define do
  factory :account do
    name 'Ops Account'
    access_code '42-AA-42-BB-42'
    association :organization, factory: :organization
  end
end
