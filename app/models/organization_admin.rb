class OrganizationAdmin < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password

  belongs_to :organization
  has_one :contact_info, as: :contactable, class_name: 'Contact'
  accepts_nested_attributes_for :contact_info
end
