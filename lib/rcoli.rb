require 'highline/import'
require 'rcoli/utils'
require 'rcoli/extensions'
require 'rcoli/help'
require 'rcoli/model'


@program = RCoLi::Program.new

def application(id, &block)
  @program.name id
  
  @program.switch long: 'debug' do |s|
    s.description "Turn on debugging"
  end
  
  @program.command(:help) do |c|
    c.description "Display help documentation"
    c.solitaire
    c.action do |global_opts, opts, args|
      @program.help args
    end
  end
  
  @program.instance_eval &block
  
end

at_exit {
  begin
    @program.execute(ARGV, self)
  rescue InvalidCommand => e
    say "#{@program.value_of_name}: #{e.message}. See '#{@program.value_of_name} help'"
  rescue ApplicationError => e
    say "#{e.message}"
  end
    
}
