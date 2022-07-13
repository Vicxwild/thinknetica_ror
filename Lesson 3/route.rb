class Route
  attr_reader :stations
  
  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delite_station(station)
    @stations.delete(station)
  end

  def show_stations
    @stations.each { |station| puts station }
  end

  def position(station)
    @stations.index(station)
  end
end

=begin
load './route.rb'
rt = Route.new(st1, st4)
rt.add_station(st2)
rt.add_station(st3)
=end


