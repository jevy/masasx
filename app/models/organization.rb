class Organization < ActiveRecord::Base

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

  def init_agreements
    self.agreements = self.persisted? ? Agreement.all : []
  end

  state_machine :status, initial: :agreement, action: :save_state, use_transactions: false do

    event :next do
      transition agreement: :organization,
        organization: :primary_contact,
        primary_contact: :secondary_contact,
        secondary_contact: :references,
        references: :pending_approval
    end

    event :previous do
      transition organization: :agreement,
        primary_contact: :organization,
        secondary_contact: :primary_contact,
        references: :secondary_contact
    end

    event :approve do
      transition pending_approval: :approved
    end

    event :reject do
      transition pending_approval: :rejected
    end

  end

  def save_state
    save(validate: false)
  end

  with_options if: -> organization { organization.persisted? && organization.status?(:agreement) } do |f|
    f.validate :accept_agreements
  end

  with_options if: -> organization { organization.status?(:organization) } do |f|
    f.validates :name, presence: { message: 'Name required' }
  end

  with_options if: -> organization { organization.status?(:references) } do |f|
    f.validates :references, presence: { message: 'References required' }
  end

  private
  def accept_agreements
    if self.agreements.reject(&:blank?).size < 3
      self.errors[:agreements] = 'All the agreements must be accepted.'
    end
  end
end
