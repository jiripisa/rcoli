module RCoLi
  
  module Properties
         
    def setter(name)
      define_method(name) do |value|
        ivar = "@#{name}"
        instance_variable_set(ivar, value)
      end
    end
    
  end
  
end
