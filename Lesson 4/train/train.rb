class Train

  attr_reader :car_list, :speed, :route, :station, :type, :current_station

  def initialize(number)
    @number = number
    @type = nil
    @car_list = []
    @speed = 0
  end

  def gain_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end

  def add_car(car)
    car_list << car if (speed == 0 && car.type == type) #why is here inst var, but not meth
  end

  def delete_car
    car_list.pop if (speed == 0 && @car_list.length > 0)
  end

  def accept_route(route)
    self.route = route
    self.current_station = route.stations[0]
    current_station.take_train(self)
  end

  def go_to_next_station
    return if next_station.nil?
    current_station.send_train(self)
    self.current_station = next_station
    current_station.take_train(self)
  end

  def go_to_previous_station
    return if previous_station.nil?
    current_station.send_train(self)
    self.current_station = previous_station
    current_station.take_train(self)
  end

  def next_station
    return if route.stations.last == route.stations[station_id]
    route.stations[station_id + 1]
  end

  def previous_station
    return if route.stations.first == route.stations[station_id]
    route.stations[station_id - 1]
  end

  private

  # скрываем для вызова метода изменения скорости исключительно в контексте собственного объекта
  attr_writer :speed

  # скрываем для вызова метода изменения маршрута исключительно в контексте собственного объекта
  attr_writer :route

  # скрываем для вызова метода изменения текущей станции исключительно в контексте собственного объекта
  attr_writer :current_station

  # скрываем внутреннюю реализацию определения положения
  def station_id
    route.position(current_station)
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
