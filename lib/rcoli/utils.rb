require 'logger'
require 'singleton'

module RCoLi
  
  class ApplicationContext
    
    include Singleton
    
    attr_accessor :debug
    
  end
  
  class Log
    
    include Singleton
    
    def initialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO
      @log.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end
    
    def logger
      @log
    end
    
  end
  
end

def log
  RCoLi::Log.instance.logger
end
