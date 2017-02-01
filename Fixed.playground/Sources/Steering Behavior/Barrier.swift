import Foundation
import UIKit

enum BarrierType
{
    case Circle
    case Square
    case Polygon
}

protocol Barrier
{
    func shouldTag(vehicle: MovingEntity) -> Bool
    func collisionPoint(vehicle: MovingEntity) -> CGPoint?
    func renderOnto(image: UIImage) -> UIImage?
}
