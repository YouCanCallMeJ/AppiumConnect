def get_android_devices
  ENV["DEVICES"] = JSON.generate((`adb devices`).lines.select { |line| line.match(/\tdevice$/) }.map.each_with_index { |line, index| { udid: line.split("\t")[0], thread: index + 1 } })
end

def get_android_version(udid)
  command = "adb  -s #{udid} shell getprop ro.build.version.release"
  `#{command}`.strip
end

def get_device_osv udid
  command = "adb  -s #{udid} shell getprop ro.build.version.sdk"
  `#{command}`.strip
end

def get_device_model udid
  command = "adb  -s #{udid} shell getprop ro.product.model"
  `#{command}`.strip
end

def get_device_build udid
  command = "adb -s #{udid} shell getprop ro.build.display.id"
  `#{command}`.strip
end

def get_device_software udid
  command = "adb -s #{udid} shell getprop ro.build.version.incremental"
  `#{command}`.strip
end

def get_device_brand udid
  command = "adb  -s #{udid} shell getprop ro.product.brand"
  `#{command}`.strip
end

def marketing_name udid
  command = "adb  -s #{udid} shell dumpsys bluetooth_manager | \grep 'name:' | cut -c9-"
  name = `#{command}`.strip
  "#{get_device_brand(udid)} #{name}"
end

def get_device_chipset udid
  chipname_command = "adb -s #{udid} shell getprop ro.chipname"
  hardware_command = "adb -s #{udid} shell getprop ro.hardware.chipname"
  chipname = `#{chipname_command}`.strip
  hardware = `#{hardware_command}`.strip
  val = chipname.empty? ? hardware : chipname
  val.empty? ? 'not_found' : val
end

def get_device_imei udid
  command = "adb -s #{udid} shell service call iphonesubinfo 1"
  `#{command}`.lines.map{ |x| x.split("'")[1] }.join.gsub(/\.| /, '')
end

def restart_devices
  devices = JSON.parse(get_android_devices)

  devices.each do |device|
    `adb -s #{device['udid']} reboot`
  end
end

def get_device_phone_number(udid)
  cmds = (10..20)
  cmds.each do |cmd|
    val = `adb -s #{udid} shell service call iphonesubinfo #{cmd}`
          .split("\n").join.split("'")
          .collect{|x| x if x.include?('.')}.compact
          .join.delete('.+')[1..-1]&.strip
    return val if !val.nil? && val.chars.size == 10
    next
  end
  'not_found'
end
