import Foundation
import CoreGraphics

public class MovingEntity : BaseEntity
{
    internal var normalizedHeading: Vector2D!
    public var currentVelocity:     Vector2D!
    public var maxVelocity:         CGFloat!
    public var maxForce:            CGFloat!
    public var maxTurnRate:         CGFloat!
    public var wanderDistance:      CGFloat!
    public var wanderRadius:        CGFloat!
    public var wanderJitter:        CGFloat!
    public var wanderTarget:        CGPoint!
    
    var heading: Vector2D?
        {
        set(newValue)
        {
            self.normalizedHeading = newValue?.normal()
        }
        get
        {
            return self.normalizedHeading
        }
    }
    
    var siding: Vector2D?
        {
        get
        {
            return self.normalizedHeading.perp
        }
    }
    
    init(type: EntityType, position: CGPoint, hitPoints: CGFloat, mass: CGFloat, renderPoly: [ CGPoint ], scale: CGFloat, heading: Vector2D, velocity: Vector2D, maxVelocity: CGFloat, maxForce: CGFloat, maxTurnRate: CGFloat, wanderDistance: CGFloat, wanderRadius: CGFloat, wanderJitter: CGFloat)
    {
        super.init(type: type, position: position, hitPoints: hitPoints, mass: mass, renderPoly: renderPoly, scale: scale)
        self.heading = heading
        self.currentVelocity = velocity
        self.maxVelocity = maxVelocity
        self.maxForce = maxForce
        self.maxTurnRate = maxTurnRate
        self.wanderDistance = wanderDistance
        self.wanderRadius = wanderRadius
        self.wanderJitter = wanderJitter
        // Need to calculate the initial value for wanderTarget.
    }

}
