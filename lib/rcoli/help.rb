require 'erb'

module RCoLi
  
  module Help
    
    def help
      puts template 'help'
    end

    def template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', "#{name}.erb")), nil, '-').result binding
    end

  end

end