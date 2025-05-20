//
//  ArmRegister.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

typealias ArmRegister = UInt8 // 5 bits!

extension ArmRegister {
    // Helpers just for readability:
    static func w(_ idx: UInt8) -> Self { idx }
    static func x(_ idx: UInt8) -> Self { idx }
}
