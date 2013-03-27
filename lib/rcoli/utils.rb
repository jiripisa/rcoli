require 'logger'
require 'singleton'

module RCoLi
  
  class ApplicationContext
    
    include Singleton
    
    attr_accessor :debug
    
  end
  
end

@log = Logger.new(STDOUT)
@log.level = Logger::INFO
@log.formatter = proc do |severity, datetime, progname, msg|
  "#{msg}\n"
end

def log
  @log
end

