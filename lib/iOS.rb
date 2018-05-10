platform = get_platform()
if platform == :mac
  require 'device_api/ios'
end

def get_ios_devices
  ENV["IOS_DEVICES"] = JSON.generate((`system_profiler SPUSBDataType | sed -n -E -e '/(iPhone|iPad)/,/Serial/s/ *Serial Number: *(.+)/\\1/p'`).lines.map.each_with_index { |line, index| { udid: line.gsub(/\n/,""), thread: index + 1 } })
end

def get_ios_details(udid)
  device = DeviceAPI::IOS.device(udid)
  model = device.model
  details = device.instance_variable_get('@props')
  number = details["PhoneNumber"].delete('() ').tr('-', '')[1..-1]
  { "build" => details["BuildVersion"], "os_ver" => details["ProductVersion"], "model" => model, "number" => number }
end
