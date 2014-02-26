class OrganizationAdmin < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :office_phone, :mobile_phone, :title, :language, :executive
  attr_accessible :address_line_1, :address_line_2, :city, :state, :country, :postal_code, :uuid

  belongs_to :organization

  validates :email, presence: { message: 'Email address required' }, email: true
  validates :office_phone, presence: { message: 'Phone required' }
  validates :first_name, presence: { message: 'Name required' }
  validates :last_name, presence: { message: 'Name required' }

  before_create :generate_uuid

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def masas_name
   [first_name.downcase,last_name.downcase].join( ' ' ).gsub(' ', '_')
  end

  def display_name
    "#{first_name} #{last_name}".titleize
  end

end
