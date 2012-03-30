module PermissionsManager

  NONE  = '0'
  READ  = '1'
  WRITE = '2'
  ALL   = '3'

  # Permissions are stored in the 'permissions_store' string. The string
  # represents an array of permissions services where each elements has the
  # following meaning:
  # 0 - no permissions
  # 1 - read permissions
  # 2 - write permissions
  # 3 - full permissions
  # Within the system permissions are represented using Constants that are
  # stores inside the MasasService module.

  def can? action, service
    allowed_actions = [ALL]
    allowed_actions << decode_action(action)
    permission_index = MasasService.position(service)

    allowed_actions.include?(permissions_store[permission_index])
  end

  def can! action, service
    permission_index   = MasasService.position(service)
    allowed_action     = decode_action(action)
    current_permission = permissions_store[permission_index]
    if current_permission == NONE
      permissions_store[permission_index] = allowed_action
    elsif current_permission != allowed_action
      permissions_store[permission_index] = ALL
    end
    self.permissions_store_will_change!
  end

  def cant! action, service
    permission_index   = MasasService.position(service)
    allowed_action     = decode_action(action)
    current_permission = permissions_store[permission_index]
    if current_permission == allowed_action
      permissions_store[permission_index] = NONE
    elsif current_permission == ALL
      permissions_store[permission_index] = decode_action(action == :read ? :write : :read)
    end
    self.permissions_store_will_change!
  end

  private

  def decode_action action
    action == :read ? READ : WRITE
  end
end
