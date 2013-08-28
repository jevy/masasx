class AdminAccount
  def initialize(contact)
    @contact = contact
  end

  def username
    (@contact.first_name[0] + @contact.last_name).to_s.downcase
  end

  def password
    'somestaticpasswd'
  end

  def accesscode
    'somestaticaccesscode'
  end

end
