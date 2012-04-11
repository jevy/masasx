FactoryGirl.define do
  factory :organization_admin do
    sequence :email do |n|
      "email_#{n}@example.com"
    end
    password 'my_password'
    password_confirmation { |organization_admin| organization_admin.password }
  end

  factory :organization_admin_executive, parent: :organization_admin do
    executive true
  end
end
