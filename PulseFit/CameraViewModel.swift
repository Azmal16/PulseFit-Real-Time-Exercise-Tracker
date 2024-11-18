import Combine
import AVFoundation

class CameraViewModel: ObservableObject {
    //var poseEstimationVM: PoseEstimationViewModel
    @Published var cameraManager: CameraManager
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
//    @Published var leftShoulderPoint: CGPoint?
//    @Published var rightShoulderPoint: CGPoint?
    
    init(poseEstimationVM: PoseEstimationViewModel,
         cameraManager: CameraManager) {
        //self.poseEstimationVM = poseEstimationVM
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
