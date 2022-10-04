require_relative "validation"

class StationValidator
  include Validation

  TITLE_PATTERN = /^[a-zа-я\d\s]{2,20}$/i.freeze

  validate :title, :format, TITLE_PATTERN
  validate :title, :type, String
end

class TrainValidator
  include Validation

  NUMBER_PATTERN = /^[а-яa-z\d]{3}-?[а-яa-z\d]{2}$/i.freeze
  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  validate :number, :presence
  validate :number, :format, NUMBER_PATTERN
  validate :type, :format, TYPE_PATTERN
end

class CarValidator
  include Validation

  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  validate :type, :format, TYPE_PATTERN
end

# p TrainValidator.new({number: "123-12", type: :cargo}).valid?
# p StationValidator.new({title: "Port"}).valid?
