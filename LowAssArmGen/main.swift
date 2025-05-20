//
//  main.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/13/25.
//

import Foundation

// This is an experiment in generating AND THEN INVOKING some ARM assembly code that we author in Swift.

let instructions: [ArmInstruction] = [
    .mov(dest: .w(0), imm: 42),                 // w0 = 42
    .mov(dest: .w(1), imm: 7),                  // w1 = 7
    .sub(dest: .w(0), op1: .w(0), op2: .w(1)),  // w0 -= 7 (=35)
    .mov(dest: .w(2), imm: 3),                  // w2 = 3
    .mul(dest: .w(0), op1: .w(0), op2: .w(2)),  // w0 *= w2 (105)
    .mov(dest: .w(3), imm: 5),                  // w3 = 5
    .div(dest: .w(0), op1: .w(0), op2: .w(3)),  // w0 /= w3 (21)
    .ret,
]

let function3 = Jit.shared.write(commandBuffer: Data.fromInstructions(instructions))
let result3 = function3()
print("result3 = \(result3)")
assert(result3 == 21)
