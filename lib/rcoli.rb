require 'rcoli/extensions'
require 'rcoli/model'
require 'rcoli/help'

include RCoLi::Program

at_exit {
  help if ARGV.empty?
  p @commands
}
