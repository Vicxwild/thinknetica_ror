require_relative 'car'

class CargoCar < Car
  def initialize(total_volume)
    super(total_volume, :cargo)
    @occupied_volume = 0.0
    validate!
  end

  def fill_a_volume(volume)
    raise ArgumentError, 'There is no free volume in the car' if (free_volume - volume).negative?

    self.occupied_volume += volume
  end

  private

  def validate!
    raise ArgumentError, 'The permissible range of volume is 60-100' unless @total_volume.between?(60, 100)
  end
end
