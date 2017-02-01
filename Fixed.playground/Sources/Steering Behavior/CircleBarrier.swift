import Foundation
import UIKit

struct CircleBarrier: Barrier
{
    var type:             BarrierType
    var underlyingCircle: Circle
    
    init(center: CGPoint, radius: CGFloat, color: UIColor)
    {
        self.type = .Circle
        self.underlyingCircle = Circle(center: center, radius: radius, color: color)
    }
    
    func shouldTag(vehicle: MovingEntity) -> Bool
    {
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let localOrigin: CGPoint = underlyingCircle.boundingBox.origin * trans
        let localbox: CGRect = CGRect(origin: localOrigin, size: underlyingCircle.boundingBox.size)
        return detectionBox.intersects(localbox)
    }
    
    func collisionPoint(vehicle: MovingEntity) -> CGPoint?
    {
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let vehicleDetectionBox: CGRect = vehicle.getDetectionBox()
        let localBarrierOrigin: CGPoint = underlyingCircle.boundingBox.origin * trans
        let halfDetectionHeight: CGFloat = vehicleDetectionBox.height / 2
        let barrierHeight: CGFloat = localBarrierOrigin.y + underlyingCircle.radius + halfDetectionHeight
        if barrierHeight > vehicleDetectionBox.origin.y + halfDetectionHeight
        {
            // (x-Cx)2 + (y-Cy)2 = r2
            // (x-Cx)2 + (0-Cy)2 = r2
            // (x-Cx)2 + Cy2     = r2
            // (x-Cx)2           = r2 - Cy2
            //  x-Cx             = sqrt(r2 - Cy2)
            //  x                = Cx +/- sqrt(r2 - Cy2)
            let rSquared: CGFloat = underlyingCircle.radius * underlyingCircle.radius
            let cySquared: CGFloat = underlyingCircle.center.y * underlyingCircle.center.y
            let xLow = localBarrierOrigin.x - sqrt(rSquared - cySquared)
            let xHigh = localBarrierOrigin.x + sqrt(rSquared - cySquared)
            let ptOne: CGPoint = CGPoint(x: xLow, y: vehicleDetectionBox.origin.y)
            let ptTwo: CGPoint = CGPoint(x: xHigh, y: vehicleDetectionBox.origin.y)
            if xLow > vehicleDetectionBox.origin.x
            {
                return ptOne
            }
            if xHigh > vehicleDetectionBox.origin.x
            {
                return ptTwo
            }
            return nil
        }
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingCircle.render(onTo: image)
    }
}
