require_relative "station"
require_relative "route"
require_relative "train/train"
require_relative "train/cargo_train"
require_relative "train/passenger_train"
require_relative "car/car"
require_relative "car/cargo_car"
require_relative "car/passenger_car"
require_relative "modules/instance_counter"

class RailRoad
  MENU = [
    { title: "create a station", action: :create_stations },
    { title: "create a train", action: :create_trains },
    { title: "create a route", action: :create_routes },
    { title: "add a station to the route", action: :add_stations },
    { title: "delete a station in the route", action: :delete_stations },
    { title: "assign a route to the train", action: :assign_route },
    { title: "add a carriage to the train", action: :add_carriage },
    { title: "take a seat/volume in the train car", action: :select_and_fill_car_volume },
    { title: "unhook the car from the train", action: :unhook_wagon },
    { title: "move the train along the route forward", action: :move_train_forward },
    { title: "move the train along the route back", action: :move_train_back },
    { title: "view the list of stations", action: :stations_list },
    { title: "view the list of trains at the station", action: :trains_on_stations_list },
    { title: "view the list of cars at the train", action: :cars_list },
    { title: "view the full list of trains at all stations", action: :full_trains_list_at_stations }
  ].freeze

  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
  end

  def load_seeds
    station_seeds
    routes_seeds
    trains_seeds
    car_seeds
    acept_route_seeds
  end

  def menu
    puts "A virtual simulator of the railway system welcomes you"
    loop do
      puts "Select the number of the action you need:"
      MENU.each.with_index(1) { |item, index| puts "#{index} -> #{item[:title]}" }
      puts "0 -> for exit"
      choise = gets.chomp.to_i
      break if choise.zero?

      selected_item = MENU[choise - 1]
      send(selected_item[:action])
    end
  end

  # скрываем реализацию методов и доступ к переменным вне класса
  private

  attr_reader :stations, :routes, :trains

  def create_stations
    puts "Enter the name of the creating station:"
    title = gets.chomp
    stations[title] = Station.new(title)
    puts "#{title} station has been created!"
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_trains
    type = make_type
    number = make_number
    create_new_train(number, type)
  end

  def make_type
    puts "Enter 1 if you are going to create a cargo train, 2 if passenger"
    choise = gets.chomp.to_i
    raise "Input error. Use the command number 1 or 2" unless [1, 2].include?(choise)

    choise
  rescue StandardError => e
    puts e.message
    retry
  end

  def make_number
    puts "Enter the train number (Use letters and numbers in the format: XXX-XX/XXXXX)"
    number = gets.chomp

    number
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_new_train(number, type)
    case type
    when 1
      trains[number] = CargoTrain.new(number)
      puts "Cargo train number #{number} created"
    when 2
      trains[number] = PassengerTrain.new(number)
      puts "Passenger train number #{number} created"
    end
  end

  def create_routes
    return data_error if station_list.count < 2

    puts "Enter the start station number"
    first_station = select_from_collection(stations)
    puts "Enter the end station number"
    last_station = select_from_collection(stations)
    return data_error if first_station.nil? || last_station.nil?

    route_title = "#{first_station.title} - #{last_station.title}"
    routes[route_title] = Route.new(first_station, last_station)
    puts "The new route \"#{route_title}\" created!"
  end

  def add_stations
    return data_error if (station_list.count < 3) || route_list.empty?

    puts "Select a route number"
    route = select_from_collection(routes)
    return data_error if route.nil?

    puts "Select the station number to add"
    station = select_from_collection(stations)
    return data_error if station.nil?

    route.add_station(station)
    puts "Station \"#{station.title}\" added to the route. Current route:"
    route.show_stations
  end

  def delete_stations
    return data_error if route_list.empty?

    puts "Select a route number"
    route = select_from_collection(routes)
    return data_error if route.stations.length == 2 || route.nil?

    puts "Enter the number of the station to be deleted"
    station = select_from_collection(stations)
    return data_error if station.nil?

    route.delete_station(station)
    puts "Station \"#{station.title}\" deletet from the route \"#{name_of_route(route)}\". Current route:"
    puts route.show_stations
  end

  def assign_route
    return data_error if route_list.empty? || trains.empty?

    puts "Select a train number"
    train = select_from_collection(trains)
    return data_error if train.nil?

    puts "Select a route number"
    route = select_from_collection(routes)
    return data_error if route.nil?

    train.accept_route(route)
    puts "Train number #{train.number} is assigned the route \"#{name_of_route(route)}\""
  end

  def add_carriage
    return data_error if trains.empty?

    puts "Select a train number"
    train = select_from_collection(trains)
    return data_error if train.nil?

    create_a_wagon(train)
    puts "The carriage has been added to train number #{train.number}"
    puts "Total cars in the train: #{train.car_list.count}"
  rescue ArgumentError => e
    puts "Error! #{e.message}"
    retry
  end

  def create_a_wagon(train)
    case train.type
    when :cargo
      puts "Enter the value of the volume of the car (the permissible range of values is 60-100 cubic meters)"
      volume = gets.chomp.to_i
      train.add_car(CargoCar.new(volume))
    when :passenger
      puts "Enter the value of the number of seats in the car (the acceptable range of values is 20-80 places)"
      seats = gets.chomp.to_i
      train.add_car(PassengerCar.new(seats))
    end
  end

  def unhook_wagon
    return data_error if trains.empty?

    puts "Select a train number"
    train = select_from_collection(trains)
    return data_error if train.car_list.empty?

    train.delete_car
    puts "The carriage has been unhooked to train number #{train.number}"
    puts "Total cars in the train: #{train.car_list.count}"
  end

  def move_train_forward
    return data_error if route_list.empty? || trains.empty?

    train = select_from_collection(trains)
    return data_error if train.current_station.nil? || train.next_station.nil?

    train.go_to_next_station
    puts "Train number #{train.number} has arrived " \
         "at the station \"#{train.current_station.title}\" station"
  end

  def move_train_back
    return data_error if route_list.empty? || trains.empty?

    puts "Enter the number of the train being moved"
    train = select_from_collection(trains)
    return data_error if train.current_station.nil? || train.previous_station.nil?

    train.go_to_previous_station
    puts "Train number #{train.number} moved from \"#{train.next_station.title}\"" \
         "station to \"#{train.current_station.title}\" station"
  end

  def stations_list
    return data_error if stations.empty?

    puts station_list.join(", ")
  end

  def trains_on_stations_list
    return data_error if stations.empty? || trains.empty?

    puts "Enter the number of the desired station"
    station = select_from_collection(stations)
    puts station.show_trains
  end

  def cars_list
    raise "No trains created" if trains_list.empty?

    puts "Enter the number of the required train"
    train = select_from_collection(trains)
    raise "There are no attached cars on the train #{train.number}" if train.car_list.empty?

    show_train_car_list(train)
  rescue RuntimeError => e
    puts e.message
  end

  def show_train_car_list(train)
    train.each_car do |car, index|
      case car.type
      when :cargo
        puts "Car number: #{index}, car type: #{car.type}, free volume: " \
             "#{car.free_volume} m3, occupied volume: #{car.occupied_volume} m3"
      when :passenger
        puts "Car number: #{index}, car type: #{car.type}, free seats: " \
             "#{car.free_volume}, occupied seats: #{car.occupied_volume}"
      end
    end
  end

  def full_trains_list_at_stations
    raise "No trains created" if trains_list.empty?
    raise "No stations created" if station_list.empty?

    stations.values.each.with_index(1) do |station, index_s|
      puts "#{index_s}: #{station.title}"
      puts "      There are no trains at the station" if station.train_list.empty?

      station.each_train { |train, index| puts "      #{index}: #{train.number}" }
    end
  rescue RuntimeError => e
    puts e.message
  end

  def select_and_fill_car_volume
    raise "No trains created" if trains_list.empty?

    puts "Enter the number of the required train"
    train = select_from_collection(trains)
    raise "There are no attached cars on the train #{train.number}" if train.car_list.empty?

    fill_car_volume(train)
  rescue StandardError => e
    puts e.message
    retry
  end

  def fill_car_volume(train)
    raise "There are no attached cars on the train #{train.number}" if train.car_list.empty?

    puts "Enter the number of the required car"
    car = select_from_car(train)
    load_volume(car)
  end

  def load_volume(car)
    case car.type
    when :cargo
      fill_cargo_volume(car)
    when :passenger
      take_a_passenger_seat(car)
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def fill_cargo_volume(car)
    puts "Enter the volume to be filled in (m3) (free volume #{car.free_volume} m3)"
    volume = gets.chomp.to_f
    car.fill_a_volume(volume)
    puts "Car added #{volume} m3, free volume #{car.free_volume} m3"
  end

  def take_a_passenger_seat(car)
    car.take_a_seat
    puts "The seat is occupied, there are #{car.free_volume} empty seats"
  end

  def select_from_car(train)
    puts display_car_collection(train)
    index = gets.chomp.to_i - 1
    return data_error if index.negative?

    train.car_list[index]
  end

  def display_car_collection(train)
    train.car_list.map.with_index(1) { |_item, index| "Car number #{index}" }
  end

  def station_list
    stations.keys
  end

  def route_list
    routes.keys
  end

  def trains_list
    trains.keys
  end

  def collection_keys(collection)
    collection.keys
  end

  def collection_values(collection)
    collection.values
  end

  def display_collection(collection)
    collection_keys(collection).map.with_index(1) { |item, index| "#{index} - #{item}" }
  end

  def select_from_collection(collection)
    puts display_collection(collection)
    index = gets.chomp.to_i - 1
    return data_error if index.negative?

    collection[collection_keys(collection)[index]]
  end

  def name_of_route(route)
    "#{route.stations.first.title} - #{route.stations.last.title}"
  end

  def data_error
    puts "Data error!"
  end

  def station_seeds
    stations['Kazan'] = Station.new('Kazan')
    stations['Kanash'] = Station.new('Kanash')
    stations['Nizhniy Novgorod'] = Station.new('Nizhniy Novgorod')
    stations['Gus Hrustalniy'] = Station.new('Gus Hrustalniy')
    stations['Lubertsy'] = Station.new('Lubertsy')
    stations['Moscow'] = Station.new('Moscow')
  end

  def routes_seeds
    routes['Kazan - Moscow'] = Route.new(stations['Kazan'], stations['Moscow'])
    routes['Kazan - Moscow'].add_station(stations['Kanash'])
    routes['Kazan - Moscow'].add_station(stations['Nizhniy Novgorod'])
    routes['Kazan - Moscow'].add_station(stations['Gus Hrustalniy'])
    routes['Kazan - Moscow'].add_station(stations['Lubertsy'])
    routes['Moscow - Kazan'] = Route.new(stations['Moscow'], stations['Kazan'])
    routes['Moscow - Kazan'].add_station(stations['Lubertsy'])
    routes['Moscow - Kazan'].add_station(stations['Gus Hrustalniy'])
    routes['Moscow - Kazan'].add_station(stations['Nizhniy Novgorod'])
    routes['Moscow - Kazan'].add_station(stations['Kanash'])
  end

  def trains_seeds
    trains['PAS-71'] = PassengerTrain.new('PAS-71')
    trains['PAS-52'] = PassengerTrain.new('PAS-52')
    trains['CAR-43'] = CargoTrain.new('CAR-43')
    trains['CAR-78'] = CargoTrain.new('CAR-78')
  end

  def car_seeds
    12.times { trains['PAS-71'].add_car(PassengerCar.new(40)) }
    10.times { trains['PAS-52'].add_car(PassengerCar.new(40)) }
    13.times { trains['CAR-43'].add_car(CargoCar.new(100)) }
    14.times { trains['CAR-78'].add_car(CargoCar.new(100)) }
  end

  def acept_route_seeds
    trains['PAS-71'].accept_route(routes['Kazan - Moscow'])
    trains['PAS-52'].accept_route(routes['Moscow - Kazan'])
    trains['CAR-43'].accept_route(routes['Kazan - Moscow'])
    trains['CAR-78'].accept_route(routes['Moscow - Kazan'])
    trains['PAS-71'].go_to_next_station
    trains['PAS-71'].go_to_next_station
  end
end

# irb -r ./main.rb
rr = RailRoad.new
rr.load_seeds
rr.menu
