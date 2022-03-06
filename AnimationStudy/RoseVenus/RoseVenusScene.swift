//
//  RoseVenusScene.swift
//  AnimationStudy
//
//  Created by mio kato on 2022/03/02.
//

import Foundation
import SpriteKit


class RoseVenusScene: SKScene {
    
    // 図形描画クラス
    var roseVenus: RoseVenus!
    
    var frameCounter: Int = 0
    
    override func didMove(to view: SKView) {
        // フレームレート
        view.preferredFramesPerSecond = 60
        
        // 画面サイズから描画する円の最大半径を計算
        let maxRadius = Float(min(view.bounds.width, view.bounds.height)) * 0.5
        roseVenus = RoseVenus(maxOuterRadius: maxRadius, numOfPoints: 500)
        roseVenus.setFrameDuration(60)
    }
    
    /// 指定したフレームレートで更新処理
    override func update(_ currentTime: TimeInterval) {
        frameCounter += 1

        // 4秒おきに図形をランダムに更新
//        if frameCounter % 240 == 0 {
//            frameCounter = 0
//            setNext()
//        }
        draw()
    }
    
    /// 絵を更新
    func draw() {
        removeAllChildren()

        guard let lines = roseVenus.getLines() else {
            return
        }
        
        for line in lines {
            addChild(line)
        }
    }
    
    /// OSCで受け取った次の値をセット
    func setNext() {
        roseVenus.setNext(inTheta: Float.random(in: 0.25...0.3),
                          outTheta: Float.random(in: 0.35...0.4),
                          inRatio: Float.random(in: 0.4...1.0),
                          outRatio: Float.random(in: 0.4...1.0),
                          hue: Float.random(in: 0...1.0),
                          saturation: Float.random(in: 0.4...1.0),
                          brightness: Float.random(in: 0.8...1.0))
    }
            
    /// For Debug
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
