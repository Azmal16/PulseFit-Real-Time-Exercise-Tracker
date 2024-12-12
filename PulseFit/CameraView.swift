import SwiftUI
import AVFoundation

struct CameraView: View {

    @StateObject var cameraManager = CameraManager()
    @State var leftShoulder: CGPoint?
    @State var rightShoulder: CGPoint?
    
    var body: some View {
        ZStack {
            CameraPreview(previewLayer: cameraManager.previewLayer)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            cameraManager.startSession()
        }
        .onDisappear {
            cameraManager.stopSession()
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
