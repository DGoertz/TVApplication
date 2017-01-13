import UIKit
import Foundation

struct Vector2D: CustomStringConvertible
{
    var x: CGFloat
    var y: CGFloat
    
    init(x: CGFloat, y: CGFloat)
    {
        self.x = x
        self.y = y
    }
    
    init()
    {
        self.x = 0
        self.y = 0
    }
    
    init(fromVect: Vector2D)
    {
        self = Vector2D(x: fromVect.x, y: fromVect.y)
    }
    
    init(fromStartPoint startPoint: CGPoint, andEndPoint endPoint: CGPoint)
    {
        self.x = endPoint.x - startPoint.x
        self.y = endPoint.y - startPoint.y
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    var debugDescription: String
    {
        return "Vector(x: \(self.x), y: \(self.y))"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    
    var description: String
    {
        return "Vector(x: \(self.x), y: \(self.y))"
    }
    
    func isZero() -> Bool
    {
        return ((self.x * self.x) + (self.y * self.y)) < CGFloat.leastNonzeroMagnitude
    }
    
    var length: CGFloat { return ((self.x * self.x) + (self.y * self.y)).squareRoot() }
    
    var lengthSq: CGFloat { return ((self.x * self.x) + (self.y * self.y)) }
    
    mutating func normalized()
    {
        if self.length > CGFloat.leastNonzeroMagnitude
        {
            self.x = self.x / self.length
            self.y = self.y / self.length
        }
        else
        {
            self.x = 0
            self.y = 0
        }
    }
    
    func normal() -> Vector2D?
    {
        if self.length > CGFloat.leastNonzeroMagnitude
        {
            return Vector2D(x: self.x / self.length, y: self.y / self.length)
        }
        return nil
    }
    
    var perp: Vector2D { return Vector2D(x: -1 * self.y, y: self.x) }
    
    mutating func truncated(toMax max: CGFloat) -> Void
    {
        if self.length > max
        {
            self.x = (self.x / self.length) * max
            self.y = (self.y / self.length) * max
        }
    }
    
    func truncate(toMax: CGFloat) -> Vector2D?
    {
        if self.length > toMax
        {
            return Vector2D(x: (self.x / self.length) * toMax, y: (self.y / self.length) * toMax)
        }
        return nil
    }
    
    func reverse(of: Vector2D) -> Vector2D
    {
        return Vector2D(x: -1 * self.x, y: -1 * self.y)
    }
    
    func distance(to: Vector2D) -> CGFloat
    {
        return Vector2D(x: self.x - to.x, y: self.y - to.y).length
    }
    
    func distanceSq(to: Vector2D) -> CGFloat
    {
        return Vector2D(x: self.x - to.x, y: self.y - to.y).lengthSq
    }
    
    func dot(v2: Vector2D) -> CGFloat
    {
        return (self.x * v2.x) + (self.y * v2.y)
    }
    
    func isInFront(v2: Vector2D) -> Bool
    {
        return (self.dot(v2: v2) > 0)
    }
    
    func angleBetween(v2: Vector2D) -> CGFloat
    {
        return acos(self.dot(v2: v2) / (self.length * v2.length))
    }
    
    func cross(with v2: Vector2D) -> CGFloat
    {
        return (self.x * v2.y) - (v2.x * self.y)
    }
    
    func toLeft(of v2: Vector2D) -> Bool
    {
        return self.cross(with: v2) < 0
    }
    
    func toRight(of v2: Vector2D) -> Bool
    {
        return self.cross(with: v2) > 0
    }
}
