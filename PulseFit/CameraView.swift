import SwiftUI
import AVFoundation

struct CameraView: View {
    //@ObservedObject var poseEstimationViewModel: PoseEstimationViewModel
    @StateObject var viewModel = CameraViewModel(poseEstimationVM: PoseEstimationViewModel(imageWidth: 640, imageHeight: 384), cameraManager: CameraManager(poseEstimationViewModel: PoseEstimationViewModel(imageWidth: 640, imageHeight: 384)))
    @State var leftShoulder: CGPoint?
    @State var rightShoulder: CGPoint?
    
    var body: some View {
        ZStack {
            CameraPreview(previewLayer: viewModel.previewLayer)
                .edgesIgnoringSafeArea(.all)
            
            if let leftShoulder = leftShoulder {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .position(x: leftShoulder.x,
                              y: leftShoulder.y)
            }
            
            if let rightShoulder = rightShoulder {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                    .position(x: rightShoulder.x,
                              y: rightShoulder.y)
            }
        }
       // .id(UUID())
        .onAppear {
            viewModel.cameraManager.poseEstimationViewModel.delegate = self
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

extension CameraView: PoseEstimationView {
    func points(left: CGPoint, right: CGPoint) {
        print("left - \(left.y)")
        leftShoulder = left
        rightShoulder = right
    }
}
