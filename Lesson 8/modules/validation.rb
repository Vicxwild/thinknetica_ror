module Validation
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
