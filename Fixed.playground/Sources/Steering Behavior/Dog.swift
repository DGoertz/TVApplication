import Foundation
import CoreGraphics
import UIKit

public class Dog: MovingEntity
{
    public var name: String!
    
    public init()
    {
        let p0: CGPoint = CGPoint(x: 1, y: 1)
        let p1: CGPoint = CGPoint(x: 3, y: 0.75)
        let p2: CGPoint = CGPoint(x: 4, y: 0.75)
        let p3: CGPoint = CGPoint(x: 6, y: 1)
        let p4: CGPoint = CGPoint(x: 5, y: 3)
        let p5: CGPoint = CGPoint(x: 4, y: 5)
        let p6: CGPoint = CGPoint(x: 3, y: 5)
        let p7: CGPoint = CGPoint(x: 2, y: 3)
        let polygon = [ p0, p1, p2, p3, p4, p5, p6, p7 ]
        super.init(type: .Dog, position: CGPoint(x: 0, y: 0), hitPoints: 100, mass: 25, renderPoly: polygon, scale: 1, heading: Vector2D(x: 14, y: 12), velocity: Vector2D(x: 0, y: 0), maxVelocity: 25, maxForce: 25, maxTurnRate: 180,wanderDistance: 30, wanderRadius: 15, wanderJitter: 0.3)
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    public override var debugDescription: String
    {
        return "\(super.debugDescription). I'm a Dog!"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    public override var description: String
    {
        return "\(super.debugDescription). I'm a Dog!"
    }
}
