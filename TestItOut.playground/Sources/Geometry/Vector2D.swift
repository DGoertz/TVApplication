import UIKit
import Foundation

public struct Vector2D: CustomStringConvertible, CustomDebugStringConvertible
{
    public var x: CGFloat
    public var y: CGFloat
    
    public init(x: CGFloat, y: CGFloat)
    {
        self.x = x
        self.y = y
    }
    
    public init()
    {
        self.x = 0
        self.y = 0
    }
    
    public init(fromVect: Vector2D)
    {
        self = Vector2D(x: fromVect.x, y: fromVect.y)
    }
    
    public init(fromStartPoint startPoint: CGPoint, toEndPoint endPoint: CGPoint)
    {
        self.x = endPoint.x - startPoint.x
        self.y = endPoint.y - startPoint.y
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    public var debugDescription: String
    {
        return "Vector(x: \(self.x), y: \(self.y))"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    
    public var description: String
    {
        return "Vector(x: \(self.x), y: \(self.y))"
    }
    
    public func isZero() -> Bool
    {
        return ((self.x * self.x) + (self.y * self.y)) < CGFloat.leastNonzeroMagnitude
    }
    
    public var length: CGFloat { return ((self.x * self.x) + (self.y * self.y)).squareRoot() }
    
    public var lengthSq: CGFloat { return ((self.x * self.x) + (self.y * self.y)) }
    
    public mutating func normalized()
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
    
    public func normal() -> Vector2D?
    {
        if self.length > CGFloat.leastNonzeroMagnitude
        {
            return Vector2D(x: self.x / self.length, y: self.y / self.length)
        }
        return nil
    }
    
    public var perp: Vector2D { return Vector2D(x: -1 * self.y, y: self.x) }
    
    public mutating func truncated(toMax max: CGFloat) -> Void
    {
        if self.length > max
        {
            self.x = (self.x / self.length) * max
            self.y = (self.y / self.length) * max
        }
    }
    
    public func truncate(toMax: CGFloat) -> Vector2D
    {
        if self.length > toMax
        {
            return Vector2D(x: (self.x / self.length) * toMax, y: (self.y / self.length) * toMax)
        }
        return self
    }
    
    public func reverse(of: Vector2D) -> Vector2D
    {
        return Vector2D(x: -1 * self.x, y: -1 * self.y)
    }
    
    public func distance(to: Vector2D) -> CGFloat
    {
        return Vector2D(x: self.x - to.x, y: self.y - to.y).length
    }
    
    public func distanceSq(to: Vector2D) -> CGFloat
    {
        return Vector2D(x: self.x - to.x, y: self.y - to.y).lengthSq
    }
    
    public func dot(v2: Vector2D) -> CGFloat
    {
        return (self.x * v2.x) + (self.y * v2.y)
    }
    
    public func isInFront(v2: Vector2D) -> Bool
    {
        return (self.dot(v2: v2) > 0)
    }
    
    // Since the dot product is: v1 dot v2 = |v1| |v2| cos(theta)
    public func angleBetween(v2: Vector2D) -> CGFloat
    {
        return acos(self.dot(v2: v2) / (self.length * v2.length))
    }
    
    // Actual formula is: |v1| |v2| sin(theta)
    public func cross(with v2: Vector2D) -> CGFloat
    {
        return (self.x * v2.y) - (v2.x * self.y)
    }
    
    // If I'm to the left then that is a (-) angle and therefore sin() is (-).
    public func toLeft(of v2: Vector2D) -> Bool
    {
        return self.cross(with: v2) < 0
    }
    
    public func toRight(of v2: Vector2D) -> Bool
    {
        return self.cross(with: v2) > 0
    }
    
    // MARK: Overloaded operators.
    
    static func - (left: Vector2D, right: Vector2D) -> Vector2D
    {
        return Vector2D(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func - (left: Vector2D, scaler: CGFloat) -> Vector2D
    {
        return Vector2D(x: left.x - scaler, y: left.y - scaler)
    }
    
    static func + (left: Vector2D, right: Vector2D) -> Vector2D
    {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func + (left: Vector2D, scaler: CGFloat) -> Vector2D
    {
        return Vector2D(x: left.x + scaler, y: left.y + scaler)
    }
    
    static func / (left: Vector2D, right: Vector2D) -> Vector2D
    {
        return Vector2D(x: left.x / right.x, y: left.y / right.y)
    }
    
    static func / (left: Vector2D, scaler: CGFloat) -> Vector2D
    {
        return Vector2D(x: left.x / scaler, y: left.y / scaler)
    }
    
    static func * (left: Vector2D, right: Vector2D) -> Vector2D
    {
        return Vector2D(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func * (left: Vector2D, scaler: CGFloat) -> Vector2D
    {
        return Vector2D(x: left.x * scaler, y: left.y * scaler)
    }
    
    static func * (scaler: CGFloat, left: Vector2D) -> Vector2D
    {
        return Vector2D(x: left.x * scaler, y: left.y * scaler)
    }
}


