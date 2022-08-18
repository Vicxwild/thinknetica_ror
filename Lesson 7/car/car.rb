require_relative "../modules/manufacturer"
require_relative "../modules/validation"

class Car
  include Manufacturer
  include Validation

  attr_reader :type

  TYPE_PATTERN = /^cargo$|^passenger$/

  def initialize(type = nil)
    @type = type
    validate!
  end

  private
  def validate!
    raise "Input error. Use :cargo or :passenger" if @type.to_s !~ TYPE_PATTERN
  end
end
