def get_platform()
  if Gem::Platform.local.os == 'darwin'
    return :mac
  elsif Gem::Platform.local.os == 'linux'
    return :linux
  else
    return :windows
  end
end

def generate_node_config(nodeDir, file_name, udid, appium_port, ip, hubIp, hubPort, platform, browser, os_ver, build, software, model, name, brand, number, chipset, imei)
  f = File.new(nodeDir + "/node_configs/#{file_name}", "w")

  f.write( JSON.generate({ capabilities: [
                            { udid: udid,
                              browserName: udid,
                              maxInstances: 1,
                              platform: platform,
                              deviceName: set_device_name(brand, model),
                              applicationName: udid,
                              platformName: platform,
                              version: os_ver
                            },
                            { browserName: udid,
                              maxInstances: 1,
                              deviceName: set_device_name(brand, model),
                              seleniumProtocol: 'WebDriver',
                              udid: udid,
                              platform: platform,
                              applicationName: model
                            }],
  configuration: { cleanUpCycle: 2000,
                   timeout: 299000,
                   registerCycle: 5000,
                   proxy: "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
                   custom: {
                     "phoneNumber": number,
                     "buildNumber": build,
                     "softwareNumber": software,
                     "deviceType": get_device_type(udid, platform),
                     "manufacturer": brand,
                     "model": model,
                     "chipset": chipset,
                     "imei": imei,
                     "marketingName": name
                   },
                   url: "http://#{ip}:#{appium_port}/wd/hub",
                   host: ip,
                   port: appium_port,
                   maxSession: 1,
                   register: true,
                   hubPort: hubPort,
                   hubHost: hubIp } } ) )
  f.close
end


def create_dir(name)
  FileUtils::mkdir_p name
end

def set_browser_name(brand, model, udid)
  name = set_device_name(brand, model)
  name + "_" + udid
end

def set_device_name(brand, model)
  manu = brand.capitalize
  name = manu.strip + "_" + model.strip
  name.gsub(" ", "_")
end

def get_device_type(udid, platform)
  platform == "android" ? get_type_android(udid) : 'mobile'
end

def get_type_android(udid)
  output = `adb -s #{udid} shell getprop ro.build.characteristics`
  if output.include?('tv')
    'tv'
  elsif output.include?('tablet')
    'tablet'
  elsif output.include?('mbx')
    'mbox'
  else
    'mobile'
  end
end
