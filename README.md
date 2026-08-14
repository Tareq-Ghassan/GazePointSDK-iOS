# GazePoint SDK for iOS

Advanced eye tracking and gaze point detection SDK for iOS applications using Apple's Vision framework.

**Repository:** [Tareq-Ghassan/GazePointSDK-iOS](https://github.com/Tareq-Ghassan/GazePointSDK-iOS)  
**Umbrella monorepo:** [FaceDetection-GazePoint](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint)

## Features

- ✅ **Live camera preview** — Opt-in `GazePreviewView` (disable for metrics-only apps)
- ✅ **Face bounding boxes** — White outline on every detected face (aligned to the preview)
- ✅ **Multi-face status** — `GazeFrame.statusText` is `"Multiple faces detected"` when more than one face is in frame; `frame.gaze` is `nil` until only one face remains
- ✅ **Real-time Gaze Tracking** — Track the user's gaze point on screen in real time (single face only)
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
    .package(url: "https://github.com/Tareq-Ghassan/GazePointSDK-iOS", from: "2.2.0")
]
```

### CocoaPods

```ruby
pod 'GazePointSDK', :git => 'https://github.com/Tareq-Ghassan/GazePointSDK-iOS.git', :tag => '2.2.0'
```

Local path (as used by `Example/`):

```ruby
pod 'GazePointSDK', :path => '.'
```

## Quick Start

### 1. Request Camera Permission

Add to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for eye tracking</string>
```

### 2. Camera + preview (recommended)

```swift
import GazePointSDK
import UIKit

let camera = GazeCamera()
camera.options = GazeCameraOptions(previewEnabled: true, showFaceBoxes: true)
camera.onFrame = { frame in
    // frame.statusText — "No face detected" | "Multiple faces detected" | "Blink detected" | "Tracking"
    // frame.gaze is nil unless exactly one face is in frame
    // White boxes are drawn on camera.previewView
}
view.addSubview(camera.previewView)
camera.start()

// Metrics only: GazeCameraOptions(previewEnabled: false) and skip adding previewView
```

### 3. Gaze math only (you already have a camera frame)

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

### 4. With Calibration

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

### 5. Performance Monitoring

```swift
let metrics = gazeTracker.getPerformanceMetrics()
print("FPS: \(metrics.fps)")
print("Avg Processing Time: \(metrics.avgProcessingTimeMs) ms")
print("Dropped Frames: \(metrics.droppedFrames)")
```

## Sample app

Open [`Example`](Example/) in Xcode (`Example/ios_example.xcodeproj`). It consumes this package via a local Swift Package dependency. Run on a **physical iPhone** (camera). Pass: preview, white face boxes on the faces, **Multiple faces detected** with two people in frame and **no gaze point**, moving gaze indicator with one face, confidence > 0, blink. See [TESTING.md](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint/blob/main/TESTING.md).

## API Reference

### GazeCamera

- `previewView: GazePreviewView` — live camera + white face boxes
- `options: GazeCameraOptions` — `previewEnabled`, `showFaceBoxes`
- `onFrame: ((GazeFrame) -> Void)?` — gaze (nil unless `faceCount == 1`), `faceCount`, `statusText`
- `start()` / `stop()` / `switchCamera()`

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

### 2.2.0 (2026-08-13)
- `GazeCamera` + `GazePreviewView` owned by the SDK
- Opt-in live preview (`previewEnabled`) and white boxes on every face (`showFaceBoxes`)
- `GazeFrame.statusText`: `"No face detected"` | `"Multiple faces detected"` | `"Blink detected"` | `"Tracking"`
- Face boxes map through preview aspect-fill and sit on the face
- Gaze uses pupil position + head pose (degrees); `gaze` is nil when more than one face is in frame

### 2.1.0 (2026-08-05)
- Version bump aligned with multi-platform release

### 2.0.0 (2026-07-29)
- Initial release with Vision framework
- Kalman filtering and adaptive smoothing
- Head pose compensation
- Blink detection
- Performance monitoring
- Calibration support
