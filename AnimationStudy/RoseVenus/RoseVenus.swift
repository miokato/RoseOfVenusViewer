//
//  RoseVenus.swift
//  AnimationStudy
//
//  Created by mio kato on 2022/03/03.
//

import UIKit
import SpriteKit

/// 内円と外円をつなぐ線
struct Line {
    let innerPoint: SIMD2<Float>
    let outerPoint: SIMD2<Float>
}

/// 内円と外円のラジアン角
struct TwoRadian {
    let inner: Float
    let outer: Float
}

class RoseVenus {
    
    // 内円と外円のラジアン角
    private var currentTwoRadians: [TwoRadian]
    private var nextTwoRadians: [TwoRadian]?
    
    // 最大半径と外円の半径の比率
    private var currentOuterRatio: Float = 1.0
    private var nextOuterRatio: Float = 1.0

    // 外円と内円の半径の比率
    private var currentInnerRatio: Float = 0.6
    private var nextInnerRatio: Float = 0.6
    
    // 色相
    private var currentHue: Float = 1.0
    private var nextHue: Float = 1.0
    
    // 彩度
    private var currentSaturation: Float = 1.0
    private var nextSaturation: Float = 1.0
    
    // 明度
    private var currentBrightness: Float = 1.0
    private var nextBrightness: Float = 1.0
    
    // 外円の最大半径
    private let maxOuterRadius: Float
    
    // 各円の点の数
    private let numOfPoints: Int
    
    // 補完するまでのフレーム数(大きい値だとゆっくり描画する)
    private var frameDuration: Float = 60.0
    private var hz: Float {
        1.0 / frameDuration
    }
    
    // 描画するSKNode
    private var lines: [SKShapeNode]?
    
    
    init(maxOuterRadius: Float, numOfPoints: Int) {
        self.numOfPoints = numOfPoints
        self.maxOuterRadius = maxOuterRadius
        self.currentTwoRadians = [TwoRadian](repeating: TwoRadian(inner: 0, outer: 0), count: numOfPoints)
        self.nextTwoRadians = nil
    }
    
    /// 描画した線を返す
    func getLines() -> [SKShapeNode]? {
        update()
        return lines
    }
    
    func setFrameDuration(_ frameDuration: Float) {
        self.frameDuration = frameDuration
    }
    
    /// OSCで受け取った次のパラメータをセットする
    func setNext(inTheta: Float,
                 outTheta: Float,
                 inRatio: Float,
                 outRatio: Float,
                 hue: Float,
                 saturation: Float,
                 brightness: Float) {
        nextOuterRatio = outRatio
        nextInnerRatio = inRatio
        nextHue = hue
        nextSaturation = saturation
        nextBrightness = brightness
        let outerRadius = maxOuterRadius * nextOuterRatio
        let innerRadius = outerRadius * nextInnerRatio
        self.nextTwoRadians = updateTwoRadians(innerRadius: innerRadius,
                                               outerRadius: outerRadius,
                                               innerTheta: inTheta,
                                               outerTheta: outTheta)
    }
    
    /// 線を描画
    private func createLine(from: CGPoint, to: CGPoint, color: UIColor) -> SKShapeNode {
        let line = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        line.path = path.cgPath
        line.strokeColor = color
        line.lineWidth = 1
        return line
    }
    
    /// 色を線形補完して更新
    private func updateColor() -> UIColor {
        currentHue = currentHue * (1.0 - hz) + nextHue * hz
        currentSaturation = currentSaturation * (1.0 - hz) + nextSaturation * hz
        currentBrightness = currentBrightness * (1.0 - hz) + nextBrightness * hz
        
        let color = UIColor(hue: CGFloat(currentHue),
                            saturation: CGFloat(currentSaturation),
                            brightness: CGFloat(currentBrightness),
                            alpha: 1.0)
        return color
    }
   
    /// currentRadiansを更新
    private func update() {
        guard let nextTwoRadians = nextTwoRadians else {
            return
        }

        let color = updateColor()
        
        currentOuterRatio = currentOuterRatio * (1.0 - hz) + nextOuterRatio * hz
        currentInnerRatio = currentInnerRatio * (1.0 - hz) + nextInnerRatio * hz
        let outerRadius = maxOuterRadius * currentOuterRatio
        let innerRadius = outerRadius * currentInnerRatio
        
        var lines = [SKShapeNode]()
        var twoRadians = [TwoRadian]()
        for i in 0..<numOfPoints {
            let currentRadian = currentTwoRadians[i]
            let nextRadian = nextTwoRadians[i]

            let din = nextRadian.inner - currentRadian.inner
            let dout = nextRadian.outer - currentRadian.outer
            
            let inTheta = currentRadian.inner * (1.0 - hz) + din * hz
            let outTheta = currentRadian.outer * (1.0 - hz) + dout * hz
            let twoRadian = TwoRadian(inner: inTheta, outer: outTheta)
            twoRadians.append(twoRadian)
            
            let inPoint = Calculator.polar(r: innerRadius, theta: inTheta)
            let outPoint = Calculator.polar(r: outerRadius, theta: outTheta)

            let line = Line(innerPoint: inPoint, outerPoint: outPoint)
            let shape = createLine(from: CGPoint(x: CGFloat(line.innerPoint.x), y: CGFloat(line.innerPoint.y)),
                                   to: CGPoint(x: CGFloat(line.outerPoint.x), y: CGFloat(line.outerPoint.y)),
                                   color: color)
            lines.append(shape)
        }
        self.currentTwoRadians = twoRadians
        self.lines = lines
    }
    
    private func updateTwoRadians(innerRadius: Float,
                                  outerRadius: Float,
                                  innerTheta: Float,
                                  outerTheta: Float) -> [TwoRadian] {
        var twoRadians = [TwoRadian]()
        for i in 0..<numOfPoints {
            let iTheta = innerTheta * Float(i)
            let oTheta = outerTheta * Float(i)
            let twoRadian = TwoRadian(inner: iTheta, outer: oTheta)
            twoRadians.append(twoRadian)
        }
        return twoRadians
    }
}
