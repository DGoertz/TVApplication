import Foundation
import QuartzCore
import UIKit

public struct Line: CustomStringConvertible, CustomDebugStringConvertible
{
    public var startPoint: CGPoint
    public var endPoint: CGPoint
    
    public init(startPoint: CGPoint, endPoint: CGPoint)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
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
    
    // Line equations must cross but also be within the interval of the ray.
    public static func doesSideIntersectRay(side: Line, ray: Line) -> Bool
    {
        // Calculate first equation: y1 = m1 X x1 + b1
        let m1: CGFloat = (side.endPoint.y - side.startPoint.y) / (side.endPoint.x - side.startPoint.x)
        // Transformations to show equation to solve b:
        // y = mx + b
        // -b = -y + mx
        // b = y - mx
        // Calculate b-intersept for first equation: b1 = y1 - (m1 X x1)
        let b1: CGFloat = side.startPoint.y - (m1 * side.startPoint.x)
        
        // Calculate second equation: y2 = m2 X x2 + b2
        let m2: CGFloat = (ray.endPoint.y - ray.startPoint.y) / (ray.endPoint.x - ray.startPoint.x)
        // Calculate b-intersept for second equation: b2 = y2 - (m2 X x2)
        let b2: CGFloat = ray.startPoint.y - (m2 * ray.startPoint.x)
        
        // Intersection point:
        let y = (((m2 * b1) - (m1 * b2)) / (m2 - m1))
        let x = (y - b1) / m1
        if x.isNormal && y.isNormal
        {
            if x < ray.startPoint.x || x > ray.endPoint.x
            {
                return false
            }
            print("Line 1: \(side) & Line 2: \(ray) intersect at (\(x),\(y))!")
            return true
        }
        return false
    }
    
    // Ray begins to the left of the bounding box and extends to just right
    // of the point.
    public static func calcMinRay(fromPoint point: CGPoint, andPolygon polygon: [CGPoint]) -> Line
    {
        let startX = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let startPoint: CGPoint = CGPoint(x: startX - CGFloat.leastNormalMagnitude, y: point.y)
        let endX: CGFloat = point.x + CGFloat.leastNormalMagnitude
        let endPoint: CGPoint = CGPoint(x: endX, y: point.y)
        return Line(startPoint: startPoint, endPoint: endPoint)
    }
    
    // Produce an array of Lines that represent the sides of the polygon.an
    // Notice that the sides form a closed polygon.
    public static func getSides(ofPolygon polygon: [CGPoint]) -> [ Line ]
    {
        var sides: [ Line ] = [ Line ]()
        for (index, v) in polygon.enumerated()
        {
            var first: CGPoint = CGPoint(x: 0, y: 0)
            var second: CGPoint = CGPoint(x: 0, y: 0)
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
    public static func isPointInBoundingBox(point: CGPoint, inPolygon: [CGPoint]) -> Bool
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
    public static func getBoundingBox(forPolygon polygon: [CGPoint]) -> (CGFloat, CGFloat, CGFloat, CGFloat)
    {
        let minX = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let minY = polygon.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let maxX = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        let maxY = polygon.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        return (minX, maxX, minY, maxY)
    }
    
    // Point is inside if a ray beginning just to the left of the polygon
    // and extending to just right of the point itself intersects the sides
    // of the polygon an odd number of times.
    public static func isPointInside(point: CGPoint, poly: [ CGPoint ]) -> Bool
    {
        if Line.isPointInBoundingBox(point: point, inPolygon: poly) == false
        {
            return false
        }
        let minRay: Line = Line.calcMinRay(fromPoint: point, andPolygon: poly)
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
    
    public static func getRandomColor(notThis: UIColor) -> UIColor
    {
        let colorDomain: [ UIColor ] = [
            UIColor.brown, UIColor.black, UIColor.blue, UIColor.cyan, UIColor.darkGray, UIColor.gray, UIColor.green, UIColor.lightGray, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.red, UIColor.white, UIColor.yellow
        ]
        var dice: Int = 0
        repeat
        {
            dice = Int(arc4random_uniform(UInt32(colorDomain.count)))
        }
            while colorDomain[dice] == notThis
        return colorDomain[dice]
    }
    
    public static func plotUniqueLines(size: CGSize, lines: [Line]) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            var lastColor: UIColor = UIColor.brown
            for line in lines
            {
                let strokeColor: UIColor = Line.getRandomColor(notThis: lastColor)
                context.setStrokeColor(strokeColor.cgColor)
                context.move(to: CGPoint(x: line.startPoint.x, y: (size.height - line.startPoint.y)))
                context.addLine(to: CGPoint(x: line.endPoint.x, y: (size.height - line.endPoint.y)))
                context.strokePath()
                lastColor = strokeColor
            }
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
    
    public static func plotLines(size: CGSize, lines: [Line], inColor color: UIColor) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(color.cgColor)
            for line in lines
            {
                context.move(to: CGPoint(x: line.startPoint.x, y: (size.height - line.startPoint.y)))
                context.addLine(to: CGPoint(x: line.endPoint.x, y: (size.height - line.endPoint.y)))
                context.strokePath()
            }
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
    
    public static func addPlot(toImage: UIImage, point: CGPoint, withColor color: UIColor) -> UIImage?
    {
        let size = toImage.size
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            let originalArea: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            context.draw(toImage.cgImage!, in: originalArea)
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(color.cgColor)
            let plotLocation: CGPoint = CGPoint(x: point.x, y: size.height - point.y)
            let spotSize: CGSize = CGSize(width: 3, height: 3)
            let plotPoint: CGRect = CGRect(origin: plotLocation, size: spotSize)
            let plotPath: CGPath = UIBezierPath(roundedRect: plotPoint, cornerRadius: 3).cgPath
            context.addPath(plotPath)
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
