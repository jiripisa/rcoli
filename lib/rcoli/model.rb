module RCoLi
  
  module CommandContainer
    def command(name, &block)
      cmnd = RCoLi::Command.new(name)
      # block.call(cmnd)  
      cmnd.instance_eval &block
      (@commands ||= []) << cmnd
    end
  end
  
  module Program
        
    extend RCoLi::Properties     
        
    setter :name
    setter :author
    setter :version
    
    include CommandContainer    
    
  end
  
  class Command
    
    extend RCoLi::Properties 

    attr_reader :commands

    setter :name
    setter :summary
    setter :description
    setter :syntax
    
    def initialize(name)
      @commands = []
      @name = name
    end
    
    include CommandContainer
    
  end
  
end