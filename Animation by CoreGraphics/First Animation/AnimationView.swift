//
//  AnimationView.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class AnimationView: UIView {
    
    let pi = CGFloat.pi
    var radius: CGFloat = 40
    var isTouched = false
    var centerPoint: CGPoint?
    var currentPoint: CGPoint?
    
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
        pointOfTouch(centerOfCircle: currentPoint!)
    }
    
    func drawTwoCircle(point: CGPoint) {
        
        //draw Two Circle
        let context = UIBezierPath()
        
        UIColor.black.setFill()
        context.removeAllPoints()
        context.move(to: point)
        context.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: 2 * pi, clockwise: true)
        context.fill()
        context.close()
        
        context.move(to: mirrorPoint(point))
        context.addArc(withCenter: mirrorPoint(point), radius: radius, startAngle: 0, endAngle: 2 * pi, clockwise: true)
        context.fill()
        context.close()
    }
    
    func mirrorPoint(_ point: CGPoint) -> CGPoint {
        
        let mirrorX = 2 * (centerPoint?.x)! - point.x
        let mirrorY = 2 * (centerPoint?.y)! - point.y
        return CGPoint(x: mirrorX, y: mirrorY)
    }
    
    func pointOfTouch(centerOfCircle: CGPoint) {
        
        let context = UIBezierPath()
        var arrayOfPoint: [CGPoint] = []
        let a = centerOfCircle.x
        let b = centerPoint!.x
        let c = centerOfCircle.y
        let d = centerPoint!.y
        
        let A = radius * radius + a * b + c * d - a * a - c * c
        let B = A / (b-a)
        let C = (c - d) / (b - a)
        let D = B - a
        let E = C * C + 1
        let F = c - C * D
        let G = D * D + c * c - radius * radius
        let discriminant = F * F - E * G
        print(discriminant)
        
        var y = (F + pow(discriminant, 0.5)) / E
        var x = B + C * y
        
        arrayOfPoint.append(CGPoint(x: x, y: y))
        arrayOfPoint.append(mirrorPoint(CGPoint(x: x, y: y)))
        
        y = (F - pow(discriminant, 0.5)) / E
        x = B + C * y
        arrayOfPoint.append(CGPoint(x: x, y: y))
        arrayOfPoint.append(mirrorPoint(CGPoint(x: x, y: y)))
        
        UIColor.black.setFill()
        context.move(to: arrayOfPoint[0])
        context.addQuadCurve(to: arrayOfPoint[3], controlPoint: centerPoint!)
        context.addLine(to: arrayOfPoint[1])
        context.addQuadCurve(to: arrayOfPoint[2], controlPoint: centerPoint!)
        context.addLine(to: arrayOfPoint[0])
        context.close()
        context.fill()
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
                //radius = 40 - CGFloat(0.3 * distanceBetweenTwoPoints(centerPoint!, touch.location(in: self)))
                currentPoint! = touch.location(in: self)
                setNeedsDisplay()
            }
        }
    }
}
