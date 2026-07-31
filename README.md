# GazePoint SDK for iOS

Advanced eye tracking and gaze point detection SDK for iOS applications using Apple's Vision framework.

**Repository:** [Tareq-Ghassan/GazePointSDK-iOS](https://github.com/Tareq-Ghassan/GazePointSDK-iOS)  
**Umbrella monorepo:** [FaceDetection-GazePoint](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint)

## Features

- ✅ **Real-time Gaze Tracking** — Track the user's gaze point on screen in real time
- ✅ **Head Pose Compensation** — Accurate tracking regardless of head position
- ✅ **Blink Detection** — Detect blinks using Eye Aspect Ratio (EAR)
- ✅ **Kalman Filtering** — Smooth gaze point tracking
- ✅ **Adaptive Smoothing** — Velocity-based smoothing for natural movement
- ✅ **Calibration Support** — Multi-point calibration for improved accuracy
- ✅ **Performance Monitoring** — Built-in FPS and processing time tracking
- ✅ **Thread-Safe** — Concurrent processing with GCD

## Requirements

- iOS 16.0+
- Xcode with Swift 6.3 toolchain (tested with Xcode 26.6)
- Device with a front-facing camera
- Camera access permission (`NSCameraUsageDescription`)

## Installation

### Swift Package Manager (recommended)

In Xcode: **File → Add Package Dependencies…** and enter:

```text
https://github.com/Tareq-Ghassan/GazePointSDK-iOS
```

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Tareq-Ghassan/GazePointSDK-iOS", from: "2.0.0")
]
```

### CocoaPods

```ruby
pod 'GazePointSDK', :git => 'https://github.com/Tareq-Ghassan/GazePointSDK-iOS.git', :tag => '2.0.0'
```

Local path (as used by `ios_example` / `flutter_example`):

```ruby
pod 'GazePointSDK', :path => '../ios'
```

## Quick Start

### 1. Request Camera Permission

Add to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for eye tracking</string>
```

### 2. Basic Usage

```swift
import GazePointSDK
import AVFoundation

class GazeTrackingViewController: UIViewController {

    let gazeTracker = GazeTracker()
    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }

        captureSession?.addInput(input)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(videoOutput)

        captureSession?.startRunning()
    }
}

extension GazeTrackingViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        if let result = gazeTracker.calculateGazePoint(from: pixelBuffer, orientation: .up) {
            DispatchQueue.main.async {
                print("Gaze Point: \(result.gazePoint)")
                print("Confidence: \(Int(result.confidence * 100))%")
                print("Blinking: \(result.isBlinking)")
                print("Head Pose - Pitch: \(result.headPose.pitch)°, Yaw: \(result.headPose.yaw)°")
                self.updateGazeIndicator(at: result.gazePoint)
            }
        }
    }

    func updateGazeIndicator(at point: CGPoint) {
        // Update your UI to show where the user is looking
    }
}
```

### 3. With Calibration

```swift
let calibrationPoints = [
    (expected: CGPoint(x: 100, y: 100), actual: CGPoint(x: 95, y: 102)),
    (expected: CGPoint(x: 375, y: 100), actual: CGPoint(x: 378, y: 98)),
    (expected: CGPoint(x: 100, y: 750), actual: CGPoint(x: 102, y: 755)),
    (expected: CGPoint(x: 375, y: 750), actual: CGPoint(x: 373, y: 748)),
    (expected: CGPoint(x: 187.5, y: 425), actual: CGPoint(x: 190, y: 422))
]

gazeTracker.calibrate(calibrationPoints: calibrationPoints)
```

### 4. Performance Monitoring

```swift
let metrics = gazeTracker.getPerformanceMetrics()
print("FPS: \(metrics.fps)")
print("Avg Processing Time: \(metrics.avgProcessingTimeMs) ms")
print("Dropped Frames: \(metrics.droppedFrames)")
```

## Sample app

Open [`ios_example`](../ios_example) in Xcode. It consumes this package via a local Swift Package dependency.

## API Reference

### GazeTracker

- `calculateGazePoint(from: CVPixelBuffer, orientation: CGImagePropertyOrientation) -> GazeResult?`
- `calculateGazePoint(from: UIImage) -> GazeResult?`
- `calibrate(calibrationPoints: [(expected: CGPoint, actual: CGPoint)])`
- `resetCalibration()`
- `getPerformanceMetrics() -> PerformanceMetrics`

### GazeResult

```swift
public struct GazeResult {
    public let gazePoint: CGPoint
    public let confidence: Float
    public let isBlinking: Bool
    public let headPose: HeadPose
    public let timestamp: TimeInterval
}
```

## License

MIT License — see the [LICENSE](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint/blob/main/LICENSE) file.

## Support

- Issues: [GazePointSDK-iOS](https://github.com/Tareq-Ghassan/GazePointSDK-iOS/issues)
- Umbrella: [FaceDetection-GazePoint](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint/issues)

## Version History

### 2.0.0 (2026-07-29)
- Initial release with Vision framework
- Kalman filtering and adaptive smoothing
- Head pose compensation
- Blink detection
- Performance monitoring
- Calibration support
