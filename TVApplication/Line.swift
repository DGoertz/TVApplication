import Foundation
import QuartzCore
import UIKit

struct Line: CustomStringConvertible, CustomDebugStringConvertible
{
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    init(startPoint: CGPoint, endPoint: CGPoint)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    var debugDescription: String
    {
        return "(\(self.startPoint.x), \(self.startPoint.y)) -- (\(self.endPoint.x), \(self.endPoint.y))"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    
    var description: String
    {
        return "(\(self.startPoint.x), \(self.startPoint.y)) -- (\(self.endPoint.x), \(self.endPoint.y))"
    }
    
    // Ray begins to the left of the bounding box and extends to just right
    // of the click-point.
    static func calcMinRay(fromClickPoint point: CGPoint, andPolygon polygon: [CGPoint]) -> Line
    {
        let tollerance: CGFloat = CGFloat.leastNormalMagnitude
        let startX = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let startPoint: CGPoint = CGPoint(x: startX - tollerance, y: point.y)
        let endX: CGFloat = point.x + tollerance
        let endPoint: CGPoint = CGPoint(x: endX, y: point.y)
        let retVal = Line(startPoint: startPoint, endPoint: endPoint)
        return retVal
    }
    
    // Produce an array of Lines that represent the sides of the polygon.an
    // Notice that the sides form a closed polygon.
    static func getSides(ofPolygon polygon: [CGPoint]) -> [ Line ]
    {
        var sides: [ Line ] = [ Line ]()
        for (index, v) in polygon.enumerated()
        {
            var first: CGPoint
            var second: CGPoint
            if index + 1 < polygon.count
            {
                first = v
                second = polygon[index + 1]
            }
            else
            {
                first = v
                second = polygon.first!
            }
            sides.append(Line(startPoint: first, endPoint: second))
        }
        return sides
    }
    
    // This is just to eliminate points that are way outside of the polygon.
    // If this function returns true the point must be further checked to
    // see that the point is not within a convex section of the polygon.
    static func isPointInBoundingBox(point: CGPoint, inPolygon: [CGPoint]) -> Bool
    {
        let (minX, maxX, minY, maxY) = getBoundingBox(forPolygon: inPolygon)
        if point.x < minX || point.x > maxX || point.y < minY || point.y > maxY
        {
            return false
        }
        return true
    }
    
    // The first test is to see if the point is at least within the bounding box.
    // This can eliminate some points quickly.
    static func getBoundingBox(forPolygon polygon: [CGPoint]) -> (CGFloat, CGFloat, CGFloat, CGFloat)
    {
        let minX = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let minY = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.y) })
        let maxX = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        let maxY = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.y) })
        return (minX, maxX, minY, maxY)
    }
    
    // Point is inside if a ray beginning just to the left of the polygon
    // and extending to just right of the point itself, intersects the sides
    // of the polygon an odd number of times.
    static func isPointInside(point: CGPoint, poly: [ CGPoint ]) -> Bool
    {
        if Line.isPointInBoundingBox(point: point, inPolygon: poly) == false
        {
            return false
        }
        let minRay: Line = Line.calcMinRay(fromClickPoint: point, andPolygon: poly)
        let sides: [ Line ] = Line.getSides(ofPolygon: poly)
        var collisions: Int = 0
        for side in sides
        {
            if Line.doesSideIntersectRay(side: side, ray: minRay) == true
            {
                collisions = collisions + 1
            }
        }
        if (collisions % 2) > 0
        {
            return true
        }
        return false
    }
    
    // The ray is drawn from a given point to just-left of the left side of the polygon.
    // The line is a side of the given polygon.
    static func doesSideIntersectRay(side: Line, ray: Line) -> Bool
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
            return true
        }
        return false
    }
}
