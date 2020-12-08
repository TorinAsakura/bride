module Storage
  def self.name(mounted_as, model)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, "#{Time.now.strftime("%H-%M-%S")}_#{SecureRandom.hex(4)}")
  end
end
