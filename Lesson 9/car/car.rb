require_relative '../modules/manufacturer'
require_relative '../modules/validation'
require_relative "../modules/validators"

class Car
  include Manufacturer
  include Validation

  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  attr_reader :type, :total_volume, :occupied_volume

  def initialize(total_volume, type = nil)
    @type = type
    @total_volume = total_volume
    @occupied_volume = 0
    CarValidator.new({type: type}).validate!
  end

  def free_volume
    total_volume - occupied_volume
  end

  private

  attr_writer :total_volume, :occupied_volume
end
