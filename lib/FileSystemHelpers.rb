
def get_platform()
  if Gem::Platform.local.os == 'darwin'
    return :mac
  elsif Gem::Platform.local.os == 'linux'
    return :linux
  else
    return :windows
  end
end

def generate_node_config(nodeDir, file_name, udid, appium_port, ip, hubIp, hubPort, platform, browser, os_ver, build, model, brand, number)
  f = File.new(nodeDir + "/node_configs/#{file_name}", "w")

  f.write( JSON.generate({ capabilities: [
                            { udid: udid,
                              browserName: set_browser_name(brand, model),
                              maxInstances: 1,
                              platform: platform,
                              deviceName: set_browser_name(brand, model),
                              applicationName: model,
                              platformName: platform,
                              version: os_ver
                            },
                            { browserName: browser,
                              maxInstances: 1,
                              deviceName: set_browser_name(brand, model),
                              seleniumProtocol: 'WebDriver',
                              udid: udid,
                              platform: platform,
                              applicationName: model
                            }],
  configuration: { cleanUpCycle: 2000,
                   timeout: 299000,
                   registerCycle: 5000,
                   proxy: "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
                   custom: { "phoneNumber": number, "buildNumber": build, "deviceType": "mobile" },
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

def set_browser_name(brand, model)
  manu = brand.capitalize
  name = manu + "_" + model
  name.gsub(" ", "_")
end
