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
  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
  end

  def menu
    load_seeds

    loop do
      puts "---------------------------------------------------------------"
      puts "A virtual simulator of the railway system welcomes you"
      puts "Select the number of the action you need:"
      puts "Enter 1 to create a station"
      puts "Enter 2 to create a train"
      puts "Enter 3 to create a route"
      puts "Enter 4 to add a station to the route"
      puts "Enter 5 to delete a station in the route"
      puts "Enter 6 to assign a route to the train"
      puts "Enter 7 to add a carriage to the train"
      puts "Enter 8 to take a seat/volume in the train car"
      puts "Enter 9 to unhook the car from the train"
      puts "Enter 10 to move the train along the route forward one station"
      puts "Enter 11 to move the train along the route back to one station"
      puts "Enter 12 to view the list of stations"
      puts "Enter 13 to view the list of trains at the station"
      puts "Enter 14 to view the list of cars at the train"
      puts "Enter 15 to view the full list of trains at all stations"
      puts "Enter 0 to terminate the program"
      puts "---------------------------------------------------------------"

      choise = gets.chomp.to_i

      break if choise == 0

      case choise
        when 1
          create_stations
        when 2
          create_trains
        when 3
          create_routes
        when 4
          add_stations
        when 5
          delete_stations
        when 6
          assign_route
        when 7
          add_carriage
        when 8
          fill_car_volume
        when 9
          unhook_wagon
        when 10
          move_train_forward
        when 11
          move_train_back
        when 12
          stations_list
        when 13
          trains_on_stations_list
        when 14
          cars_list
        when 15
          full_trains_list_at_stations
        else
          raise ArgumentError, "Input error. Use the command number from 0 to 12"
      end
    rescue ArgumentError => e
      puts e.message
    end
  end

  # скрываем реализацию методов и доступ к переменным вне класса
  #private

  attr_reader :stations, :routes, :trains

  def load_seeds
    stations['Kazan'] = Station.new('Kazan')
    stations['Kanash'] = Station.new('Kanash')
    stations['Nizhniy Novgorod'] = Station.new('Nizhniy Novgorod')
    stations['Gus Hrustalniy'] = Station.new('Gus Hrustalniy')
    stations['Lubertsy'] = Station.new('Lubertsy')
    stations['Moscow'] = Station.new('Moscow')

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

    trains['PAS-71'] = PassengerTrain.new('PAS-71')
    trains['PAS-52'] = PassengerTrain.new('PAS-52')
    trains['CAR-43'] = CargoTrain.new('CAR-43')
    trains['CAR-78'] = CargoTrain.new('CAR-78')

    12.times { trains['PAS-71'].add_car(PassengerCar.new(40)) }
    10.times { trains['PAS-52'].add_car(PassengerCar.new(40)) }
    13.times { trains['CAR-43'].add_car(CargoCar.new(100)) }
    14.times { trains['CAR-78'].add_car(CargoCar.new(100)) }

    trains['PAS-71'].accept_route(routes['Kazan - Moscow'])
    trains['PAS-52'].accept_route(routes['Moscow - Kazan'])
    trains['CAR-43'].accept_route(routes['Kazan - Moscow'])
    trains['CAR-78'].accept_route(routes['Moscow - Kazan'])
  end

  def create_stations
    puts "Enter the name of the creating station:"

    title = gets.chomp

    if stations[title].nil?
      stations[title] = Station.new(title)
      puts "#{title} station has been created!"
    else
      raise StandardError, "#{title} station already exists"
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_trains
    puts "Enter 1 if you are going to create a cargo train, 2 if passenger"

    choise = gets.chomp.to_i

    case choise
      when 1
        type = :cargo
      when 2
        type = :passenger
      else
        raise ArgumentError, "Input error. Use the command number 1 or 2"
    end

    puts "Enter the train number (Use letters and numbers in the format: XXX-XX/XXXXX)"

    number = gets.chomp

    case type
      when :cargo
        trains[number] = CargoTrain.new(number)
        puts "Cargo train #{number} created"
      when :passenger
        trains[number] = PassengerTrain.new(number)
        puts "Passenger train #{number} created"
    end
    rescue StandardError => e
      puts e.message
      retry
  end

  def create_routes
    return data_error if station_list.count < 2

    puts "Enter the start and end station number"
    puts station_list.map.with_index(1) { |station_name, index| "#{index} - #{station_name}" } #.join(", ")

    first = gets.chomp
    last = gets.chomp

    return data_error if first.to_i.zero? || last.to_i.zero?

    first_station = stations[station_list[first.to_i - 1]]
    last_station = stations[station_list[last.to_i - 1]]

    return data_error if first_station.nil? || last_station.nil?

    route_title = "#{first_station.title} - #{last_station.title}"
    routes[route_title] = Route.new(first_station, last_station)
    puts "The new route \"#{route_title}\" created!"
  end

  def add_stations
    return data_error if (station_list.count < 3) || route_list.empty?

    puts "Select a route number"
    puts route_list_with_index

    selection = gets.chomp
    selected_route = selected_route(selection)

    return data_error if selected_route.nil?

    available_stations = station_list - all_route_stations(selected_route)

    puts "Select the station number to add"
    puts available_stations_with_index(available_stations)

    selection_1 = gets.chomp
    selected_station = stations[available_stations[selection_1.to_i - 1]]

    return data_error if selected_station.nil?

    selected_route.add_station(selected_station)
    puts "Station \"#{selected_station.title}\" added to the route. Current route:"
    selected_route.show_stations
  end

  def delete_stations
    return data_error if route_list.empty?

    puts "Select a route number"
    puts route_list_with_index

    selection = gets.chomp
    selected_route = selected_route(selection)

    return data_error if selected_route.stations.length == 2 || selected_route.nil?

    puts "Enter the number of the station to be deleted"
    available_stations = all_route_stations(selected_route) - [selected_route.stations.first.title] - [selected_route.stations.last.title]
    puts available_stations_with_index(available_stations)

    selection_1 = gets.chomp
    selected_station = stations[available_stations[selection_1.to_i - 1]]

    return data_error if selected_station.nil?

    selected_route.delete_station(selected_station)
    puts "Station \"#{selected_station.title}\" deletet from the route \"#{name_of_route(selected_route)}\". Current route:"
    selected_route.show_stations
  end

  def assign_route
    return data_error if route_list.empty? || trains.empty?

    puts "Select a train number"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    return data_error if selected_train.nil?

    puts "Select a route number"
    puts route_list_with_index

    selection_1 = gets.chomp
    selected_route = selected_route(selection_1)

    return data_error if selected_route.nil?

    selected_train.accept_route(selected_route)
    puts "Train number #{selected_train.number} is assigned the route \"#{name_of_route(selected_route)}\""
  end

  def add_carriage
    return data_error if trains.empty?

    puts "Select a train number"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    case selected_train.type
      when :cargo
        puts "Enter the value of the volume of the car (the permissible range of values is 60-100 cubic meters)"

        volume = gets.chomp.to_i

        selected_train.add_car(CargoCar.new(volume))

      when :passenger
        puts "Enter the value of the number of seats in the car (the acceptable range of values is 20-80 places)"

        seats = gets.chomp.to_i

        selected_train.add_car(PassengerCar.new(seats))

    end

    puts "The carriage has been added to train number #{selected_train.number}. Total cars in the train: #{selected_train.car_list.count}"

    rescue ArgumentError => e
    puts "Error! " + e.message
    retry
  end

  def unhook_wagon
    return data_error if trains.empty?

    puts "Select a train number"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    return data_error if selected_train.car_list.empty?

    selected_train.delete_car

    puts "The carriage has been unhooked to train number #{selected_train.number}. Total cars in the train: #{selected_train.car_list.count}"
  end

  def move_train_forward
    return data_error if route_list.empty? || trains.empty?

    puts "Enter the number of the train being moved"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    return data_error if selected_train.current_station.nil? || selected_train.next_station.nil? #twice??

    selected_train.go_to_next_station
    puts "Train number #{selected_train.number} moved from \"#{selected_train.previous_station.title}\" station to \"#{selected_train.current_station.title}\" station"
  end

  def move_train_back
    return data_error if route_list.empty? || trains.empty?

    puts "Enter the number of the train being moved"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    return data_error if selected_train.current_station.nil? || selected_train.previous_station.nil?

    selected_train.go_to_previous_station
    puts "Train number #{selected_train.number} moved from \"#{selected_train.next_station.title}\" station to \"#{selected_train.current_station.title}\" station"
  end

  def stations_list
    return data_error if stations.empty?

    puts station_list.join(", ")
  end

  def trains_on_stations_list
    return data_error if stations.empty? || trains.empty?

    puts "Enter the number of the desired station"
    puts station_list.map.with_index(1) { |station_name, index| "#{index} - #{station_name}" } #.join(", ")

    selection = gets.chomp
    selected_station = stations[station_list[selection.to_i - 1]]

    puts selected_station.show_trains
  end

  def cars_list
    raise RuntimeError, "No trains created" if trains_list.empty?

    puts "Enter the number of the required train"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    raise RuntimeError, "There are no attached cars on the train #{selected_train.number}" if selected_train.car_list.empty?

    selected_train.each_car do |car, index|
      case car.type
        when :cargo
          puts "Car number: #{index}, car type: #{car.type}, free volume: #{car.free_volume} m3, occupied volume: #{car.occupied_volume} m3"
        when :passenger
          puts "Car number: #{index}, car type: #{car.type}, free seats: #{car.available_seats}, occupied seats: #{car.occupied_seats}"
      end
    end

    rescue RuntimeError => e
    puts e.message
    retry
  end

  def full_trains_list_at_stations
    raise RuntimeError, "No trains created" if trains_list.empty?
    raise RuntimeError, "No stations created" if station_list.empty?

    stations.values.each.with_index(1) do |station, index_s|
      puts "#{index_s}: #{station.title}"
      puts "      There are no trains at the station" if station.train_list.empty?

      station.each_train { |train, index| puts "      #{index}: #{train.number}" }
    end

    rescue RuntimeError => e
    puts e.message
  end

  def fill_car_volume
    raise RuntimeError, "No trains created" if trains_list.empty?

    puts "Enter the number of the required train"
    puts train_list_with_index

    selection = gets.chomp
    selected_train = selected_train(selection)

    raise RuntimeError, "There are no attached cars on the train #{selected_train.number}" if selected_train.car_list.empty?

    puts "Enter the number of the required car"
    selected_train.each_car { |car, index| puts "Car number #{index}" }

    selected_car = gets.chomp
    selected_car = selected_train.car_list[selected_car.to_i - 1]

    case selected_car.type
      when :cargo
        puts "Enter the volume to be filled in (m3) (free volume #{selected_car.free_volume} m3)"
        volume = gets.chomp.to_f
        selected_car.fill_a_volume(volume)
        puts "Car added #{volume} m3, free volume #{selected_car.free_volume} m3"
      when :passenger
        selected_car.take_a_seat
        puts "The seat is occupied, there are #{selected_car.available_seats} empty seats"
    end
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

  def route_list_with_index
    route_list.map.with_index(1) { |route_name, index| "#{index} - #{route_name}" }
  end

  def train_list_with_index
    trains_list.map.with_index(1) { |train_name, index| "#{index} - #{train_name}" }
  end

  def selected_route(selection)
    routes[route_list[selection.to_i - 1]]
  end

  def selected_train(selection)
    trains[trains_list[selection.to_i - 1]]
  end

  def all_route_stations(selected_route)
    selected_route.stations.map { |station| station.title }
  end

  def available_stations_with_index(available_stations)
    available_stations.map.with_index(1) { |station_name, index| "#{index} - #{station_name}" }
  end

  def name_of_route(route)
    "#{route.stations.first.title} - #{route.stations.last.title}"
  end

  def data_error
    puts "Data error!"
  end
end

#irb -r ./main.rb
rr = RailRoad.new
rr.load_seeds
rr.menu
