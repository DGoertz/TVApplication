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
    func collisionList(vehicle: MovingEntity) -> [ CGPoint ]?
    func renderOnto(image: UIImage) -> UIImage?
}

struct CircleBarrier: Barrier
{
    var type:             BarrierType
    var underlyingCircle: Circle
    var color:            UIColor
    
    init(center: CGPoint, radius: CGFloat, color: UIColor)
    {
        self.type = .Circle
        self.color = color
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
    
    func collisionList(vehicle: MovingEntity) -> [ CGPoint ]?
    {
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let localOrigin: CGPoint = underlyingCircle.boundingBox.origin * trans
        let halfDetectionHeight: CGFloat = detectionBox.height / 2
        let yHeight: CGFloat = localOrigin.y + underlyingCircle.radius + halfDetectionHeight
        if detectionBox.origin.y + detectionBox.height > yHeight
        {
            
        }
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingCircle.render(onTo: image)
    }
}

struct SquareBarrier: Barrier
{
    var type:              BarrierType
    var underlyingSquare : Square
    var color:             UIColor
    
    init(bottomLeft: CGPoint, width: CGFloat, height: CGFloat, color: UIColor)
    {
        self.type = .Square
        self.color = color
        self.underlyingSquare = Square(bottomLeft: bottomLeft, height: height, width: width, color: color)
    }
    
    func shouldTag(vehicle: MovingEntity) -> Bool
    {
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let localOrigin: CGPoint = underlyingSquare.bottomLeft * trans
        let localbox: CGRect = CGRect(origin: localOrigin, size: CGSize(width: underlyingSquare.width, height: underlyingSquare.height))
        return detectionBox.intersects(localbox)
    }
    
    func collisionList(vehicle: MovingEntity) -> [ CGPoint ]?
    {
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingSquare.render(onTo: image)
    }
}

struct PolygonBarrier: Barrier
{
    var type: BarrierType
    var underlyingPolygon: Polygon
    var color:             UIColor
    
    init(vertices: [ CGPoint ], color: UIColor)
    {
        self.type = .Polygon
        self.color = color
        self.underlyingPolygon = Polygon(vertices: vertices, scale: 1, color: color)
    }
    
    func shouldTag(vehicle: MovingEntity) -> Bool
    {
        let detectionBox: CGRect = vehicle.getDetectionBox()
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        let currentBoundingBox: CGRect = underlyingPolygon.getBoundingBox()
        let localOrigin: CGPoint = currentBoundingBox.origin * trans
        let localbox: CGRect = CGRect(origin: localOrigin, size: CGSize(width: currentBoundingBox.width, height: currentBoundingBox.height))
        return detectionBox.intersects(localbox)
    }
    
    func collisionList(vehicle: MovingEntity) -> [ CGPoint ]?
    {
        let trans: Matrix2D = Matrix2D.getCoorTranslation(heading: vehicle.heading, side: vehicle.siding, origin: vehicle.position)
        return nil
    }
    
    func renderOnto(image: UIImage) -> UIImage?
    {
        return underlyingPolygon.render(onTo: image)
    }
}
