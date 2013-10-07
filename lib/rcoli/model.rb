class InvalidCommand < Exception
end

class ApplicationError < Exception
end

module RCoLi
  
  module CommandContainer
    
    setter :force
    
    
    attr_accessor :parent
    
    
    def action(&block)
      @action = block
    end
    
    def get_action
      @action
    end
    
    def command(nam, &block)
      obj = Command.new(nam)
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
          raise InvalidCommand, "'#{arg}' is not a valid option"
        end
      else
        if (cmd = find_command(arg))
          result.command = cmd
          cmd.put_default_values(result)
          cmd.parse_args(args, result)
          cmd.validate_options(result, :options)
        elsif (commands.empty?)
          result.arguments << arg
        else
          raise InvalidCommand, "'#{arg}' is not a valid #{@name} command"
        end
      end
      parse_args(args, result)
    end
    
    def put_default_values(result)
      options.find_all{|option| option.respond_to? :value_of_default_value and option.value_of_default_value}.each do |option|
        target = self.parent ? :options : :global_options
        option.keys.each{|key| result.send(target)[key] = option.value_of_default_value}
      end
    end
    
    def find_command(name)
      result = commands.find{|command| command.value_of_name.to_s.eql? name}
      return result
    end
    
    def validate_options(result, target)
      if (result.command.nil? or result.command.value_of_force == true)
        return
      else
        self.options.find_all{|o| o.is_a? Flag and o.value_of_required}.each do |o|
          raise InvalidCommand, "Required option '#{o.to_s}' is missing" unless o.keys.find{|key| result.send(target)[key]}
        end
      end
    end
    
    private
    
    def find_option(name)
      options.find{|opt| opt.correspond?(name)}
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
    
    def to_s
      keys.join(', ')
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
    setter :required
    
  end
    
  class Command
       
    setter :name    
    setter :summary
    setter :description
    setter :syntax
    setter :skip_pre
    setter :skip_post
    
    def initialize(name)
      @name = name
    end
    
    include CommandContainer
    
    def full_command
      command = self
      result = []
      while(command.parent) do
        result << command.value_of_name
        command = command.parent
      end
      return result.reverse.join(' ')
    end
    
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
      put_default_values(result)      
      parse_args(args, result)
      validate_options(result, :global_options)
      if result.command
        
        # command has to have the action block
        action = result.command.get_action
        raise ApplicationError, "Invalid configuration. Missing action block." unless action
        
        # enable/disable logging level DEBUG
        if (result.global_options['debug'])
          context.instance_exec do
            log.level = Logger::DEBUG
          end
        end
        
        # enable dev mode
        if (result.global_options['dev-mode'])
          ApplicationContext.instance.devmode = true
        end
        
        # execution of the pre block
        context.instance_exec(result.global_options, result.options, result.arguments, &@pre_action) if (@pre_action and !result.command.value_of_skip_pre) 
        # execution of the main block
        context.instance_exec(result.global_options, result.options, result.arguments, &action)
        # execution of the post block
        context.instance_exec(result.global_options, result.options, result.arguments, &@post_action) if (@post_action and !result.command.value_of_skip_post) 
      else
        say "This feature is comming soon. You should execute '#{value_of_name} help' now."
      end
    end
    
    def pre(&block)
      @pre_action = block
    end
    
    def post(&block)
      @post_action = block
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