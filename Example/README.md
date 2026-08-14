# GazePoint SDK — iOS Example

SwiftUI demo that lives in this repository and compiles against the local `GazePointSDK` package.

```
GazePointSDK-iOS/
├── Sources/GazePointSDK/   # library
└── Example/                # this app
```

## What it shows

- Live camera preview from the SDK (`GazePreviewView`)
- White outline on every detected face, aligned to the face
- Status **Multiple faces detected** when more than one face is in frame (gaze is not calculated in that case)
- **Flip camera** button (front / back)
- Gaze indicator, confidence, blink, and head pose from `GazeCamera`

Metrics-only apps can use `GazeCamera` with `previewEnabled = false` and never add `previewView`.

## Run

1. Open `Example/ios_example.xcodeproj` in Xcode
2. Select a **physical iPhone** (camera)
3. Run

See [TESTING.md](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint/blob/main/TESTING.md).
