import Foundation
import UIKit

struct PolygonBarrier: Barrier
{
    var type: BarrierType
    var underlyingPolygon: Polygon
    
    init(vertices: [ CGPoint ], color: UIColor)
    {
        self.type = .Polygon
        self.underlyingPolygon = Polygon(vertices: vertices, scale: 1, color: color)
    }
    
    func shouldTag(vehicle: MovingEntity) -> Bool
    {
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let currentBoundingBox: CGRect = underlyingPolygon.getBoundingBox()
        let localBarrierOrigin: CGPoint = currentBoundingBox.origin * trans
        let localBarrierBox: CGRect = CGRect(origin: localBarrierOrigin, size: CGSize(width: currentBoundingBox.width, height: currentBoundingBox.height))
        return detectionBox.intersects(localBarrierBox)
    }
    
    func collisionPoint(vehicle: MovingEntity) -> CGPoint?
    {
        let vehicleDetectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let barrierBoundingBox: CGRect = underlyingPolygon.getBoundingBox()
        let localBarrierOrigin: CGPoint = barrierBoundingBox.origin * trans
        let localBarrierBox: CGRect = CGRect(origin: localBarrierOrigin, size: CGSize(width: barrierBoundingBox.width, height: barrierBoundingBox.height))
        if vehicleDetectionBox.intersects(localBarrierBox)
        {
            return vehicleDetectionBox.intersection(localBarrierBox).origin
        }
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingPolygon.render(onTo: image)
    }
}
