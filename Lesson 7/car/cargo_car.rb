require_relative "car"

class CargoCar < Car
  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    @total_volume = total_volume
    super(:cargo)
    @occupied_volume = 0.0
    validate!
  end

  def fill_a_volume(volume)
    raise ArgumentError, "There is no free volume in the car" if (free_volume - volume) < 0
    self.occupied_volume += volume
  end

  def free_volume
    total_volume - occupied_volume
  end

  private

  attr_writer :total_volume, :occupied_volume

  def validate!
    raise ArgumentError, "The permissible range of volume is 60-100" unless @total_volume.between?(60,100)
  end
end

