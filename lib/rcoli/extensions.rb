def setter(name)
  define_method(name) do |value|
    ivar = "@#{name}"
    instance_variable_set(ivar, value)
  end
  
  define_method("value_of_#{name}") do
    ivar = "@#{name}"
    instance_variable_get(ivar).to_s
  end
  
end
