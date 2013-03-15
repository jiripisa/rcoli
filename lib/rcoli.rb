require 'rcoli/extensions'
require 'rcoli/model'
require 'rcoli/help'

module RCoLi
class Program
    
  setter :name
  setter :author
  setter :version
    
  include CommandContainer
  include Help
      
  def execute(args)
    result = ParsedArgs.new
    parse_args(args, result)
  end
    
end
end

@program = RCoLi::Program.new

def application(name, &block)
  @program.name name
  @program.instance_eval &block
end

at_exit {
  begin
    @program.execute(ARGV)
  rescue InvalidCommand => e
    puts e.message
  end
    
}
