require_relative "modules/instance_counter"
require_relative "modules/validation"
require_relative "modules/validators"

class Station
  include InstanceCounter
  include Validation

  TITLE_PATTERN = /^[a-zа-я\d\s]{2,20}$/i.freeze

  attr_reader :train_list, :title

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    StationValidator.new({title: title}).validate!
    @train_list = []
    @@stations << self
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

  def each_train(&block)
    return to_enum(:each_train) unless block_given?

    train_list.each.with_index(1) { |train, index| block.call(train, index) }
  end
end
