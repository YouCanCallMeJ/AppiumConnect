#Copyright © 2016 Orasi Software, Inc., All rights reserved.

require 'parallel'
require 'json'
require 'fileutils'


require_relative 'FileSystemHelpers'
require_relative 'Android'
require_relative 'Appium'
require_relative 'iOS.rb'
require_relative 'ip'

platform = get_platform()
if platform == :windows
  require 'Win32API'
end

def shortname long_name
  return '/c' + long_name[2..-1] if long_name[0..1] == 'C:'
  long_name
end

input_array = ARGV
ip = ENV['IP'] || Ip.host_ip
hub = '127.0.0.1'
hub_port = '4444'

hub_position = input_array.index((input_array & ['-h', '--hub']).first) || nil

foreground_values = ['-f', '--foreground']
run_foreground = (input_array & foreground_values).any? ? true : false

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

  launch_hub_and_nodes ip, hub, hub_port, run_foreground, nodeConfigDir
end
