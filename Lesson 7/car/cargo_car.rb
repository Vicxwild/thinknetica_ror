#require_relative "car"

class CargoCar < Car
  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    super(:cargo)
    @total_volume = total_volume
    @occupied_volume = 0.0
  end

  def fill_a_volume(volume)
    raise "There is no free volume in the car" if (free_volume - volume) < 0
    self.occupied_volume += volume
  end

  def free_volume
    total_volume - occupied_volume
  end

  private

  attr_writer :total_volume, :occupied_volume
end


#p CargoCar.new(10).free_volume
