import Foundation
import CoreImage

class Matrix2D : CustomStringConvertible
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
    
    var description: String
    {
        let line1: String = "| \(self.cell_11)   \(self.cell_12) \(self.cell_13) |"
        let line2: String = "| \(self.cell_21)   \(self.cell_22) \(self.cell_23) |"
        let line3: String = "| \(self.cell_31)   \(self.cell_32) \(self.cell_33) |"
        return line1 + "\n" + line2 + "\n" + line3
    }
    
    // 1 0 0
    // 0 1 0
    // 0 0 1
    func getIdentity() -> Matrix2D
    {
        let retVal: Matrix2D = Matrix2D()
        retVal.cell_11 = 1
        retVal.cell_22 = 1
        retVal.cell_33 = 1
        return retVal
    }
    
    // These matrices are to be applied 'pre' multiplication:
    // Ax = x'
    
    // 1  0  0
    // 0  1  0
    // tx ty 1
    func getTranslation(tx: CGFloat, ty: CGFloat) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        retVal.cell_31 = tx
        retVal.cell_32 = ty
        return retVal
    }
    
    // cos  -sin 0
    // sin cos   0
    // 0    0    1
    func getRotation(theta: CGFloat) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        let cosTheta: CGFloat = cos(theta)
        let sinTheta: CGFloat = sin(theta)
        retVal.cell_11 = cosTheta
        retVal.cell_12 = -sinTheta
        retVal.cell_21 = sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    func getRotation(heading: Vector2D) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        let hypotLength: CGFloat = CGFloat(sqrt((heading.x * heading.x) + (heading.y * heading.y)))
        let cosTheta: CGFloat = heading.x / hypotLength
        let sinTheta: CGFloat = heading.y / hypotLength
        retVal.cell_11 = cosTheta
        retVal.cell_12 = -sinTheta
        retVal.cell_21 = sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    func getAntiRotation(heading: Vector2D) -> Matrix2D
    {
        let retVal: Matrix2D = getIdentity()
        let hypotLength: CGFloat = CGFloat(sqrt((heading.x * heading.x) + (heading.y * heading.y)))
        let cosTheta: CGFloat = heading.x / hypotLength
        let sinTheta: CGFloat = heading.y / hypotLength
        retVal.cell_11 = cosTheta
        retVal.cell_12 = sinTheta
        retVal.cell_21 = -sinTheta
        retVal.cell_22 = cosTheta
        return retVal
    }
    
    // x y 1 | 0 0 0
    //       | 0 0 0
    //       | 0 0 0
    static func *(left: Vector2D, right: Matrix2D) -> Vector2D
    {
        var x: CGFloat = left.x * right.cell_11 + left.y * right.cell_21 + 1 * right.cell_31
        var y: CGFloat = left.x * right.cell_12 + left.y * right.cell_22 + 1 * right.cell_32
        var h: CGFloat = left.x * right.cell_13 + left.y * right.cell_23 + 1 * right.cell_33
        if h != 1
        {
            x = x / h
            y = y / h
            h = 1
        }
        return Vector2D(x: x, y: y)
    }
}
