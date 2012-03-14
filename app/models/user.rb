class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :agreement

  validates :agreement, acceptance: true
end
