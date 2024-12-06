//
//  PoseEstimationDecoder.swift
//  PulseFit
//
//  Created by MMH on 5/12/24.
//

import CoreML

class PoseEstimationDecoder {
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let numKeypoints = 17
    private let confidenceThreshold: Float = 0.5
    
    init(imageWidth: CGFloat, imageHeight: CGFloat) {
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    func decodePose(from output: MLMultiArray) -> [String: CGPoint] {
        let shape = [56, 5040] // Output shape from your model
        let reshapedOutput = output.reshape(to: shape)
        
        let keypointNames = [
            "nose", "leftEye", "rightEye", "leftEar", "rightEar",
            "leftShoulder", "rightShoulder", "leftElbow", "rightElbow",
            "leftWrist", "rightWrist", "leftHip", "rightHip",
            "leftKnee", "rightKnee", "leftAnkle", "rightAnkle"
        ]
        
        var keypoints: [String: CGPoint] = [:]
        
        for gridIdx in 0..<5040 {
            for kpIdx in 0..<numKeypoints {
                let baseIdx = kpIdx * 3
                let xNorm = reshapedOutput[baseIdx][gridIdx]
                let yNorm = reshapedOutput[baseIdx + 1][gridIdx]
                let confidence = reshapedOutput[baseIdx + 2][gridIdx]
                
                if confidence > confidenceThreshold {
                    let x = CGFloat(xNorm) * imageWidth
                    let y = CGFloat(yNorm) * imageHeight
                    keypoints[keypointNames[kpIdx]] = CGPoint(x: x, y: y)
                }
            }
        }
        
        return keypoints
    }
}
