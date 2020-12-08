module Ext
  module ActiveRecord
    def reject_invalid_fields(recursive = true)
      valid?
      errors.each do |field, _|
        if self.class.reflect_on_association(field)
          send(field).reject_invalid_fields(recursive)  if recursive && send(field).respond_to?(:reject_invalid_fields)
        else
          send("#{field}=", nil)
        end
      end
      self
    end
  end
end

ActiveRecord::Base.class_eval do
  include Ext::ActiveRecord
end
