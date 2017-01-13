import Foundation
import CoreGraphics

class SteeringBehavior
{
    var entity: MovingEntity
    
    init(forEntity: MovingEntity)
    {
        self.entity = forEntity
    }
    
    public func getSeek(toTarget target: MovingEntity) -> Vector2D?
    {
        guard  let entityHeading = self.entity.heading, let targetHeading = target.heading
            else {
                print("getSeek failed since the Entity or Target has a nil Heading!")
                return nil
        }
        let vectorToTarget: Vector2D = Vector2D(x: target.position.x - self.entity.position.x, y: target.position.x - self.entity.position.x)
        let relativeHeadingAngle: CGFloat = entityHeading.angleBetween(v2: targetHeading)
        if relativeHeadingAngle < 0.95
        {
            return vectorToTarget.truncate(toMax: self.entity.maxVelocity)
        }
        return vectorToTarget - entityHeading
    }
}
