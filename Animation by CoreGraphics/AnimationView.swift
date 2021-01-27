//
//  AnimationView.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class AnimationView: UIView {

    let pi = CGFloat.pi
    let radius: CGFloat = 40
    var isTouched = false
    var centerPoint: CGPoint?
    var currentPoint: CGPoint?
    var context = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        currentPoint = centerPoint
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        centerPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        currentPoint = centerPoint
        print(#function)
    }
    
    override func draw(_ rect: CGRect) {
        
        drawTwoCircle(point: currentPoint!)
    }

    func drawTwoCircle(point: CGPoint) {
        
        context.removeAllPoints()
        context.move(to: point)
        context.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: 2 * pi, clockwise: true)
        context.fill()
        context.close()
        
        let mirrorX = 2 * (centerPoint?.x)! - point.x
        let mirrorY = 2 * (centerPoint?.y)! - point.y
        let mirrorPoint = CGPoint(x: mirrorX, y: mirrorY)
        
        context.move(to: mirrorPoint)
        context.addArc(withCenter: mirrorPoint, radius: radius, startAngle: 0, endAngle: 2 * pi, clockwise: true)
        context.fill()
        context.close()
    }
    
    func distanceBetweenTwoPoints(_ point1: CGPoint, _ point2: CGPoint) -> Double {
        
        let deltaX = Double(point1.x - point2.x)
        let deltaY = Double(point1.y - point2.y)
        let distance = deltaX * deltaX + deltaY * deltaY
        return pow(distance, 0.5)
    }
    
    func isTouched(_ point: CGPoint) -> Bool {
        
        if (distanceBetweenTwoPoints(centerPoint!, point) <= Double(radius)) == true {
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            isTouched = self.isTouched(touch.location(in: self))
            print(isTouched)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if isTouched == true {
                print(touch.location(in: self))
                currentPoint! = touch.location(in: self)
                setNeedsDisplay()
            }
        }
    }
}
