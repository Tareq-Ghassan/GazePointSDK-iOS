Pod::Spec.new do |s|
  s.name             = 'GazePointSDK'
  s.version          = '2.0.0'
  s.summary          = 'GazePoint SDK for iOS — eye tracking and gaze point detection'
  s.description      = <<-DESC
    Native iOS GazePoint SDK using Vision face landmarks for gaze estimation.
  DESC
  s.homepage         = 'https://github.com/Tareq-Ghassan/FaceDetection-GazePoint'
  s.license          = { :type => 'MIT' }
  s.author           = { 'GazePoint' => 'support@gazepoint.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Sources/GazePointSDK/**/*.swift'
  s.ios.deployment_target = '16.0'
  s.swift_version    = '5.0'
  s.frameworks       = 'Vision', 'UIKit', 'AVFoundation', 'CoreMedia'
end
