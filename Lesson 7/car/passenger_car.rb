class PassengerCar < Car
  attr_reader :number_of_seats, :occupied_seats

  def initialize(number_of_seats)
    super(:passenger)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
  end

  def available_seats
    number_of_seats - occupied_seats
  end

  def take_a_seat
    raise "There are no empty seats left in the car" if (available_seats - 1).negative?
    self.occupied_seats += 1
  end

  private

  attr_writer :number_of_seats, :occupied_seats
end
