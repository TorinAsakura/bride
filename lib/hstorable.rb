require 'active_record'
module Hstorable

  # Usage
  #
  # hstorable ({
  #   boolean_key:  lambda {|v| v == "true" ? true : false },
  #   string_key:   lambda {|v| v.to_s},
  #   integer_key:  lambda {|v| v.to_i},
  #   float_key:    lambda {|v| v.to_f},
  #   array_key:    lambda {|v| v[1..-2].split(',').collect!{|n| n.to_i} }
  #
  #   or
  #
  #   key:          { block: lambda{..}, default: val}
  #
  # }, column_name)
  #

  def hstorable (keys = {}, column = :data)
    serialize column, ActiveRecord::Coders::Hstore

    keys.each do |key, args|
      key = key.to_s

      if args.is_a? Hash
        block, default = args[:block], args[:default]
      else
        block, default = args, nil
      end

      attr_accessible key

      define_method(key) do
        data = self.send(column)
        value = data && data[key]
        value ? block.call(value) : default
      end

      define_method("#{key}=") do |value|
        self.send("#{column.to_s}=", (send(column) || {}).merge(key => value))
      end
    end
  end

end


ActiveRecord::Base.send :extend, Hstorable