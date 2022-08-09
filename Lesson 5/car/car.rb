require_relative "../modules/manufacturer"

class Car
  include Manufacturer

  attr_reader :type

  def initialize
    @type = nil
  end

end
