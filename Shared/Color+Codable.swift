//
//  Color+Codable.swift
//  TheoPlay
//
//  Created by damiaan on 28/01/2022.
//

import SwiftUI

struct CodableColor: Codable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
}

extension CodableColor {
    init(_ color: Color) {
        var floats = SIMD3<Double>(color.cgColor!.components!.dropLast().map(Double.init))
        floats *= 255
        self.init(
            red: .init(floats[0]),
          green: .init(floats[1]),
           blue: .init(floats[2])
        )
    }
}

extension Color {
    init(_ color: CodableColor) {
        var doubles = SIMD3<Double>(
            Double(color.red),
            Double(color.green),
            Double(color.blue)
        )
        doubles /= 255
        self.init(red: doubles[0], green: doubles[1], blue: doubles[2])
    }
}
