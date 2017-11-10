source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def all_targets
  pod 'Alamofire', '~> 4.4'
  pod 'PromiseKit', '~> 4.3.2'
  pod 'PromiseKit/Alamofire', '~> 4.3.2'
end

def test_dependencies
  inherit! :search_paths
  pod 'Nimble', '~> 7.0.1'
  pod 'Quick', '~> 1.1.0'
  pod 'Moxie', '~> 0.2.1'
end

target 'NexosisApiClientiOS' do
  platform :ios, '8.0'
  all_targets

  target 'NexosisApiClientiOSTests' do
    test_dependencies
  end

end

target 'NexosisApiClientMacOS' do
  platform :osx, '10.11'
  all_targets

  target 'NexosisApiClientMacOSTests' do
    test_dependencies
  end

end

target 'NexosisApiClientTvOS' do
  platform :tvos, '9.0'
  all_targets

  target 'NexosisApiClientTvOSTests' do
    test_dependencies
  end

end

target 'NexosisApiClientWatchOS' do
  platform :watchos, '2.0'
  all_targets
end
