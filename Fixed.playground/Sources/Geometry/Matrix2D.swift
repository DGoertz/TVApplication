import Foundation
import CoreImage

public class Matrix2D : CustomStringConvertible
{
    var cell_11: CGFloat = 0
    var cell_12: CGFloat = 0
    var cell_13: CGFloat = 0
    
    var cell_21: CGFloat = 0
    var cell_22: CGFloat = 0
    var cell_23: CGFloat = 0
    
    var cell_31: CGFloat = 0
    var cell_32: CGFloat = 0
    var cell_33: CGFloat = 0
    
    public var description: String
    {
        let line1: String = "| \(self.cell_11)   \(self.cell_12) \(self.cell_13) |"
        let line2: String = "| \(self.cell_21)   \(self.cell_22) \(self.cell_23) |"
        let line3: String = "| \(self.cell_31)   \(self.cell_32) \(self.cell_33) |"
        return line1 + "\n" + line2 + "\n" + line3
    }
    
    // I am using pre-multiplication throughout; so a row-vector to the left of the matrix.
    
    // 1 0 0
    // 0 1 0
    // 0 0 1
    public static func getIdentity() -> Matrix2D
    {
        let retVal: Matrix2D = Matrix2D()
        retVal.cell_11 = 1
        retVal.cell_22 = 1
        retVal.cell_33 = 1
        return retVal
    }
    
    // These matrices are to be applied 'pre' multiplication:
    // that is to say a row vector onto a matrix.
    
    // 1  0  0
    // 0  1  0
    // tx ty 1
    public static func getTranslation(tx: CGFloat, ty: CGFloat) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        retVal.cell_31 = tx
        retVal.cell_32 = ty
        return retVal
    }
    
    //  cos  sin   0
    // -sin  cos   0
    //    0    0   1
    public static func getRotation(theta: CGFloat) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        let cosTheta: CGFloat = cos(theta)
        let sinTheta: CGFloat = sin(theta)
        retVal.cell_11 = cosTheta
        retVal.cell_12 = sinTheta
        retVal.cell_21 = -sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    public static func getSinCos(heading: Vector2D) -> (CGFloat, CGFloat)
    {
        let hypotLength: CGFloat = CGFloat(sqrt((heading.x * heading.x) + (heading.y * heading.y)))
        let sinTheta: CGFloat = heading.y / hypotLength
        let cosTheta: CGFloat = heading.x / hypotLength
        return (sinTheta, cosTheta)
    }
    
    public static func getRotation(heading: Vector2D) -> Matrix2D
    {
        let (sinTheta, cosTheta) = Matrix2D.getSinCos(heading: heading)
        let retVal: Matrix2D = getIdentity()
        retVal.cell_11 = cosTheta
        retVal.cell_12 = sinTheta
        retVal.cell_21 = -sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    public static func getRotation(heading: Vector2D, side: Vector2D) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        retVal.cell_11 = heading.x
        retVal.cell_21 = heading.y
        retVal.cell_12 = side.x
        retVal.cell_22 = side.y
        return retVal
    }
    
    public static func getAntiRotation(heading: Vector2D) -> Matrix2D
    {
        let (sinTheta, cosTheta) = Matrix2D.getSinCos(heading: heading)
        let retVal: Matrix2D = getIdentity()
        retVal.cell_11 = cosTheta
        retVal.cell_12 = -sinTheta
        retVal.cell_21 = sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    public static func getCoorTranslation(heading: Vector2D, side: Vector2D, origin: CGPoint) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        retVal.cell_11 = heading.x
        retVal.cell_21 = heading.y
        retVal.cell_12 = side.x
        retVal.cell_22 = side.y
        retVal.cell_31 = origin.x
        retVal.cell_32 = origin.y
        return retVal
    }
}

// x y 1 | 0 0 0
//       | 0 0 0
//       | 0 0 0
public func * (left: Vector2D, right: Matrix2D) -> Vector2D
{
    var x: CGFloat = left.x * right.cell_11 + left.y * right.cell_21 + 1 * right.cell_31
    var y: CGFloat = left.x * right.cell_12 + left.y * right.cell_22 + 1 * right.cell_32
    let h: CGFloat = left.x * right.cell_13 + left.y * right.cell_23 + 1 * right.cell_33
    if h != 1
    {
        x = x / h
        y = y / h
    }
    return Vector2D(x: x, y: y)
}

