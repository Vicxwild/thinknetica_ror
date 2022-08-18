require_relative "modules/instance_counter"
require_relative "modules/validation"

class Station
  include InstanceCounter
  include Validation

  attr_reader :train_list, :title

  TITLE_PATTERN = /^[a-zа-я\d\s]{1,20}$/i

  @@stations = []

  def self.all
    @@stations.each { |station| station }
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

  protected
  def validate!
    raise "Input error. To create a title, use only letters, numbers and spaces; the length of the title should not exceed 20 characters" if @title !~ TITLE_PATTERN
  end
end
