platform = get_platform()
if platform == :mac
  require 'device_api/ios'
end

def get_ios_devices
  ENV["IOS_DEVICES"] = JSON.generate(DeviceAPI::IOS.devices.map.each_with_index { |line, index| { udid: line.serial, thread: index + 1 } })
end

def get_ios_details(udid)
  device = DeviceAPI::IOS.device(udid)
  model = device.model
  imei = device.imei
  details = device.instance_variable_get('@props')
  number = details["PhoneNumber"].delete('() ').tr('-', '')[1..-1]
  {
    "build" => details["BuildVersion"],
    "software" => details["BuildVersion"],
    "os_ver" => details["ProductVersion"],
    "model" => model,
    "number" => number,
    "imei" => imei
  }
rescue
  nil
end