// (x, y)
public func * (left: CGPoint, right: Matrix2D) -> CGPoint
{
    var x: CGFloat = left.x * right.cell_11 + left.y * right.cell_21
    var y: CGFloat = left.x * right.cell_12 + left.y * right.cell_22
    let h: CGFloat = left.x * right.cell_13 + left.y * right.cell_23
    if h != 1
    {
        x = x / h
        y = y / h
    }
    return CGPoint(x: x, y: y)
}

// a b c | 0 0 0
// d e f | 0 0 0
// g h i | 0 0 0
public func * (left: Matrix2D, right: Matrix2D) -> Vector2D
{
    let x1: CGFloat = left.cell_11 * right.cell_11 + left.cell_12 * right.cell_21 + left.cell_13 * right.cell_31
    
    let x2: CGFloat = left.cell_11 * right.cell_12 + left.cell_12 * right.cell_22 + left.cell_13 * right.cell_32
    
    let x3: CGFloat = left.cell_11 * right.cell_13 + left.cell_12 * right.cell_23 + left.cell_13 * right.cell_33
    
    var x = x1 + x2 + x3
    
    let y1: CGFloat = left.cell_21 * right.cell_11 + left.cell_22 * right.cell_21 + left.cell_23 * right.cell_31
    
    let y2: CGFloat = left.cell_21 * right.cell_12 + left.cell_22 * right.cell_22 + left.cell_23 * right.cell_32
    
    let y3: CGFloat = left.cell_21 * right.cell_13 + left.cell_22 * right.cell_23 + left.cell_23 * right.cell_33
    
    var y = y1 + y2 + y3
    
    let z1: CGFloat = left.cell_31 * right.cell_11 + left.cell_32 * right.cell_21 + left.cell_33 * right.cell_31
    
    let z2: CGFloat = left.cell_31 * right.cell_12 + left.cell_32 * right.cell_22 + left.cell_33 * right.cell_32
    
    let z3: CGFloat = left.cell_31 * right.cell_13 + left.cell_32 * right.cell_23 + left.cell_33 * right.cell_33
    
    let z = z1 + z2 + z3
    
    if z != 1
    {
        x = x / z
        y = y / z
    }
    return Vector2D(x: x, y: y)
}

// a b c | j k l
// d e f | m n o
// g h i | p q r
public func * (left: Matrix2D, right: Matrix2D) -> Matrix2D
{
    let retMatrix: Matrix2D = Matrix2D()
    
    let one: CGFloat = (left.cell_11 * right.cell_11) + (left.cell_12 * right.cell_21) + (left.cell_13 * right.cell_31)
    let two: CGFloat = (left.cell_11 * right.cell_12) + (left.cell_12 * right.cell_22) + (left.cell_13 * right.cell_32)
    let tre: CGFloat = (left.cell_11 * right.cell_13) + (left.cell_12 * right.cell_23) + (left.cell_13 * right.cell_33)
    
    let frr: CGFloat = (left.cell_21 * right.cell_11) + (left.cell_22 * right.cell_21) + (left.cell_23 * right.cell_31)
    let fiv: CGFloat = (left.cell_21 * right.cell_12) + (left.cell_22 * right.cell_22) + (left.cell_23 * right.cell_32)
    let six: CGFloat = (left.cell_21 * right.cell_13) + (left.cell_22 * right.cell_23) + (left.cell_23 * right.cell_33)
    
    let sev: CGFloat = (left.cell_31 * right.cell_11) + (left.cell_32 * right.cell_21) + (left.cell_33 * right.cell_31)
    let eig: CGFloat = (left.cell_31 * right.cell_12) + (left.cell_32 * right.cell_22) + (left.cell_33 * right.cell_32)
    let nin: CGFloat = (left.cell_31 * right.cell_13) + (left.cell_32 * right.cell_23) + (left.cell_33 * right.cell_33)
    
    retMatrix.cell_11 = one
    retMatrix.cell_12 = two
    retMatrix.cell_13 = tre
    
    retMatrix.cell_21 = frr
    retMatrix.cell_22 = fiv
    retMatrix.cell_23 = six
    
    retMatrix.cell_31 = sev
    retMatrix.cell_32 = eig
    retMatrix.cell_33 = nin
    
    return retMatrix
}
