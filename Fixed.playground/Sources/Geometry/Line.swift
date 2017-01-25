import Foundation
import QuartzCore
import UIKit

public struct Line: CustomStringConvertible, CustomDebugStringConvertible
{
    public var startPoint: CGPoint
    public var endPoint:   CGPoint
    public var color:      UIColor
    
    public init(startPoint: CGPoint, endPoint: CGPoint, color: UIColor)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.color = color
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    public var debugDescription: String
    {
        return "(\(self.startPoint.x), \(self.startPoint.y)) -- (\(self.endPoint.x), \(self.endPoint.y))"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    public var description: String
    {
        return "(\(self.startPoint.x), \(self.startPoint.y)) -- (\(self.endPoint.x), \(self.endPoint.y))"
    }
    
    // Ray begins to the left of the bounding box and extends to just right
    // of the click-point.
    public static func calcMinRay(fromClickPoint point: CGPoint, andPolygon polygon: Polygon) -> Line
    {
        let tollerance: CGFloat = CGFloat.leastNormalMagnitude
        let startX = polygon.vertices.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let startPoint: CGPoint = CGPoint(x: startX - tollerance, y: point.y)
        let endX: CGFloat = point.x + tollerance
        let endPoint: CGPoint = CGPoint(x: endX, y: point.y)
        let retVal = Line(startPoint: startPoint, endPoint: endPoint, color: UIColor.black)
        return retVal
    }
    
    // Produce an array of Lines that represent the sides of the polygon.an
    // Notice that the sides form a closed polygon.
    public static func getSides(ofPolygon polygon: Polygon) -> [ Line ]
    {
        var sides: [ Line ] = [ Line ]()
        for (index, v) in polygon.vertices.enumerated()
        {
            var first: CGPoint
            var second: CGPoint
            if index + 1 < polygon.vertices.count
            {
                first = v
                second = polygon.vertices[index + 1]
            }
            else
            {
                first = v
                second = polygon.vertices.first!
            }
            sides.append(Line(startPoint: first, endPoint: second, color: UIColor.black))
        }
        return sides
    }
    
    // This is just to eliminate points that are way outside of the polygon.
    // If this function returns true the point must be further checked to
    // see that the point is not within a convex section of the polygon.
    public static func isPointInBoundingBox(point: CGPoint, inPolygon: Polygon) -> Bool
    {
        let (minX, maxX, minY, maxY) = inPolygon.getBoundingBox()
        if point.x < minX || point.x > maxX || point.y < minY || point.y > maxY
        {
            return false
        }
        return true
    }
    
    // The ray is drawn from a given point to just-left of the left side of the polygon.
    // The line is a side of the given polygon.
    public static func doesSideIntersectRay(side: Line, ray: Line) -> Bool
    {
        // A1x + B1y + C1 = 0
        let A1 = side.startPoint.y - side.endPoint.y
        let B1 = side.startPoint.x - side.endPoint.x
        let v1: Vector2D = Vector2D(x: side.startPoint.x, y: side.startPoint.y)
        let v2: Vector2D = Vector2D(x: side.endPoint.x, y: side.endPoint.y)
        let C1 = v1.cross(with: v2)
        
        // A2x + B2y + C2 = 0
        let A2 = ray.startPoint.y - ray.endPoint.y
        let B2 = ray.startPoint.x - ray.endPoint.x
        let v3: Vector2D = Vector2D(x: ray.startPoint.x, y: ray.startPoint.y)
        let v4: Vector2D = Vector2D(x: ray.endPoint.x, y: ray.endPoint.y)
        let C2 = v3.cross(with: v4)
        
        // Solve simultaneous equations using Crammer's Rule.
        
        // A1  B1  C1
        // A2  B2  C2
        
        // det |A1  B1|
        //     |A2  B2|
        
        let det = (A1 * B2) - (B1 * A2)
        
        // detX |C1  B1|
        //      |C2  B2|
        
        let detX = (C1 * B2) - (B1 * C2)
        
        // detY |A1  C1|
        //      |A2  C2|
        
        let detY = ((A1 * C2) - (C1 * A2))
        
        let xSolution = detX / det
        let ySolution = detY / det
        
        if xSolution.isNormal && ySolution.isNormal
        {
            if (xSolution < ray.startPoint.x || xSolution > ray.endPoint.x)
            {
                return false
            }
            print("Solution for Side: (\(side.startPoint.x),\(side.startPoint.y)) - (\(side.endPoint.x),\(side.endPoint.y)) (\(xSolution),\(ySolution))")
            return true
        }
        return false
    }
    
    public func render(onTo image: UIImage) -> UIImage?
    {
        UIGraphicsBeginImageContext(image.size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(self.color.cgColor)
            context.move(to: self.startPoint)
            context.addLine(to: self.endPoint)
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
