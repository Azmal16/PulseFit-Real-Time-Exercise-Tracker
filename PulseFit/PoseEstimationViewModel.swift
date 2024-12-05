//
//  PoseEstimationViewModel.swift
//  PulseFit
//
//  Created by MMH on 15/11/24.
//


import CoreML
import Vision
import Combine

protocol PoseEstimationView {
    func points(left: CGPoint, right: CGPoint)
}

class PoseEstimationViewModel: ObservableObject {
    
    private var model: VNCoreMLModel
    private var request: VNCoreMLRequest?
    
    @Published var cameraViewModel: CameraViewModel?
    @Published var leftShoulderPoint: CGPoint?
    @Published var rightShoulderPoint: CGPoint?
    
    var delegate: PoseEstimationView?
    
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
            print("Request Results: \(String(describing: request.results))")
            self?.processPoseObservations(request.results)
        }
    }
    
    func performPoseEstimation(on pixelBuffer: CVPixelBuffer) {
         guard let request = request else { return }
         
         let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
         do {
             try handler.perform([request])
         } catch {
             print("Error performing pose estimation: \(error)")
         }
     }


    private func processPoseObservations(_ observations: [Any]?) {
         guard let observations = observations as? [VNCoreMLFeatureValueObservation],
               let multiArray = observations.first?.featureValue.multiArrayValue else { return }
         
         let keypoints = extractKeypoints(from: multiArray)
         
         // Update left and right shoulder points
         DispatchQueue.main.async { [weak self] in
             self?.leftShoulderPoint = keypoints.leftShoulder
             self?.rightShoulderPoint = keypoints.rightShoulder
             
             if let lponit = keypoints.leftShoulder, let rpoint = keypoints.rightShoulder {
                 
                 self?.delegate?.points(left: lponit, right: rpoint)
             }
         }
     }
     
     private func extractKeypoints(from multiArray: MLMultiArray) -> (leftShoulder: CGPoint?, rightShoulder: CGPoint?) {
         // Indices for shoulders (example: use actual indices for YOLO model)
         let leftShoulderIndex = 5
         let rightShoulderIndex = 6
         
         // Extract and normalize keypoints
         func getNormalizedPoint(at index: Int) -> CGPoint? {
             let xIndex = index * 3
             let yIndex = xIndex + 1
             let confidenceIndex = yIndex + 1
             
             let x = multiArray[xIndex].floatValue
             let y = multiArray[yIndex].floatValue
             let confidence = multiArray[confidenceIndex].floatValue
             
             return confidence > 0.5 ? CGPoint(x: CGFloat(x), y: CGFloat(y)) : nil
         }
         
         let leftShoulder = getNormalizedPoint(at: leftShoulderIndex)
         let rightShoulder = getNormalizedPoint(at: rightShoulderIndex)
         
         return (leftShoulder, rightShoulder)
     }
}
