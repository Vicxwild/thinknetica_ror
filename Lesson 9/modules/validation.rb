class ValidationError < StandardError
end

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, *options)
      @validates ||= []
      @validates << {
        attr_name: attr_name,
        validation_type: validation_type,
        options: options
      }
    end
  end

  module InstanceMethods
    def initialize(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def validate!
      @errors = []
      self.class.instance_variable_get("@validates").each do |hash|
        attr_name = hash[:attr_name]
        value = instance_variable_get("@#{attr_name}")
        validation_type = hash[:validation_type]
        option = hash[:options][0]
        send("validate_#{validation_type}", attr_name, value, option)
      end
      raise ValidationError, @errors.join(". ") unless @errors.empty?
    end

    def validate_presence(attr_name, value, _option)
      @errors << "#{attr_name} not presence" if value.nil? || value.to_s.empty?
    end

    def validate_format(attr_name, value, pattern)
      @errors << "#{attr_name} not in the format: #{pattern}" if value !~ pattern
    end

    def validate_type(attr_name, value, data_type)
      @errors << "#{attr_name} not in the data type: #{data_type}" unless value.is_a? data_type
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end
  end
end
