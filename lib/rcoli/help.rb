require 'erb'

module RCoLi
  
  module Help
    
    def help(*args)
      if args[0].empty?
        puts template('help', nil)
      else
        command = self
        args[0].each do |arg| 
          command = command.find_command(arg)
          raise InvalidCommand, "'#{arg}' is not a valid #{@name} command" unless command
        end
        puts template('help_command', command)
      end
    end

    def template(name, command)
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', "#{name}.erb")), nil, '-').result binding
    end

  end

end