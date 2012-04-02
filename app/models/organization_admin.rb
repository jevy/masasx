class OrganizationAdmin < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :contact_info, :contact_info_attributes

  belongs_to :organization
  has_one :contact_info, as: :contactable, class_name: 'Contact'
  accepts_nested_attributes_for :contact_info
end
