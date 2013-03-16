require 'rcoli/extensions'
require 'rcoli/help'
require 'rcoli/model'


@program = RCoLi::Program.new

def application(id, &block)
  @program.name id
  @program.instance_eval &block
end

at_exit {
  begin
    @program.execute(ARGV)
  rescue InvalidCommand => e
    puts e.message
  end
    
}
