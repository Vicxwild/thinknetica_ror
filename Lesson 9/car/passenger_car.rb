require_relative 'car'

class PassengerCar < Car
  def initialize(total_volume)
    super(total_volume, :passenger)
    @occupied_volume = 0
    validate!
  end

  def take_a_seat
    raise ArgumentError, 'No empty seats left in the car' if (free_volume - 1).negative?

    self.occupied_volume += 1
  end

  private

  def validate!
    raise ArgumentError, 'Invalid value entered. The acceptable range is 20-80' unless @total_volume.between?(20, 80)
  end
end
