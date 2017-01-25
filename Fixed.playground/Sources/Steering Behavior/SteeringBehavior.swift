import Foundation
import CoreGraphics

enum Deceleration : CGFloat
{
    case slow   = 3
    case medium = 2
    case fast   = 1
}

class SteeringBehavior
{
    var entity: MovingEntity
    
    init(forEntity: MovingEntity)
    {
        self.entity = forEntity
    }
    
    public func getNextWanderTarget() -> CGPoint
    {
        // This will give us a domain of {-1...1}
        let dice1: CGFloat = CGFloat(arc4random_uniform(2)) - 1
        let dice2: CGFloat = CGFloat(arc4random_uniform(2)) - 1
        // Test out values of wanderJitter to mimic the personality of the animal.
        let deltaX: CGFloat = dice1 * self.entity.wanderJitter
        let deltaY: CGFloat = dice2 * self.entity.wanderJitter
        let newTarget: Vector2D = Vector2D(x: self.entity.wanderTarget.x + deltaX, y: self.entity.wanderTarget.y + deltaY)
        let targetOnCircle: CGPoint = CGPoint(x: newTarget.normal().x * self.entity.wanderRadius, y: newTarget.normal().y * self.entity.wanderRadius)
        return targetOnCircle
    }
    
    public func getWander() -> Vector2D?
    {
        self.entity.wanderTarget = self.getNextWanderTarget()
        // Throw the circle out front of the animal.
        let newSpot: Vector2D = Vector2D(x: self.entity.wanderDistance + self.entity.wanderTarget.x, y: self.entity.wanderDistance + self.entity.wanderTarget.y)
        // Now we need to convert this local coordinate to world coordinates and seek to it.
        let rot: Matrix2D = Matrix2D.getRotation(heading: self.entity.heading, side: self.entity.siding)
        let trans: Matrix2D = Matrix2D.getTranslation(tx: self.entity.position.x, ty: self.entity.position.y)
        let comp: Matrix2D = trans * rot
        let worldTarget = newSpot * comp
        return getSeek(toTarget: worldTarget)
    }
    
    public func getEvade(toTarget target: MovingEntity) -> Vector2D?
    {
        // Same as pursuit except we flee from that point.
        let vectorToTarget: Vector2D = Vector2D(x: target.position.x - self.entity.position.x, y: target.position.y - self.entity.position.y)
        var timeInFuture = vectorToTarget.length / ((self.entity.currentVelocity + target.currentVelocity)).length
        timeInFuture = timeInFuture + self.timeToTurn(fromPoint: self.entity.position, toPoint: target.position)
        let pointToSeek: CGPoint = target.position + (timeInFuture * target.currentVelocity)
        return getFlee(toTarget: Vector2D(x: pointToSeek.x, y: pointToSeek.y))
    }
    
    public func getPursuit(toTarget target: MovingEntity) -> Vector2D?
    {
        let vectorToTarget: Vector2D = Vector2D(x: target.position.x - self.entity.position.x, y: target.position.y - self.entity.position.y)
        let relativeHeadingAngle: CGFloat = self.entity.heading.angleBetween(v2: target.heading)
        let clampedVectorToTarget = vectorToTarget.truncate(toMax: self.entity.maxVelocity)
        // Headings are in local space therefore heading that face each other are basically
        // the inversion of the other - or close to it.  Therefore rather than comparing
        // the inverted heading of the target we compare against -0.95
        if clampedVectorToTarget.isInFront(v2: self.entity.heading) && relativeHeadingAngle < -0.95
        {
            // Almost facing so just go there.
            return clampedVectorToTarget
        }
        // Point to seek to is where the target will be at some future time.
        // That time is directly related to the distance to target but inversely
        // proportional to the speeds of both the chaser and chasee.
        var timeInFuture = vectorToTarget.length / ((self.entity.currentVelocity + target.currentVelocity)).length
        // We may have to extend the time to take into consideration how much we have
        // to turn in order to align with what we are chasing.
        timeInFuture = timeInFuture + self.timeToTurn(fromPoint: self.entity.position, toPoint: target.position)
        let pointToSeek: CGPoint = target.position + (timeInFuture * target.currentVelocity)
        return getSeek(toTarget: Vector2D(x: pointToSeek.x, y: pointToSeek.y))
    }
    
    func timeToTurn(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat
    {
        let toTargetNormal: Vector2D = Vector2D(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y).normal()
        // Since the 2 vectors are normalized then the dot product will just be the
        // cos of the angle between the two.
        let cosBetween: CGFloat = toTargetNormal.dot(v2: self.entity.heading)
        let fudgeFactor: CGFloat = 0.5
        // The worst case is that the two vehicles are going in opposite directions (in which
        // case) the cos will be -1.  The best case is that they are at 0 degrees from
        // each other, or a cos of 1.
        // The following will then return a worst case of 1 and a best of 0.
        let time = (cosBetween - 1) * -fudgeFactor
        return time
    }
    
    public func arrive(toTarget target: Vector2D, deceleration: Deceleration) -> Vector2D?
    {
        let vectorToTarget: Vector2D = Vector2D(x: target.x - self.entity.position.x, y: target.y - self.entity.position.y)
        let distanceToTarget = vectorToTarget.length
        if distanceToTarget > 0
        {
            let tweeker: CGFloat = 1 / 3
            // slow:   3 * (1/3) = 1
            // medium: 2 * (1/3) = 2/3
            // fast:   1 * (1/3) = 1/3
            // So distance to go is divided up by 1, 2/3 or 1/3.
            // Since velocity = distance / time this term represents time.
            // slow:   distance / 1 =     distance
            // medium: distance / (2/3) = 3/2 * distance
            // fast:   3 * distance =     3 * distance
            // Think of this as the "Arrive Factor".
            let clampedSpeed = min((distanceToTarget / (deceleration.rawValue * tweeker)),self.entity.maxVelocity)
            // Test this and then change because I notice that:
            // speed = (distance / Arrive Factor)
            // Then substitute what speed is equal to and you see ...
            // velocity = (distance / Arrive Factor) / distance - which reduces to
            // just Arrive Factor????
            let desiredVelocity = vectorToTarget * (clampedSpeed / distanceToTarget)
            return desiredVelocity - self.entity.currentVelocity
        }
        return nil
    }
    
    public func getFlee(toTarget target: Vector2D) -> Vector2D?
    {
        let vectorAwayFromTarget: Vector2D = Vector2D(x: self.entity.position.x - target.x, y: self.entity.position.y - target.y)
        let desiredVelocity = vectorAwayFromTarget.truncate(toMax: self.entity.maxVelocity)
        return desiredVelocity - self.entity.currentVelocity
    }
    
    public func getSeek(toTarget target: Vector2D) -> Vector2D?
    {
        let vectorToTarget: Vector2D = Vector2D(x: target.x - self.entity.position.x, y: target.y - self.entity.position.y)
        let desiredVelocity = vectorToTarget.truncate(toMax: self.entity.maxVelocity)
        // Difference of where we want to go to where we are going.
        return desiredVelocity - self.entity.currentVelocity
    }
}
