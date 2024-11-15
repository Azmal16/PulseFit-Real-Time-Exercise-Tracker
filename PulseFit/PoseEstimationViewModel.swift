//
//  PoseEstimationViewModel.swift
//  PulseFit
//
//  Created by MMH on 15/11/24.
//


import CoreML
import Vision
import Combine

class PoseEstimationViewModel: ObservableObject {
    private var model: VNCoreMLModel
    private var request: VNCoreMLRequest?

    init() {
        // Load the YOLOv11 model from the .mlpackage file
        let mlModel = try! yolo11n_pose(configuration: .init()).model
        model = try! VNCoreMLModel(for: mlModel)
        
        // Set up the Vision request with the model
        request = VNCoreMLRequest(model: model) {[weak self] request, error in
            if let error = error {
                print("Pose estimation error: \(error)")
                return
            }
            self?.processPoseObservations(request.results)
        }
    }
    
    func performPoseEstimation(on pixelBuffer: CVPixelBuffer) {
        guard let request = request else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
            print("Running Pose Estimation Model")
        } catch {
            print("Error performing pose estimation: \(error)")
        }
    }

    private func processPoseObservations(_ observations: [Any]?) {
        guard let observations = observations as? [VNRecognizedPointsObservation] else { return }
        // Handle keypoints and update the UI accordingly
    }
}