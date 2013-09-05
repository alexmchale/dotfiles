begin
  require 'rubygems'
rescue LoadError
end

begin
  require 'andand'
rescue LoadError
end

begin
  require 'ap'
rescue LoadError
end

begin
  require "wirble"
  Wirble.init
  Wirble.colorize
rescue LoadError
end

require "pp"

# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

module Kernel
  def trace_call(&block)
    set_trace_func proc { |event, file, line, id, binding, classname|
      printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
    }

    block.call
  ensure
    set_trace_func nil
  end

  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end
