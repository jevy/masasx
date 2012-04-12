class OrganizationAdmin < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :name, :mobile_email, :office_phone, :mobile_phone, :title, :language, :executive
  attr_accessible :address_line_1, :address_line_2, :city, :state, :country, :postal_code

  belongs_to :organization

  validates :email, presence: { message: 'Email address required' }
  validates :office_phone, presence: { message: 'Phone required' }
  validates :name, presence: { message: 'Name required' }

end
