RCoLi
=====

Library for development of command line applications in Ruby.

== Installation

  $ gem install rcoli
	
== Example

		#!/usr/bin/env ruby

		require 'rcoli'

		application("mytool") do
		  author "Operations Team"
		  version "1.0.0"
		  description "Tool for management of infrastructure"
  
		  flag short: 'd', long: 'debug' do |f|
		    f.description "Turn on debugging"
		  end
			
		  switch short: 'c', long: 'config' do |s|
		    s.description "Path of file with configuration"
		  end
  
		  command :node do |c|
		    c.description "Commands for creating and managing nodes"
		    c.command :create do |sc|
		      sc.description "Creates node"
		      sc.action do |opts, args|
					 # your action here
		      end
		    end
				
		    c.command :remove do |sc|
		      sc.description "Remove node"
		      sc.action do |opts, args|
					 # your action here
		      end
		    end
				
		  end
		end	
	
	