class Train
  attr_accessor :speed
  attr_reader :car_amount, :route, :station, :type, :current_station

  def initialize(number, type, car_amount)
    @number = number
    @type = type
    @car_amount = car_amount
    @speed = 0
  end

  def gain_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end

  def add_car
    @car_amount += 1 if speed == 0
  end

  def delete_car
    @car_amount -= 1 if speed == 0
  end

  def accept_route(route)
    @route = route
    @current_station = @route.stations[0]
    @current_station.take_train(self)
  end

  def go_to_next_station
    return if next_station.nil?
    @current_station.send_train(self)
    @current_station = next_station
    @current_station.take_train(self)
  end  

  def go_to_previous_station
    return if previous_station.nil?
    @current_station.send_train(self)
    @current_station = previous_station
    @current_station.take_train(self)
  end

  def next_station
    return if @route.stations.last == @route.stations[station_id]
    @route.stations[station_id + 1]
  end

  def previous_station
    return if @route.stations.first == @route.stations[station_id]
    @route.stations[station_id - 1]
  end

  def station_id
    @route.position(@current_station)
  end
end

=begin
load './train.rb'
tr1 = Train.new("tr1", 'cargo', 44)
tr2 = Train.new("tr2", 'cargo', 56)
tr3 = Train.new("tr3", 'passenger', 12)
tr4 = Train.new("tr4", 'passenger', 15)
tr1.accept_route(rt)
tr2.accept_route(rt)
tr3.accept_route(rt)
tr4.accept_route(rt)
tr1.go_to_next_station
=end





