# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/jwitcig/PodSpecs.git'

target 'iMessagePack' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iMessagePack

  pod 'JWSwiftTools'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

  target 'iMessagePackTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
