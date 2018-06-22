#Copyright © 2016 Orasi Software, Inc., All rights reserved.

require 'parallel'
require 'json'
require 'fileutils'


require_relative 'FileSystemHelpers'
require_relative 'Android'
require_relative 'Appium'
require_relative 'iOS.rb'

platform = get_platform()
if platform == :windows
  require 'Win32API'
end

def shortname long_name
  max_path = 1024
  short_name = " " * max_path
  lfn_size = Win32API.new("kernel32", "GetShortPathName", ['P','P','L'],'L').call(long_name, short_name, max_path)
  return short_name[0..lfn_size-1]
end

input_array = ARGV
ip = ENV['IP'] || ` ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172.17.0.1'`
hub = '127.0.0.1'
hub_port = '4444'

hub_position = input_array.index((input_array & ['-h', '--hub']).first) || nil

if hub_position
  hub = input_array[hub_position + 1]
  hub_orig = hub
  if hub.count(':') == 2
    hub = hub_orig.rpartition(':').first
    hub_port = hub_orig.rpartition(':').last
  elsif hub.count(':') == 1 && !hub.include?('http')
    hub = hub_orig.split(':').first
    hub_port = hub_orig.split(':').last
  end

  if hub_port.count("a-zA-Z") > 0
    raise 'Your ports must include numbers only'
  end
end

if input_array.include? '--restart'
  restart_devices
else
  platform = get_platform()
  if platform == :linux
    nodeConfigDir = File.expand_path('~/AppiumConnect/')
  elsif platform == :mac
    nodeConfigDir = File.expand_path('~/AppiumConnect/')
  elsif platform == :windows
    nodeConfigDir = shortname(Dir.home() + '/AppiumConnect')
  end

  create_dir nodeConfigDir
  create_dir nodeConfigDir + '/node_configs'
  create_dir nodeConfigDir + '/output'

  launch_hub_and_nodes ip, hub, hub_port, nodeConfigDir
end

