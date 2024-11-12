import AVFoundation

class CameraManager: NSObject, ObservableObject {
    private var session: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    
    // Setup the camera session
    func setupSession() {
        session = AVCaptureSession()
        session?.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access the camera")
            return
        }
        
        if session?.canAddInput(input) ?? false {
            session?.addInput(input)
        }
        
        // Setup video output
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        guard let videoOutput = videoOutput else { return }
        
        if session?.canAddOutput(videoOutput) ?? false {
            session?.addOutput(videoOutput)
        }
    }
    
    // Start the camera session
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
        }
    }
    
    // Stop the camera session
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.session?.stopRunning()
        }
    }
    
    func getSession() -> AVCaptureSession? {
        return session
    }
}

// Video data output delegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Here you'll later handle frame processing for pose estimation
    }
}
