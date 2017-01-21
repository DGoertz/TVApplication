import Foundation
import CoreGraphics

extension CGPoint
{
    public init(fromVector vect: Vector2D)
    {
        self.x = vect.x
        self.y = vect.y
    }
    
    public static func getBoundingBox(forPolygon polygon: [ CGPoint ]) -> (CGFloat, CGFloat, CGFloat, CGFloat)
    {
        let minX = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let minY = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let maxX = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        let maxY = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        return (minX, maxX, minY, maxY)
    }
    
    // Point is inside if a ray beginning just to the left of the polygon
    // and extending to just right of the point itself, intersects the sides
    // of the polygon an odd number of times.
    public static func isPointInside(point: CGPoint, poly: [ CGPoint ]) -> Bool
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
    
    public static func + (scaler: CGFloat, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: scaler + right.x, y: scaler + right.y)
    }
    
    public static func + (left: CGPoint, right: Vector2D) -> CGPoint
    {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
