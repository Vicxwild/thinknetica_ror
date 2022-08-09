module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0 #conditional assignment operator
    end
  end

  module InstanceMethods
    def register_instance
      self.class.instances += 1
    end
  end
end
