import SwiftUI
import Vision
import AVFoundation

class WorkoutViewModel: ObservableObject {
    @Published var squatCount: Int = 0
    @Published var angle: Double = 0.0

    // Process frame and calculate angle
    func processFrame(buffer: CMSampleBuffer) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
                if let observations = request.results as? [VNHumanBodyPoseObservation] {
                    self?.handleBodyPoseObservations(observations)
                }
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error performing pose detection: \(error)")
            }
        }
    }


    // Handle pose detection and calculate angles
    private func handleBodyPoseObservations(_ observations: [VNHumanBodyPoseObservation]) {
        guard let observation = observations.first else { return }

        do {
            let recognizedPoints = try observation.recognizedPoints(.all)
            if let rightHip = recognizedPoints[.rightHip],
               let rightKnee = recognizedPoints[.rightKnee],
               let rightAnkle = recognizedPoints[.rightAnkle] {

                // Calculate angle between the points (hypothetical method)
                let angle = calculateAngle(hip: rightHip, knee: rightKnee, ankle: rightAnkle)
                
                DispatchQueue.main.async {
                    self.angle = angle
                    if self.angleIsValidForSquatRep(angle: angle) {
                        self.squatCount += 1
                    }
                }
            }
        } catch {
            print("Error in pose observation: \(error)")
        }
    }

    // Hypothetical angle calculation between hip, knee, and ankle
    private func calculateAngle(hip: VNRecognizedPoint, knee: VNRecognizedPoint, ankle: VNRecognizedPoint) -> Double {
        // Calculate angle logic here (returning a dummy value for now)
        return 120.0
    }

    // Logic to determine if squat rep is valid based on angle
    private func angleIsValidForSquatRep(angle: Double) -> Bool {
        // Replace this with valid logic based on angle threshold for squats
        return angle > 160
    }
}
