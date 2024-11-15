import Combine
import AVFoundation

class CameraViewModel: ObservableObject {
    var cameraManager: CameraManager
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(cameraManager: CameraManager = CameraManager()) {
        self.cameraManager = cameraManager
        setupCamera()
    }

    private func setupCamera() {
        cameraManager.setupSession()
        if let session = cameraManager.getSession() {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
        }
    }

    func startSession() {
        cameraManager.startSession()
    }

    func stopSession() {
        cameraManager.stopSession()
    }
}
