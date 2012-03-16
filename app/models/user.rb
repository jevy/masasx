class User < ActiveRecord::Base

  include AASM

  authenticates_with_sorcery!

  attr_accessor :masax_agreement
  attr_accessor :media_agreement
  attr_accessor :community_agreement

  after_initialize :init_status

  def init_status
    self.status = 'agreement'
  end

  aasm column: :status do
    state :agreement, initial: true
    state :organization
    state :primary_contact
    state :secondary_contact
    state :references
    state :completed

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

  end

  def next!
    send("complete_#{self.status}!")
  end


  with_options if: -> user { user.status == 'agreement' } do |f|
    f.validates :masax_agreement, acceptance: true
    f.validates :media_agreement, acceptance: true
    f.validates :community_agreement, acceptance: true
  end
end
