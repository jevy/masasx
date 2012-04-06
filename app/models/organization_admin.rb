class OrganizationAdmin < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :contact_info, :contact_info_attributes

  belongs_to :organization
  has_one :contact_info, as: :contactable, class_name: 'Contact'
  accepts_nested_attributes_for :contact_info

  validates :email, presence: { message: 'Email address required' }

  delegate :email,:email=, to: :contact_info, prefix: :office

end
