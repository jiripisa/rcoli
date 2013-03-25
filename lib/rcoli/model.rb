class InvalidCommand < Exception
end

module RCoLi
  
  module CommandContainer
    
    attr_accessor :parent
    
    def action(&block)
      @action = block
    end
    
    def get_action
      @action
    end
    
    def command(name, &block)
      obj = Command.new(name)
      obj.parent = self
      block.call(obj)  
      commands << obj
    end
    
    def commands
      (@commands ||= [])
    end
    
    def options
      (@options ||= [])
    end
    
    def switch(names, &block)
      obj = Switch.new(names)
      block.call(obj) if block_given?  
      options << obj
    end
    
    def flag(names, &block)
      obj = Flag.new(names)
      block.call(obj) if block_given? 
      options << obj
    end
    
    def parse_args(args, result)
      return if args.empty?
      arg = args.delete_at(0)
      if (is_option? arg)
        if (option = find_option(arg))
          if (option.is_a? Flag)
            raise InvalidCommand, "Flag #{arg} is missing a value" if args.empty?
            value = args.delete_at(0)
          else
            value = true
          end
          target = self.parent ? :options : :global_options
          option.keys.each{|key| result.send(target)[key] = value}
        else
          raise InvalidCommand, "#'{arg}' is not a valid option"
        end
      else
        if (cmd = find_command(arg))
          result.command = cmd
          cmd.parse_args(args, result)
        elsif (commands.empty?)
          result.arguments << arg
        else
          raise InvalidCommand, "'#{arg}' is not a valid #{@name} command"
        end
      end
      parse_args(args, result)
    end
    
    private
    
    def find_option(name)
      options.find{|opt| opt.correspond?(name)}
    end
    
    def find_command(name)
      commands.find{|command| command.value_of_name.eql? name}
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
    
    def keys
      [@s_name, @l_name].compact
    end
    
    def help_keys
      result = []
      result << "-#{@s_name}" if @s_name
      result << "--#{@l_name}" if @l_name
      result
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
       
    setter :name    
    setter :summary
    setter :description
    setter :syntax
    
    def initialize(name)
      @name = name
    end
    
    include CommandContainer
    
  end
  
  class Program
    
    setter :name
    setter :author
    setter :version
    setter :description
    
    include Help
    include CommandContainer
      
    def execute(args, context)
      result = ParsedArgs.new
      parse_args(args, result)
      if result.command
        action = result.command.get_action
        context.instance_exec(result.global_options, result.options, result.arguments, &action)
      else
        say "Display UI"
      end
    end
    
  end
  
  
  class ParsedArgs
    
    attr_reader :global_options
    attr_reader :options
    attr_reader :arguments
    
    attr_accessor :command
    
    def initialize
      @global_options = {}
      @options = {}
      @arguments = []
    end
    
    def no_command?
      return @command.nil?
    end
    
  end
  
end