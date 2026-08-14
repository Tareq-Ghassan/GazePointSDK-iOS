Pod::Spec.new do |s|
  s.name             = 'GazePointSDK'
  s.version          = '2.2.0'
  s.summary          = 'GazePoint SDK for iOS — eye tracking and gaze point detection'
  s.description      = <<-DESC
    Native iOS GazePoint SDK using Vision face landmarks for gaze estimation.
  DESC
  s.homepage         = 'https://github.com/Tareq-Ghassan/GazePointSDK-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tareq Abu Saleh' => 'https://github.com/Tareq-Ghassan' }
  s.source           = {
    :git => 'https://github.com/Tareq-Ghassan/GazePointSDK-iOS.git',
    :tag => s.version.to_s
  }
  s.source_files     = 'Sources/GazePointSDK/**/*.swift'
  s.ios.deployment_target = '16.0'
  s.swift_version    = '6.0'
  s.frameworks       = 'Vision', 'UIKit', 'AVFoundation', 'CoreMedia'
end
