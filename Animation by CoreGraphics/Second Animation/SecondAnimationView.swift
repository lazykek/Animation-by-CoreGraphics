//
//  SecondAnimationView.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class SecondAnimationView: UICustomAnimationView {
    
    let pi = CGFloat.pi
    var radius: CGFloat = 60
    var oldRadius: CGFloat = 60
    var isTouched = false
    var currentPoint: CGPoint?
    
    override func draw(_ rect: CGRect) {
        
        drawTwoCircle(point: currentPoint)
    }
    
    func drawTwoCircle(point: CGPoint?) {
        
        var mutablePoint = point
        if mutablePoint == nil {
            mutablePoint = self.viewCenterPoint!
        }
        
        let context = UIBezierPath()
        let circle1 = Circle(centerPoint: mutablePoint!, radius: radius)
        let circle2 = Circle(centerPoint: mirrorPoint(mutablePoint!), radius: radius)
        
        UIColor.black.setFill()
        context.removeAllPoints()
        circle1.drawCircle(context: context)
        circle2.drawCircle(context: context)
        
        let vector1 = Vector(startPoint: viewCenterPoint!, endPoint: mutablePoint!)
        let vector2 = rotateVector(vector: vector1, angle: pi / 2)
        let cos = vector1.vectorLength() / radius
        let sin = CGFloat(Double(1.0 - cos * cos).squareRoot())
        let tan = sin / cos
        let specialMultiplier: CGFloat = 1 + vector1.vectorLength() / radius / 10
        let vector3 = multiplyingAVectorByANumber(vector: vector2, number: tan * specialMultiplier)
        let crossPoint = endVectorPoint(vector: vector3, starPoint: viewCenterPoint!)
//        let circle3 = Circle(centerPoint: crossPoint, radius: 5)
//        circle3.drawCircle(context: context)

        
        let point1 = specialTangentPoint(tangentialCircle: circle1, overlappedCircle: circle2, point: crossPoint)
        let point2 = specialTangentPoint(tangentialCircle: circle2, overlappedCircle: circle1, point: crossPoint)
        
        if (point1 != nil) && (point2 != nil) {
            context.move(to: point1!)
            context.addQuadCurve(to: point2!, controlPoint: crossPoint)
            context.addLine(to: mirrorPoint(point1!))
            context.addQuadCurve(to: mirrorPoint(point2!), controlPoint: mirrorPoint(crossPoint))
            context.addLine(to: point1!)
            context.fill()
            context.close()
        }
        
    }
    
    func specialTangentPoint(tangentialCircle: Circle, overlappedCircle: Circle, point: CGPoint) -> CGPoint? {
        var array = tangentsPointOfTouch(circle: tangentialCircle, point: point)
        if array != nil {
            for i in 0..<(array?.count)! {
                print(i)
                if belongToCircle((array?[i])!, circle: overlappedCircle) {
                    array?.remove(at: i)
                    break
                }
            }
            return array?[0]
        } else {
            return nil
        }
    }
    
    func isTouched(_ point: CGPoint) -> Bool {
        
        if (distanceBetweenTwoPoints(viewCenterPoint!, point) <= Double(radius)) == true {
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
                currentPoint = touch.location(in: self)
                radius = oldRadius - CGFloat(distanceBetweenTwoPoints(currentPoint!, viewCenterPoint!)) / 2.5
                setNeedsDisplay()
            }
        }
    }
}
