//
//  Utilitis.swift
//  PulseFit
//
//  Created by MMH on 29/11/24.
//

import CoreML
import Vision

extension MLMultiArray {
    /// Reshapes a 1D MLMultiArray to a 2D Swift array of Floats with the given shape.
    /// - Parameter shape: An array of two integers [rows, columns] specifying the target dimensions.
    /// - Returns: A 2D array of Floats reshaped according to the given dimensions.
    func reshape(to shape: [Int]) -> [[Float]] {
        // Ensure the provided shape has exactly two dimensions
        guard shape.count == 2 else {
            fatalError("Invalid shape. Expected a 2D shape [rows, columns].")
        }
        
        // Ensure the total size of the new shape matches the MLMultiArray size
        guard self.count == shape[0] * shape[1] else {
            fatalError("Shape mismatch: MLMultiArray size does not match target shape.")
        }
        
        // Access the MLMultiArray's data pointer as Float
        let dataPointer = self.dataPointer.bindMemory(to: Float.self, capacity: self.count)

        // Create the reshaped 2D array
        var reshapedArray: [[Float]] = []
        var offset = 0
        for _ in 0..<shape[0] { // Iterate through rows
            let row = Array(UnsafeBufferPointer(start: dataPointer + offset, count: shape[1]))
            reshapedArray.append(row)
            offset += shape[1] // Move to the next row
        }
        return reshapedArray
    }
}


