class ClientRegistrationForm < UserRegistrationForm

  attribute :firstname, String
  attribute :lastname, String

  private
  def build_profileable
    Client.create!({firstname: firstname, lastname: lastname})
  end
end
