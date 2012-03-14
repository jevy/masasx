class User < ActiveRecord::Base

  authenticates_with_sorcery!

  attr_accessor :masax_agreement
  attr_accessor :media_agreement
  attr_accessor :community_agreement

  after_initialize :init_status

  def init_status
    self.status = 'agreement'
  end

  with_options if: -> user { user.status == 'agreement' } do |f|
    f.validates :masax_agreement, acceptance: true
    f.validates :media_agreement, acceptance: true
    f.validates :community_agreement, acceptance: true
  end
end
