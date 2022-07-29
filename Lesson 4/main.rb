require_relative "station"
require_relative "route"
require_relative "train/train"
require_relative "train/cargo_train"
require_relative "train/passenger_train"
require_relative "car/car"
require_relative "car/cargo_car"
require_relative "car/passenger_car"

class RailRoad
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = {} #why hashes, not arrays?
    @routes = {}
    @trains = {}
  end

  def intro
    puts "Hello! This is a virtual railway management system."
    puts "Choose what you want to do:"
  end

  def menu
    loop do
      puts "---------------------------------------------------------------"
      puts "Choose what you want to do:"
      puts "Enter 1 to create a station"
      puts "Enter 2 to create a train"
      puts "Enter 3 to create a route"
      puts "Enter 4 to add a station to the route"
      puts "Enter 5 to delete a station in the route"
      #puts "Enter 6 to assign a route to the train"
      #puts "Enter 7 to add a carriage to the train"
      #puts "Enter 8 to unhook the car from the train"
      #puts "Enter 9 to move the train along the route forward one station"
      #puts "Enter 10 to move the train along the route back to one station"
      #puts "Enter 11 to view the list of stations"
      #puts "Enter 12 to view the list of trains at the station"
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
        else
          data_error
      end
    end
  end

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

=begin
    routes['Moscow - Kazan'] = Route.new(stations['Moscow'], stations['Kazan'])
    routes['Moscow - Kazan'].add_station(stations['Lubertsy'])
    routes['Moscow - Kazan'].add_station(stations['Gus Hrustalniy'])
    routes['Moscow - Kazan'].add_station(stations['Nizhniy Novgorod'])
    routes['Moscow - Kazan'].add_station(stations['Kanash'])

    trains['P-71'] = PassengerTrain.new('P-71')
    trains['P-52'] = PassengerTrain.new('P-52')
    trains['C-4312'] = CargoTrain.new('C-4312')
    trains['C-7843'] = CargoTrain.new('C-7843')

    1.times { trains['P-71'].add_car(PassengerCar.new) }
    2.times { trains['P-52'].add_car(PassengerCar.new) }
    3.times { trains['C-4312'].add_car(CargoCar.new) }
    4.times { trains['C-7843'].add_car(CargoCar.new) }

    trains['P-71'].accept_route(routes['Kazan - Moscow'])
    trains['P-52'].accept_route(routes['Moscow - Kazan'])
    trains['C-4312'].accept_route(routes['Kazan - Moscow'])
    trains['C-7843'].accept_route(routes['Moscow - Kazan'])
=end
  end

  def create_stations
    puts "Enter the name of the creating station:"

    title = gets.chomp

    if stations[title].nil?
      stations[title] = Station.new(title)
      puts "#{title} station has been created!"
    else
      puts "#{title} station already exists!"
    end
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
        data_error
        return
    end

    puts "Enter the train number"

    number = gets.chomp

    case type
      when :cargo
        number = 'C-' + number
        trains[number] = CargoTrain.new(number)
        puts "Cargo train #{number} created"
      when :passenger
        number = 'P-' + number
        trains[number] = PassengerTrain.new(number)
        puts "Passenger train #{number} created"
    end
  end

  def create_routes
    return data_error if station_list.count < 2

    puts "Enter the start and end station number"
    puts station_list.map.with_index(1) { |station_name, index| "#{index} - #{station_name}" } #.join(", ")

    first = gets.chomp
    last = gets.chomp
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
    selected_route.show_stations #string view? how?
  end

  def delete_stations

    puts "Select a route number"
    puts route_list_with_index

    selection = gets.chomp
    selected_route = selected_route(selection)

    return data_error if selected_route.stations.length == 2

    puts "Enter the number of the station to be deleted"
    available_stations = all_route_stations(selected_route) - [selected_route.stations.first.title] - [selected_route.stations.last.title]
    puts available_stations_with_index(available_stations)

    selection_1 = gets.chomp
    selected_station = stations[available_stations[selection_1.to_i - 1]]

    return data_error if selected_station.nil?

    selected_route.delete_station(selected_station)
    puts "Station \"#{selected_station.title}\" deletet from the route. Current route:"
    selected_route.show_stations
  end

  #private

  def station_list
    stations.keys
  end

  def route_list
    routes.keys
  end

  def route_list_with_index
    route_list.map.with_index(1) { |route_name, index| "#{index} - #{route_name}" }
  end

  def selected_route(selection)
    routes[route_list[selection.to_i - 1]]
  end

  def all_route_stations(selected_route)
    selected_route.stations.map { |station| station.title }
  end

  def available_stations_with_index(available_stations)
    available_stations.map.with_index(1) { |station_name, index| "#{index} - #{station_name}" }
  end

  #def selected_station(selection_1)
   # stations[available_stations[selection_1.to_i - 1]]
  #end

  def data_error
    puts "Data error!"
  end



end

#irb -r ./main.rb
rr = RailRoad.new
rr.load_seeds
#rr.add_stations
rr.delete_stations





