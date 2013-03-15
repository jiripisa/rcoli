module RCoLi
  
  module CommandContainer
    def command(name, &block)
      obj = Command.new(name)
      block.call(obj)  
      # cmnd.instance_eval &block
      (@commands ||= []) << obj
    end
    
    def switch(names, &block)
      obj = Switch.new(names)
      block.call(obj) if block_given?  
      (@options ||= []) << obj
    end
    
    def flag(names, &block)
      obj = Flag.new(names)
      block.call(obj) if block_given? 
      (@options ||= []) << obj
    end
    
  end
  
  module Program
    
    setter :name
    setter :author
    setter :version
    
    include CommandContainer    
    
  end
  
  class Option
    
    setter :description
    
    def initialize(names)
      @s_name = names[:short]
      @l_name = names[:long]
    end
    
  end
  
  class Switch < Option
  end
  
  class Flag < Option
    
    setter :default_value
    setter :arg_name
    
  end
    
  class Command
    
     

    setter :summary
    setter :description
    setter :syntax
    
    def initialize(name)
      @name = name
    end
    
    include CommandContainer
    
  end
  
end