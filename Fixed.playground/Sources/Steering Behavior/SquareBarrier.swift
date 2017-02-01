import Foundation
import UIKit

struct SquareBarrier: Barrier
{
    var type:              BarrierType
    var underlyingSquare : Square
    
    init(bottomLeft: CGPoint, width: CGFloat, height: CGFloat, color: UIColor)
    {
        self.type = .Square
        self.underlyingSquare = Square(bottomLeft: bottomLeft, height: height, width: width, color: color)
    }
    
    func shouldTag(vehicle: MovingEntity) -> Bool
    {
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let localBarrierOrigin: CGPoint = underlyingSquare.bottomLeft * trans
        let localBarrierBox: CGRect = CGRect(origin: localBarrierOrigin, size: CGSize(width: underlyingSquare.width, height: underlyingSquare.height))
        return detectionBox.intersects(localBarrierBox)
    }
    
    func collisionPoint(vehicle: MovingEntity) -> CGPoint?
    {
        let vehicleDetectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let localBarrierOrigin: CGPoint = underlyingSquare.bottomLeft * trans
        let localBarrierBox: CGRect = CGRect(origin: localBarrierOrigin, size: CGSize(width: underlyingSquare.width, height: underlyingSquare.height))
        if vehicleDetectionBox.intersects(localBarrierBox)
        {
            return vehicleDetectionBox.intersection(localBarrierBox).origin
        }
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingSquare.render(onTo: image)
    }
}
