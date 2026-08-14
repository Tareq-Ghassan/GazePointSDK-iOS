import AVFoundation
import GazePointSDK
import SwiftUI
import UIKit

@MainActor
@Observable
final class GazeDemoModel {
    var permissionDenied = false
    var statusText = "Starting camera…"
    var gazePoint: CGPoint?
    var confidence: Float = 0
    var isBlinking = false
    var pitch: Float = 0
    var yaw: Float = 0
    var roll: Float = 0
    var faceDetected = false

    let camera = GazeCamera()

    func start() {
        camera.options = GazeCameraOptions(previewEnabled: true, showFaceBoxes: true)
        camera.onFrame = { [weak self] frame in
            Task { @MainActor in
                self?.apply(frame)
            }
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            camera.start()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    if granted {
                        self.camera.start()
                    } else {
                        self.permissionDenied = true
                        self.statusText = "Camera permission denied"
                    }
                }
            }
        default:
            permissionDenied = true
            statusText = "Camera permission denied. Enable it in Settings."
        }
    }

    func stop() {
        camera.stop()
    }

    private func apply(_ frame: GazeFrame) {
        statusText = frame.statusText
        faceDetected = frame.faceDetected
        if let gaze = frame.gaze {
            gazePoint = gaze.gazePoint
            confidence = gaze.confidence
            isBlinking = gaze.isBlinking
            pitch = gaze.headPose.pitch
            yaw = gaze.headPose.yaw
            roll = gaze.headPose.roll
        } else {
            gazePoint = nil
        }
    }
}

struct SDKPreviewView: UIViewRepresentable {
    let preview: GazePreviewView

    func makeUIView(context: Context) -> GazePreviewView {
        preview
    }

    func updateUIView(_ uiView: GazePreviewView, context: Context) {}
}
