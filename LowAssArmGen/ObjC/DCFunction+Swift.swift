//
//  DCFunction+Swift.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

extension DCFunction {
    // Here for Swift ergonomics:
    func callAsFunction() -> Int {
        Int(run())
    }
}
