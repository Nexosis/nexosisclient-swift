Pod::Spec.new do |s|

  s.name = "NexosisApiClient"
  s.version = "0.1.0"
  s.summary = "Swift client for the Nexosis API."
  s.description = "The NexosisApiClient makes it easy to use use the Nexosis API from Swift."
  s.homepage = "http://nexosis.com"

  s.license = "Apache License, Version 2.0"

  s.authors = { "Guy Royse" => "guy.royse@nexosis.com" }
  s.social_media_url = "http://twitter.com/Nexosis"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/Nexosis/nexosisclient-swift.git", :tag => "#{s.version}" }
  s.source_files  = "Source/**/*.swift"

  s.dependency "Alamofire", "~> 4.4"
  s.dependency "PromiseKit", "~> 4.3.2"
  s.dependency "PromiseKit/Alamofire", "~> 4.3.2"
  s.dependency "PromiseKit", "~> 4.3.2"

end
