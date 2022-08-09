require_relative "../modules/instance_counter"

class Station
  include InstanceCounter

  attr_reader :train_list, :title

  @@all_stations = []

  def self.all
    @@all_stations.each { |station| station }
  end

  def initialize(title)
    @title = title
    @train_list = []
    @@all_stations << self
    register_instance
  end

  def take_train(train)
    train_list << train
  end

  def send_train(train)
    train_list.delete(train)
  end

  def type_list
    hash = Hash.new(0)
    train_list.each { |train| hash[train.type] += 1 }
    hash
  end

  def show_trains
    train_list.map { |train| "Train number #{train.number} - type: #{train.type}" }.join(", ")
  end
end
