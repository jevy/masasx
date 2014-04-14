class Organization < ActiveRecord::Base
  STEPS = %w[agreement organization primary_contact secondary_contact references].map(&:to_sym)

  has_paper_trail :on => [:update],
                  :if => Proc.new { |o| Organization.pending_approval.include? o }

  has_many :organization_admins
  has_one :primary_organization_administrator,   class_name: 'OrganizationAdmin', conditions: { role: 'Primary'   }
  has_one :secondary_organization_administrator, class_name: 'OrganizationAdmin', conditions: { role: 'Secondary' }

  accepts_nested_attributes_for :primary_organization_administrator
  accepts_nested_attributes_for :secondary_organization_administrator

  scope :pending_approval,  where(status: %w[new in_progress on_hold])
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
      transition references: :new
    end

    event :previous do
      transition organization: :agreement
      transition primary_contact: :organization
      transition secondary_contact: :primary_contact
      transition references: :secondary_contact
    end

    before_transition on: :approve, do: -> organization { Directory.add_organization(organization) }

    event :mark_as_new do
      transition new: :new
      transition in_progress: :new
      transition on_hold: :new
    end

    event :mark_as_in_progress do
      transition new: :in_progress
      transition in_progress: :in_progress
      transition on_hold: :in_progress
    end

    event :mark_as_on_hold do
      transition new: :on_hold
      transition in_progress: :on_hold
      transition on_hold: :on_hold
    end

    event :approve do
      transition new: :approved
      transition in_progress: :approved
      transition on_hold: :approved
    end

    event :reject do
      transition new: :rejected
      transition in_progress: :rejected
      transition on_hold: :rejected
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
    f.validates :email, presence: { message: 'A general contact email is required' }
    f.validates :website, format: URI::regexp(%w(http https))
  end

  with_options if: -> organization { organization.status?(:references) } do |f|
    f.validates :references, presence: { message: 'References required' }
  end

  def masas_name
   name.downcase.gsub(' ', '_')
  end

  def can_update_attributes?
    %[new in_progress on_hold].include?(status)
  end

  def as_contact
    result = OpenStruct.new
    result.department = department
    result.address_as_single_line = [address_line_1, address_line_2].join(', ')
    result.city = city
    result.state = state
    result.country = country
    result.office_phone = telephone
    result.website = website
    result.uuid = uuid
    result.name = name
    result.postal_code = postal_code
    result.email = email
    result
  end

  private
  def accept_agreements
    if self.agreements.reject(&:blank?).size < 3
      self.errors[:agreements] = 'All the agreements must be accepted.'
    end
  end
end
