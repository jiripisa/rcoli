require 'logger'
require 'singleton'
require 'paint'

module RCoLi
  
  class ApplicationContext
    
    include Singleton
    
    attr_accessor :debug
    attr_accessor :modedev
    
  end
  
  class Log
    
    include Singleton
    
    def initialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO
      @log.formatter = proc do |severity, datetime, progname, msg|
        case severity
        when "DEBUG"
          color = 'gray27'
        else
          color = :white
        end
        
        if STDOUT.tty?
          Paint["#{msg}\n", color]
        else
          "#{msg}\n"
        end
        
      end
    end
    
    def logger
      @log
    end
    
  end
  
  class SystemExecutor
    
    include Singleton
    
    def initialize
    end
    
    def register(file)
      @source = file
      log.debug("Loading commands from file #{file}")
      @commands = YAML::load(File.open(file))
    end
    
    def execute(command, *args)
      cmnd = @commands[command.to_s]
      if cmnd
        cmnd.scan(/\$\{([^\s]+)\}/).each do |s|
          context = args[0]
          (s[0].split('.').each{|key| context = (context.is_a? Hash) ? context[key] : nil})
          cmnd = cmnd.sub("${#{s[0]}}", ((context.is_a? Array) ? context.join(',') : context.to_s)) if context
        end
        
        # ALTERNATIVE SOLUTION
        # cmnd.to_enum(:scan, /\$\{([^\s]+)\}/).map {[Regexp.last_match[0], Regexp.last_match[1].split('.')]}.each do |m|
        #   context = (context.nil? ? config : context)[m[1].delete_at(0)] until m[1].size == 0
        #   cmnd = cmnd.sub(m[0], context) if context.is_a? String
        # end
        
        
        log.debug("EXEC: #{cmnd}")
        system(cmnd) unless ApplicationContext.instance.modedev
      else
        raise ApplicationError, "The command #{command} isn't configured. Check the file #{@source}"
      end
    end
    
  end
  
end

def log
  RCoLi::Log.instance.logger
end

def sysexec(command, *args)
  RCoLi::SystemExecutor.instance.execute(command, args[0])
end

def load_commands(file)
  RCoLi::SystemExecutor.instance.register(file)
end
