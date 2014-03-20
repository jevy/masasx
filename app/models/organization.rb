class Organization < ActiveRecord::Base
  STEPS = %w[agreement organization primary_contact secondary_contact references].map(&:to_sym)

  has_paper_trail :on => [:update]

  has_many :organization_admins
  has_one :primary_organization_administrator,   class_name: 'OrganizationAdmin', conditions: { role: 'Primary'   }
  has_one :secondary_organization_administrator, class_name: 'OrganizationAdmin', conditions: { role: 'Secondary' }

  has_many :accounts

  accepts_nested_attributes_for :primary_organization_administrator
  accepts_nested_attributes_for :secondary_organization_administrator

  scope :pending_approval,  where(status: 'pending_approval')
  scope :approved,          where(status: 'approved')
  scope :rejected,          where(status: 'rejected')

  attr_accessor :agreements

  after_initialize :init_agreements
  before_create :generate_uuid

  def init_agreements
    self.agreements = self.persisted? ? Agreement.all : []
  end

  state_machine :status, initial: :agreement, action: :save_state, use_transactions: false do

    event :next do
      transition agreement: :organization
      transition organization: :primary_contact
      transition primary_contact: :secondary_contact
      transition secondary_contact: :references
      transition references: :pending_approval
    end

    event :previous do
      transition organization: :agreement
      transition primary_contact: :organization
      transition secondary_contact: :primary_contact
      transition references: :secondary_contact
    end

    before_transition on: :approve, do: -> organization { Directory.add_organization(organization) }
    event :approve do
      transition pending_approval: :approved
    end

    event :reject do
      transition pending_approval: :rejected
    end

  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def save_state
    save(validate: false)
  end

  with_options if: -> organization { organization.persisted? && organization.status?(:agreement) } do |f|
    f.validate :accept_agreements
  end

  with_options if: -> organization { organization.status?(:organization) } do |f|
    f.validates :name, presence: { message: 'Name required' }
    f.validates :address_line_1, presence: { message: 'Address Line 1 required' }
    f.validates :city, presence: { message: 'City required' }
    f.validates :state, presence: { message: 'State required' }
    f.validates :country, presence: { message: 'Country required' }
    f.validates :postal_code, presence: { message: 'Postal code required' }
    f.validates :website, format: URI::regexp(%w(http https))
  end

  with_options if: -> organization { organization.status?(:references) } do |f|
    f.validates :references, presence: { message: 'References required' }
  end

  def masas_name
   name.downcase.gsub(' ', '_')
  end

  def can_update_attributes?
    status == 'pending_approval'
  end

  private
  def accept_agreements
    if self.agreements.reject(&:blank?).size < 3
      self.errors[:agreements] = 'All the agreements must be accepted.'
    end
  end
end
