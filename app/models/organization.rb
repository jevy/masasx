class Organization < ActiveRecord::Base

  include AASM

  has_one :primary_organization_administrator,   class_name: 'OrganizationAdmin'
  has_one :secondary_organization_administrator, class_name: 'OrganizationAdmin'

  has_many :accounts

  accepts_nested_attributes_for :primary_organization_administrator
  accepts_nested_attributes_for :secondary_organization_administrator

  scope :pending_approval, where(status: 'completed')

  attr_accessor :agreements

  after_initialize :init_status

  def init_status
    self.status     ||= 'agreement'
    self.agreements ||= []
  end

  aasm column: :status do
    state :agreement, initial: true
    state :organization
    state :primary_contact
    state :secondary_contact
    state :references
    state :completed
    state :approved

    event :complete_agreement do
      transitions to: :organization, from: :agreement
    end

    event :complete_organization do
      transitions to: :primary_contact, from: :organization
    end

    event :complete_primary_contact do
      transitions to: :secondary_contact, from: :primary_contact
    end

    event :complete_secondary_contact do
      transitions to: :references, from: :secondary_contact
    end

    event :complete_references do
      transitions to: :completed, from: :references
    end

    event :approve do
      transitions to: :approved, from: :completed
    end

  end

  def next!
    send("complete_#{self.status}!")
  end

  with_options if: -> user { user.status == 'agreement' } do |f|
    f.validate :accept_agreements
  end

  private
  def accept_agreements
    if self.agreements.reject(&:blank?).size < 3
      self.errors[:agreements] = 'All the agreements must be accepted.'
    end
  end
end
