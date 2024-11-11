import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(previewLayer: viewModel.previewLayer)
                .edgesIgnoringSafeArea(.all)
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
