require 'rcoli/extensions'
require 'rcoli/model'
require 'rcoli/help'

@program = RCoLi::Program.new

def application(name, &block)
  @program.name name
  @program.instance_eval &block
end

at_exit {
  help if ARGV.empty?
  p @program
}
