class OrganizationAdmin < ActiveRecord::Base
  belongs_to :organization
  has_one :contact_info, as: :contactable, class_name: 'Contact'
  accepts_nested_attributes_for :contact_info
end
