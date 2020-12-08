class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :groom, :bride, :gender

  def name
    object.full_name
  end

  def groom
    object.gender
  end

  def bride
    !object.gender
  end
end
