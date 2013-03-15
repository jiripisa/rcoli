class InvalidCommand < Exception
end

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
    
    def parse_args(args, result)
      args.each do |arg|
        if (is_option? arg)
          if (valid_option? arg)
            
          else
            raise InvalidCommand, "#{arg} is not a valid option"
          end
        end
      end
    end
    
    private
    def valid_option?(value)
      return @options.any? {|opt| opt.correspond?(value)}
    end
    
    def is_option?(value)
      value.start_with?('-')
    end
    
  end
      
  module Option
    
    setter :description
    
    def initialize(names)
      @s_name = names[:short]
      @l_name = names[:long]
    end
    
    def correspond?(value)
      return (value.sub('-','').eql? @s_name or value.sub('--','').eql? @l_name)
    end
    
  end
  
  class Switch
    
    include Option
    
  end
  
  class Flag
    
    include Option
    
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
  
  class ParsedArgs
    
    attr_reader :global_options
    attr_reader :options
    
    attr_accessor :command
    
    def initialize
      @global_options = {}
      @options = {}
    end
    
  end
  
end