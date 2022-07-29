class Station
  attr_reader :train_list, :title

  def initialize(title)
    @title = title
    @train_list = []
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
end


=begin
load './station.rb'
st1 = Station.new('Kazan')
st2 = Station.new('Derbishki')
st3 = Station.new('Kulseitovo')
st4 = Station.new('Chipchugi')
=end
