import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var viewModel = WorkoutViewModel()
    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC loaded")
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .medium

        // Ensure capture session is created only once
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession?.canAddInput(input) ?? false {
                captureSession?.addInput(input)
            }
        } catch {
            print("Error setting device input: \(error)")
            return
        }

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA] as [String: Any]

        // Use a serial queue to process the frames
        let videoQueue = DispatchQueue(label: "videoQueue")
        output.setSampleBufferDelegate(self, queue: videoQueue)

        if captureSession?.canAddOutput(output) ?? false {
            captureSession?.addOutput(output)
        }

        // Start camera in the background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }

    // Sample buffer delegate method for capturing frames
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Process frame in ViewModel
        viewModel.processFrame(buffer: sampleBuffer)
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Frame captured")  // Simple log to check if frames are coming through
//    }

    // Ensure camera session is stopped on view disappearance
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
        }
    }
}
