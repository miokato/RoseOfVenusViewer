//
//  RoseVenusView.swift
//  AnimationStudy
//
//  Created by mio kato on 2022/03/02.
//

import UIKit
import SpriteKit

class RoseVenusView: SKView {
    
    var roseVenusScene: RoseVenusScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scene = RoseVenusScene(size: bounds.size)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        presentScene(scene)
        self.roseVenusScene = scene
                
        showsFPS = false
        ignoresSiblingOrder = false
        showsNodeCount = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(inTheta: Float,
                outTheta: Float,
                inRatio: Float,
                outRatio:Float,
                hue: Float,
                saturation: Float,
                brightness: Float) {
        
        roseVenusScene?.roseVenus.setNext(inTheta: inTheta,
                                          outTheta: outTheta,
                                          inRatio: inRatio,
                                          outRatio: outRatio,
                                          hue: hue,
                                          saturation: saturation,
                                          brightness: brightness)
    }
    
   
}
