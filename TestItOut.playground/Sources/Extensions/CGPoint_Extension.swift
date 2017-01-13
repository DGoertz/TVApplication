import Foundation
import CoreGraphics

extension CGPoint
{
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
}