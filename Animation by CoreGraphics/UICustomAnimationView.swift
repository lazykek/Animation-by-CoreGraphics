//
//  UICustomAnimationView.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class UICustomAnimationView: UIView {
    
    var viewCenterPoint: CGPoint?
    struct Circle {
        
        private let pi = CGFloat.pi
        var centerPoint: CGPoint
        var radius: CGFloat
        
        init(centerPoint: CGPoint, radius: CGFloat) {
            
            self.centerPoint = centerPoint
            self.radius = radius
        }
        
        func drawCircle(context: UIBezierPath) {
            
            context.move(to: centerPoint)
            context.addArc(withCenter: centerPoint, radius: radius, startAngle: 0, endAngle: 2 * pi, clockwise: true)
            context.fill()
            context.close()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewCenterPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewCenterPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        print(self.frame)
        print(#function)
    }
    
    func tangentsPointOfTouch(circle: Circle, point: CGPoint) -> [CGPoint]? {
        
        var arrayOfPoint: [CGPoint] = []
        let a = circle.centerPoint.x
        let b = point.x
        let c = circle.centerPoint.y
        let d = point.y
        if abs(b - a) > 0.01 {
            let A = circle.radius * circle.radius + a * b + c * d - a * a - c * c
            let B = A / (b - a)
            let C = (c - d) / (b - a)
            let D = B - a
            let E = C * C + 1
            let F = c - C * D
            let G = D * D + c * c - circle.radius * circle.radius
            let discriminant = F * F - E * G
            var y = (F + pow(discriminant, 0.5)) / E
            var x = B + C * y
            arrayOfPoint.append(CGPoint(x: x, y: y))
            y = (F - pow(discriminant, 0.5)) / E
            x = B + C * y
            arrayOfPoint.append(CGPoint(x: x, y: y))
            return arrayOfPoint
        } else {
            print("tangentsPointOfTouch with error")
            return [point, point]
        }
    }
    
    func belongToCircle(_ point: CGPoint, circle: Circle) -> Bool {
        
        if (distanceBetweenTwoPoints(circle.centerPoint, point) <= circle.radius) == true {
            return true
        } else {
            return false
        }
    }
    
    func mirrorPoint(_ reflectedPoint: CGPoint, _ reflectionCenter: CGPoint? = nil) -> CGPoint {
        
        var point = reflectionCenter
        if point == nil {
            point = self.viewCenterPoint
        }
        let mirrorX = 2 * point!.x - reflectedPoint.x
        let mirrorY = 2 * point!.y - reflectedPoint.y
        return CGPoint(x: mirrorX, y: mirrorY)
    }
    
    func distanceBetweenTwoPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        
        let deltaX = Double(point1.x - point2.x)
        let deltaY = Double(point1.y - point2.y)
        let distance = deltaX * deltaX + deltaY * deltaY
        return CGFloat(pow(distance, 0.5))
    }
    
    func endVectorPoint(vector: Vector, starPoint: CGPoint) -> CGPoint {
        
        return CGPoint(x: vector.x + starPoint.x, y: vector.y + starPoint.y)
    }
    
}
