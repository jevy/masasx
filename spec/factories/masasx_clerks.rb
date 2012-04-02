FactoryGirl.define do
  factory :masasx_clerk do
    sequence :email do |n|
      "email_#{n}@example.com"
    end
    password 'my_password'
    password_confirmation { |organization_admin| organization_admin.password }
  end
end
