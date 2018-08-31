//
//  ViewController.swift
//  烟火
//
//  Created by best su on 2018/8/16.
//  Copyright © 2018年 best su. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController, CAAnimationDelegate{

    var emitterLayer: CAEmitterLayer!
    
    var finishCallBack: (()->())?
    var calayer: CALayer?
    var isFinish: Bool = true
    var demoLayer: Best_emitterLayer?
    var starArray: [Best_emitterLayer] = [Best_emitterLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        creatStar()
    }
    
    private func creatStar(){
        for i in 0..<20{
            let str1 = "\(arc4random_uniform(15))"
            let str2 = "\(arc4random_uniform(15))"
            let str3 = "\(arc4random_uniform(15))"
            let emitter = Best_emitterLayer.init()
            self.demoLayer = emitter
            let cell = CAEmitterCell.init()
            cell.name = "cell"
            cell.lifetime = 1.3
            cell.birthRate = 3000
            cell.velocity = 50
            cell.velocityRange = 30
            cell.scale = 0.03
            cell.scaleRange  = 0.02
            cell.contents = UIImage.init(named: str1)?.cgImage
            
            let cell1 = CAEmitterCell.init()
            cell1.name = "cell1"
            cell1.lifetime = 1.3
            cell1.birthRate = 3000
            cell1.velocity = 50
            cell1.velocityRange = 20
            cell1.scale = 0.03
            cell1.scaleRange  = 0.02
            cell1.contents = UIImage.init(named: str2)?.cgImage
            
            let cell2 = CAEmitterCell.init()
            cell2.name = "cell2"
            cell2.lifetime = 1.3
            cell2.birthRate = 3000
            cell2.velocity = 50
            cell2.velocityRange = 20
            cell2.scale = 0.03
            cell2.scaleRange  = 0.02
            cell2.contents = UIImage.init(named: str3)?.cgImage
            
            emitter.name = "emitterLayer"
            emitter.emitterShape = kCAEmitterLayerSphere//"circle"
            emitter.emitterMode = kCAEmitterLayerOutline//"outline"
            emitter.emitterSize = CGSize(width: 25, height: 0)
            emitter.emitterCells = [cell, cell1, cell2]
            emitter.renderMode = kCAEmitterLayerOldestFirst//"oldestFirst"
            emitter.masksToBounds = false
            emitter.birthRate = 0
            emitter.zPosition = 0
            emitter.position = CGPoint(x: screenWidth/2, y: 150)
            emitter.index = i
            self.view.layer.addSublayer(emitter)
            
            starArray.append(emitter)
        }
        
    }
    
    var selectIndex: Int = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFinish == false{ return }
        if selectIndex >= 20{
            selectIndex = 0
        }
        setPathAnimator()

        finishCallBack = {
            self.demoLayer?.beginTime = CACurrentMediaTime();
            self.demoLayer?.birthRate = 1;
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                self.demoLayer?.birthRate = 0
                self.isFinish = true
            }
            self.selectIndex += 1
        }
    }

    private func setPathAnimator(){
        
        let dis: CGFloat = CGFloat(arc4random_uniform(200))
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: screenWidth/2, y: screenHeight))
        path.addLine(to: CGPoint(x: screenWidth/2, y: 40 + dis))
        
        let shaperLayer = CAShapeLayer.init()
        shaperLayer.path = path.cgPath
        shaperLayer.fillColor = nil
        shaperLayer.strokeColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(shaperLayer)
        
        let layer = CALayer.init()
        layer.contents = UIImage.init(named: "1")?.cgImage
        layer.frame = CGRect(x: screenWidth/2, y: screenHeight, width: 10, height: 10)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        self.view.layer.addSublayer(layer)
        
        let keyAnimat = CAKeyframeAnimation.init()
        keyAnimat.keyPath = "position"
        keyAnimat.path = path.cgPath
        keyAnimat.duration = 1.0
        keyAnimat.delegate = self
        
        keyAnimat.isRemovedOnCompletion = false
        keyAnimat.fillMode = kCAAnimationRotateAuto
        layer.add(keyAnimat, forKey: nil)
        self.calayer = layer
        
        self.demoLayer = self.starArray[self.selectIndex]
        self.demoLayer?.position = CGPoint(x: screenWidth/2, y: 80 + dis)
        self.isFinish = false
    }
    
    //    MARK:  animationDelete
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        calayer?.removeFromSuperlayer()
        finishCallBack?()
    }
    
}

