class GuestSerializer < ActiveModel::Serializer
  attributes :id, :name, :groom, :bride, :gender

  def groom
    object.role.groom_guest?
  end

  def bride
    object.role.bride_guest?
  end
end
