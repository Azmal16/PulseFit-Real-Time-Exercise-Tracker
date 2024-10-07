import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel = WorkoutViewModel()

    var body: some View {
        VStack {
            // Show Squat Count
            Text("Squat Reps: \(viewModel.squatCount)")
                .font(.largeTitle)
                .padding()

            // Show Calculated Angle
            Text("Angle: \(viewModel.angle, specifier: "%.2f")")
                .font(.title)
                .padding()

            // This could be a representation of your camera feed (will be handled by the ViewController)
            CameraFeedViewControllerRepresentable() // Placeholder for your actual camera feed
        }
    }
}

struct CameraFeedViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No need to update anything here for the simple case
    }
}
