//
//  Utils.swift
//  AnimationStudy
//
//  Created by mio kato on 2022/03/03.
//

import Foundation

class Calculator {
    static func polar(r: Float, theta: Float) -> SIMD2<Float> {
        let x = r * cos(theta)
        let y = r * sin(theta)
        return SIMD2(x, y)
    }            
}

extension Float {
    func degToRad() -> Float {
        return self * .pi / 180
    }
}
