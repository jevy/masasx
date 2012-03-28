class Account < ActiveRecord::Base
  include PermissionsManager

  after_initialize :init_permissions_store

  def init_permissions_store
    self.permissions_store ||= '0000'
  end
end
