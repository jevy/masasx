class Account < ActiveRecord::Base

  belongs_to :organization

  include PermissionsManager

  attr_accessor :permissions_attributes

  after_initialize :init_permissions_store

  def init_permissions_store
    self.permissions_store ||= '0000'
  end

  def permissions_attributes= attributes
    attributes.keys.each do |service|
      service_constant = service.constantize
      attributes[service][:read].to_bool  ? self.can!(:read,  service_constant) : self.cant!(:read,  service_constant)
      attributes[service][:write].to_bool ? self.can!(:write, service_constant) : self.cant!(:write, service_constant)
    end
  end
end
