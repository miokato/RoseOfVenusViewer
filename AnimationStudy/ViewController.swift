//
//  ViewController.swift
//  AnimationStudy
//
//  Created by mio kato on 2022/03/02.
//

import UIKit
import F53OSC

class ViewController: UIViewController {
    
    var roseVenusView: RoseVenusView?
    
    let oscServer = F53OSCServer.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rose venus
        let roseVenusView = RoseVenusView(frame: view.bounds)
        view.addSubview(roseVenusView)
        self.roseVenusView = roseVenusView
        
        // osc
        oscServer.delegate = self
        oscServer.port = 12400
        oscServer.startListening()

        // gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        // サンプルの値
//        roseVenusView?.update(inTheta: 0.95,
//                             outTheta: 0.31,
//                             inRatio: 0.798,
//                              outRatio: 0.472,
//                             hue: 0.033,
//                              saturation: 0.47,
//                              brightness: 0.68)
        
    }            
}

extension ViewController: F53OSCServerDelegate, F53OSCPacketDestination {
    func take(_ message: F53OSCMessage?) {
        guard let message = message else {
            return
        }
        print("Receive OSC \(message)")
        
        let values = message.arguments
        let inTheta = values[0] as! Float
        let outTheta = values[1] as! Float
        let inRatio = values[2] as! Float
        let outRatio = values[3] as! Float
        let hue = values[4] as! Float
        let saturation = values[5] as! Float
        let brightness = values[6] as! Float
        
        // 描画
        roseVenusView?.update(inTheta: inTheta,
                             outTheta: outTheta,
                             inRatio: inRatio,
                             outRatio: outRatio,
                             hue: hue,
                             saturation: saturation,
                              brightness: 1.0)
    }
}
