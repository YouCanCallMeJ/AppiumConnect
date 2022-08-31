Gem::Specification.new do |s|
  s.name        = 'appium_connect'
  s.version     = '1.1.23'
  s.date        = '2015-11-04'
  s.summary     = "Quickly Connect USB connected device to Selenium Grid"
  s.description = "Looks for USB Connected devices and registers them as Appium Nodes on Selenium Grid"
  s.authors     = ["Matt Watson"]
  s.email       = 'Watson.Mattc@gmail.com'
  s.files       = ["lib/AppiumConnect.rb", 'lib/FileSystemHelpers.rb', 'lib/Android.rb', 'lib/iOS.rb', 'lib/Appium.rb', 'lib/ip.rb']
  s.homepage    = 'https://github.com/Mattwhooo/AppiumConnect'
  s.license       = 'MIT'
  s.executables   = ["AppiumConnect"]
  s.add_development_dependency 'pry', '~> 0'
  s.add_runtime_dependency 'parallel', '~> 1.10.0'
  s.add_runtime_dependency 'device_api-ios', '~> 1.1', '>= 1.1.0'
end
