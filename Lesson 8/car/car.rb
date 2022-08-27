require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Car
  include Manufacturer
  include Validation

  attr_reader :type, :total_volume, :occupied_volume

  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  def initialize(total_volume, type = nil)
    @type = type
    @total_volume = total_volume
    @occupied_volume = 0
    validate!
  end

  def free_volume
    total_volume - occupied_volume
  end

  private

  attr_writer :total_volume, :occupied_volume

  def validate!
    raise 'Input error. Use :cargo or :passenger' if @type.to_s !~ TYPE_PATTERN
  end
end
