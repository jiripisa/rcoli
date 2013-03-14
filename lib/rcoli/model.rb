module RCoLi
  
  module Program
        
    extend RCoLi::Properties     
        
    setter :name
    setter :author
    setter :version
    
    def command(name, &block)
      cmnd = RCoLi::Command.new(name)
      # block.call(cmnd)  
      cmnd.instance_eval &block
      (@commands ||= []) << cmnd
    end    
    
  end
  
  class Command
    
    extend RCoLi::Properties 
    
    setter :name
    setter :summary
    setter :description
    setter :syntax
    
    def initialize(name)
      @name = name
    end
    
  end
  
end