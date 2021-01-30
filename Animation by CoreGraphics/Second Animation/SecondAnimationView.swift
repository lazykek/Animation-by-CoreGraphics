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
        
        //высчитываем точку касания пересечения двух окружностей с небольшим поднятием наверх
        let vector1 = Vector(startPoint: viewCenterPoint!, endPoint: mutablePoint!)
        if vector1.isZeroVectorOrNan() != true {
            let vector2 = rotateVector(vector: vector1, angle: pi / 2)
            let cos = vector1.vectorLength() / radius
            let sin = CGFloat(Double(1.0 - cos * cos).squareRoot())
            let tan = sin / cos
            let specialMultiplier: CGFloat = 1 + vector1.vectorLength() / radius / 10
            let vector3 = multiplyingAVectorByANumber(vector: vector2, number: tan * specialMultiplier)
            let crossPoint = endVectorPoint(vector: vector3, starPoint: viewCenterPoint!)
            
            let point1 = specialTangentPoint(tangentialCircle: circle1, overlappedCircle: circle2, point: crossPoint)
            let point2 = specialTangentPoint(tangentialCircle: circle2, overlappedCircle: circle1, point: crossPoint)
            print("point1: \(point1)")
            print("point2: \(point2)")
            
            if (point1 != nil)  &&
                (point2 != nil) &&
                (point1?.x.isNaN != true) &&
                (point1?.y.isNaN != true) &&
                (point2?.x.isNaN != true) &&
                (point2?.y.isNaN != true) {
                context.move(to: point1!)
                context.addQuadCurve(to: point2!, controlPoint: crossPoint)
                context.addLine(to: mirrorPoint(point1!))
                context.addQuadCurve(to: mirrorPoint(point2!), controlPoint: mirrorPoint(crossPoint))
                context.addLine(to: point1!)
                context.fill()
                context.close()
            }
        }
    }
    
    //функция высчитывает точку касания к окружности, которая не перекрывается второй окружностью
    func specialTangentPoint(tangentialCircle: Circle, overlappedCircle: Circle, point: CGPoint) -> CGPoint? {
        var array = tangentsPointOfTouch(circle: tangentialCircle, point: point)
        if array != nil {
            for i in 0..<(array?.count)! {
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
    
    func axisSwitch(k: Int) -> (turnOne: Int, turnSecond: Int){
        if (Int(k / 100) % 2) == 0 {
            return (0, 1)
        } else {
            return (1, 0)
        }
    }
    
    func startAnimation() {
        var i: Double = 0.0
        var cycleCounter: Int = 0
        
        DispatchQueue.global(qos: .default).async {
            
            while true {
                
                print("cycleCounter: \(cycleCounter)")
                let x = self.viewCenterPoint!.x - (self.radius * CGFloat(sin(i)) / 2) * CGFloat(self.axisSwitch(k: cycleCounter).turnOne)
                let y = self.viewCenterPoint!.y - (self.radius * CGFloat(sin(i)) / 2) * CGFloat(self.axisSwitch(k: cycleCounter).turnSecond)
                self.currentPoint = CGPoint(x: x, y: y)
                self.radius = self.oldRadius - CGFloat(self.distanceBetweenTwoPoints(self.currentPoint!, self.viewCenterPoint!)) / 2.5
                i += Double.pi / 100
                cycleCounter += 1
                let second: Double = 0.016
                let millionthsOfASecond = UInt32(second * pow(10, 6))
                usleep(millionthsOfASecond)
//                if cycleCounter == 501 {
//                    print(self.axisSwitch(k: cycleCounter).turnOne, self.axisSwitch(k: cycleCounter).turnSecond)
//                    break
//                }
                DispatchQueue.main.async {
                    self.setNeedsDisplay()
                }
            }
        }
    }
}
