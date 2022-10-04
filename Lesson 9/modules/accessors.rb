module Acсessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*params)
      @@store = Hash.new([])
      params.each do |param|
        define_method(param) do
          instance_variable_get("@#{param}")
        end

        define_method("#{param}=") do |value|
          @@store[param] << value
          instance_variable_set("@#{param}", value)
        end

        define_method("#{param}_history") do
          instance_variable_get("@#{param}_history") ||
          instance_variable_set("@#{param}_history", @@store[param])
        end
      end
    end

    def strong_attr_accessor(param, class_name)
      define_method(param) do
        instance_variable_get("@#{param}")
      end

      define_method("#{param}=") do |value|
        raise TypeError, "Invalid type of value (allowed #{class_name})" unless value.is_a? class_name
        instance_variable_set("@#{param}", value)
      end
    end
  end
end

class Main
  include Acсessors

  attr_accessor_with_history :foo, :bar, :bus
  strong_attr_accessor(:fo, Integer)
end

bla = Main.new
bla.fo = 'sd'
p bla.fo

#bla.foo = 2
#bla.foo = 24

