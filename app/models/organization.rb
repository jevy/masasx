class Organization < ActiveRecord::Base

  has_many :organization_admins
  has_one :primary_organization_administrator,   class_name: 'OrganizationAdmin', conditions: { role: 'Primary'   }
  has_one :secondary_organization_administrator, class_name: 'OrganizationAdmin', conditions: { role: 'Secondary' }
  has_one :authority_organization_administrator, class_name: 'OrganizationAdmin',
    conditions: OrganizationAdmin.arel_table[:role].eq('Authority').or(OrganizationAdmin.arel_table[:executive].eq(true))

  has_many :accounts

  accepts_nested_attributes_for :primary_organization_administrator
  accepts_nested_attributes_for :secondary_organization_administrator
  accepts_nested_attributes_for :authority_organization_administrator

  scope :pending_approval,  where(status: 'pending_approval')
  scope :approved,          where(status: 'approved')
  scope :rejected,          where(status: 'rejected')

  attr_accessor :agreements

  after_initialize :init_agreements

  def init_agreements
    self.agreements = self.persisted? ? Agreement.all : []
  end

  def has_executive?
    organization_admins.find { |admin| admin.executive? || admin.role == 'Authority' }.present?
  end

  state_machine :status, initial: :agreement, action: :save_state, use_transactions: false do

    event :next do
      transition agreement: :organization
      transition organization: :primary_contact
      transition primary_contact: :secondary_contact
      transition secondary_contact: :references, if: -> organization { organization.has_executive?  }
      transition secondary_contact: :authority,  unless: -> organization { organization.has_executive?  }
      transition references: :pending_approval
    end

    event :previous do
      transition organization: :agreement
      transition primary_contact: :organization
      transition secondary_contact: :primary_contact
      transition authority: :secondary_contact
      transition references: :secondary_contact, if: -> organization do
        executive = organization.organization_admins.find { |a| a.executive }
        executive ? %w{Primary Secondary}.include?(executive.role) : false
      end
      transition references: :authority, unless: -> organization do
        executive = organization.organization_admins.find { |a| a.executive }
        executive ? %w{Primary Secondary}.include?(executive.role) : false
      end
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
