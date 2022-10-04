require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"
require_relative "../modules/validation"
require_relative "../modules/validators"

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  attr_reader :car_list, :speed, :route, :station, :type, :current_station, :number

  @@all_trains = {}

  def self.find(number)
    @@all_trains[number]
  end

  def initialize(number, type = nil)
    @number = number
    @type = type
    @speed = 0
    TrainValidator.new({ number: number, type: type }).validate!
    @car_list = []
    @@all_trains[number] = self
    register_instance
  end

  def gain_speed(speed)
    self.speed += speed
    validate!
  end

  def stop
    self.speed = 0
  end

  def add_car(car)
    car_list << car if speed.zero? && car.type == type
  end

  def delete_car
    car_list.pop if speed.zero? && @car_list.length.positive?
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

  def each_car(&block)
    return to_enum(:each_car) unless block_given?

    car_list.each.with_index(1) { |car, index| block.call(car, index) }
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
