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
  number = details["PhoneNumber"]
  number = number.nil? ? nil : number.delete('() ').tr('-', '')[1..-1]
  {
    "build" => details["BuildVersion"] || not_found(:build),
    "software" => details["BuildVersion"] || not_found(:software),
    "os_ver" => details["ProductVersion"] || not_found(:os_ver),
    "model" => model || not_found(:model),
    "number" => number || not_found(:number),
    "imei" => imei || not_found(:imei)
  }
end

def not_found(type)
  "no #{type.to_s} found"
end
