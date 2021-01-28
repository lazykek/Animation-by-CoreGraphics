//
//  Vector.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit
struct Vector {
    
    var x: CGFloat
    var y: CGFloat
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.x = endPoint.x - startPoint.x
        self.y = endPoint.y - startPoint.y
    }
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func vectorLength() -> CGFloat {
        
        let length = Double(self.x * self.x + self.y * self.y).squareRoot()
        return CGFloat(length)
    }
    
    func normalize() -> Vector {
        let length = Double(self.x * self.x + self.y * self.y).squareRoot()
        return Vector(x: CGFloat(Double(x) / length), y: CGFloat(Double(y) / length))
    }
    
    func isZeroVectorOrNan() -> Bool {
        if ((self.x == 0.0)&&(self.y == 0.0))||((self.x.isNaN)&&(self.y.isNaN)) {
            return true
        } else {
            return false
        }
    }
}

func vectorDifference(decreasingVector: Vector, vectorToSubtract: Vector) -> Vector {
    let x = decreasingVector.x - vectorToSubtract.x
    let y = decreasingVector.y - vectorToSubtract.y
    return Vector(x: x, y: y)
}

func equationOfVector(vector1: Vector, vector2: Vector) -> Bool {
    if (vector1.x == vector2.x)&&(vector1.y == vector2.y) {
        return true
    } else {
        return false
    }
}

func rotateVector(vector: Vector, angle: CGFloat, clockwise: Bool = false) -> Vector {
    var mutableAngle: CGFloat
    if clockwise == true {
        mutableAngle = 0 - angle
    } else {
        mutableAngle = angle
    }
    let x = vector.x * cos(mutableAngle) + vector.y * sin(mutableAngle)
    let y = vector.y * cos(mutableAngle) - vector.x * sin(mutableAngle)
    return Vector(x: x, y: y)
}

func multiplyingAVectorByANumber(vector: Vector, number: CGFloat) -> Vector {
    let x = vector.x * number
    let y = vector.y * number
    return Vector(x: x, y: y)
}
