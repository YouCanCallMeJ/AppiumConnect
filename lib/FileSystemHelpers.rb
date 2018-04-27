
def get_platform()
  if Gem::Platform.local.os == 'darwin'
    return :mac
  elsif Gem::Platform.local.os == 'linux'
    return :linux
  else
    return :windows
  end
end

def generate_node_config(nodeDir, file_name, udid, appium_port, ip, hubIp, platform, browser, os_ver, build, model, brand)
  f = File.new(nodeDir + "/node_configs/#{file_name}", "w")

  f.write( JSON.generate({ capabilities: [
                            { udid: udid,
                              browserName: set_browser_name(brand, model),
                              maxInstances: 1,
                              platform: platform,
                              deviceName: model,
                              applicationName: model,
                              platformName: platform,
                              version: os_ver
                            },
  ],

  configuration: { cleanUpCycle: 2000,
                   timeout: 299000,
                   registerCycle: 5000,
                   proxy: "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
                   url: "http://#{ip}:#{appium_port}/wd/hub",
                   host: ip,
                   port: appium_port,
                   maxSession: 1,
                   register: true,
                   hubPort: 4444,
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
