import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(previewLayer: viewModel.previewLayer)
                .edgesIgnoringSafeArea(.all)
            
            if let leftShoulder = viewModel.cameraManager.poseEstimationViewModel.leftShoulderPoint {
                      Circle()
                          .fill(Color.red)
                          .frame(width: 10, height: 10)
                          .position(x: leftShoulder.x * UIScreen.main.bounds.width,
                                    y: leftShoulder.y * UIScreen.main.bounds.height)
                  }
                  
                  if let rightShoulder = viewModel.cameraManager.poseEstimationViewModel.rightShoulderPoint {
                      Circle()
                          .fill(Color.blue)
                          .frame(width: 10, height: 10)
                          .position(x: rightShoulder.x * UIScreen.main.bounds.width,
                                    y: rightShoulder.y * UIScreen.main.bounds.height)
                  }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Nothing to update yet
    }
}
