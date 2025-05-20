//
//  ArmInstruction+Serialization.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

extension Data {
    static func fromInstructions(_ instructions: [ArmInstruction]) -> Self {
        let bufferSize = instructions.count
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: bufferSize)
        for (idx, instruction) in instructions.enumerated() {
            buffer[idx] = instruction.rawValue
        }
        return Data(buffer: buffer)
    }
}
