# GazePoint SDK — iOS Example

SwiftUI demo that lives in this repository and links the local `GazePointSDK` Swift package.

```
GazePointSDK-iOS/
├── Package.swift
├── Sources/GazePointSDK/
└── Example/                 # this app
    ├── ios_example/
    └── ios_example.xcodeproj
```

## Open in Xcode

1. Open `Example/ios_example.xcodeproj`
2. Confirm the local `GazePointSDK` package resolves (path `..`)
3. Run on a **physical iPhone** (camera required)

## What it shows

- Live front-camera preview
- Gaze indicator from `GazeTracker`
- Confidence / blink / head-pose status

## Requirements

- iOS 16.0+
- Xcode with Swift 6
- Camera permission (`NSCameraUsageDescription`)

Releasing the iOS SDK does **not** require changes in Flutter or other platform repos. Tag this repository and consume it via Swift Package Manager.
