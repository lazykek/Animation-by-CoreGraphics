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
        let specialMultiplier: CGFloat = 1 + cos
        let vector3 = multiplyingAVectorByANumber(vector: vector2, number: tan * specialMultiplier)
        
        let crossPoint = endVectorPoint(vector: vector3, starPoint: viewCenterPoint!)
        let circle3 = Circle(centerPoint: crossPoint, radius: 5)
        //circle3.drawCircle(context: context)
        
        //let centerCircle = Circle(centerPoint: viewCenterPoint!, radius: 2)
        var array1 = tangentsPointOfTouch(circle: circle1, point: crossPoint)
        print(array1?.count)
        if array1 != nil {
            for i in 0..<(array1?.count)! {
                print(i)
                if isTouchedInCircle((array1?[i])!, circle: circle1) || isTouchedInCircle((array1?[i])!, circle: circle2) {
                    array1?.remove(at: i)
                    print("remove")
                    let circle = Circle(centerPoint: (array1?[0])!, radius: 5)
                    //circle.drawCircle(context: context)
                    break
                }
            }
        }
        print(array1?.count)
        
        var array2 = tangentsPointOfTouch(circle: circle2, point: crossPoint)
        print(array2?.count)
        if array2 != nil {
            for i in 0..<(array2?.count)! {
                print(i)
                if isTouchedInCircle((array2?[i])!, circle: circle1) || isTouchedInCircle((array2?[i])!, circle: circle2) {
                    array2?.remove(at: i)
                    print("remove")
                    let circle = Circle(centerPoint: (array2?[0])!, radius: 5)
                    //circle.drawCircle(context: context)
                    break
                }
            }
        }
        print(array2?.count)
        
        context.move(to: (array1?[0])!)
        context.addQuadCurve(to: (array2?[0])!, controlPoint: crossPoint)
        context.addLine(to: mirrorPoint((array1?[0])!))
        context.addQuadCurve(to: mirrorPoint((array2?[0])!), controlPoint: mirrorPoint(crossPoint))
        context.addLine(to: (array1?[0])!)
        context.fill()
        context.close()
        
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
                setNeedsDisplay()
            }
        }
    }
}
