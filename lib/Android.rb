def get_android_devices
  ENV["DEVICES"] = JSON.generate((`adb devices`).lines.select { |line| line.match(/\tdevice$/) }.map.each_with_index { |line, index| { udid: line.split("\t")[0], thread: index + 1 } })
end

def get_android_version(udid)
  command = "adb  -s #{udid} shell getprop ro.build.version.release"
  `#{command}`
end

def get_device_osv udid
  command = "adb  -s #{udid} shell getprop ro.build.version.sdk"
  `#{command}`
end

def get_device_model udid
  command = "adb  -s #{udid} shell getprop ro.product.model"
  `#{command}`
end

def get_device_build udid
  command = "adb  -s #{udid} shell getprop ro.build.display.id"
  `#{command}`
end

def get_device_brand udid
  command = "adb  -s #{udid} shell getprop ro.product.brand"
  `#{command}`
end

def restart_devices
  devices = JSON.parse(get_android_devices)

  devices.each do |device|
    `adb -s #{device['udid']} reboot`
  end
end

def get_device_phone_number(udid)
 result = `adb -s #{udid} shell service call iphonesubinfo 19`
 number = result.split[7].delete(" .+'") + result.split[13].delete(" .+)'")
 number[1..-1]
end
