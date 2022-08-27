require_relative "modules/instance_counter"
require_relative "modules/validation"

class Station
  include InstanceCounter
  include Validation

  attr_reader :train_list, :title

  TITLE_PATTERN = /^[a-zа-я\d\s]{1,20}$/i.freeze

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    validate!
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

  protected

  def validate!
    errors = []
    errors << "This station station already exists" if station?
    errors << "Use only letters, numbers and spaces; the length should not exceed 20 characters" if @title !~ TITLE_PATTERN
    raise errors.join(". ") unless errors.empty?
  end

  def station?
    @@stations.any? { |station| station.title == @title }
  end
end
