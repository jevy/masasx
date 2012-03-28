module PermissionsManager

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
    allowed_actions = ['3']
    allowed_actions << decode_action(action)
    permission_index = MasasService.position(service)

    allowed_actions.include?(permissions_store[permission_index])
  end

  def can! action, service
    permission_index   = MasasService.position(service)
    allowed_action     = decode_action(action)
    current_permission = permissions_store[permission_index]
    if current_permission == '0'
      permissions_store[permission_index] = allowed_action
    elsif current_permission != allowed_action
      permissions_store[permission_index] = '4'
    end
    update_attribute(:permissions_store, permissions_store)
  end

  def cant! action, service
    permission_index   = MasasService.position(service)
    allowed_action     = decode_action(action)
    current_permission = permissions_store[permission_index]
    if current_permission == '4'
      permissions_store[permission_index] = decode_action(action == :read ? :write : :read)
    elsif current_permission == allowed_action
      permissions_store[permission_index] = '0'
    end
    update_attribute(:permissions_store, permissions_store)
  end

  private

  def decode_action action
    :read ? '1' : '2'
  end
end
