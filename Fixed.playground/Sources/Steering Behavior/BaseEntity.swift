import Foundation
import CoreGraphics
import UIKit

public enum EntityType: CustomStringConvertible, CustomDebugStringConvertible
{
    case Man
    case Dog
    case Sheep
    case Coyote
    case Fence
    case Rock
    case Bridge
    case Creek
    
    public var description: String
    {
        switch self {
        case .Man:
            return "Man"
        case .Dog:
            return "Dog"
        case .Sheep:
            return "Sheep"
        case .Coyote:
            return "Coyote"
        case .Fence:
            return "Fence"
        case .Rock:
            return "Rock"
        case .Bridge:
            return "Bridge"
        case .Creek:
            return "Creek"
        }
    }
    
    public var debugDescription: String
    {
        switch self {
        case .Man:
            return "Man"
        case .Dog:
            return "Dog"
        case .Sheep:
            return "Sheep"
        case .Coyote:
            return "Coyote"
        case .Fence:
            return "Fence"
        case .Rock:
            return "Rock"
        case .Bridge:
            return "Bridge"
        case .Creek:
            return "Creek"
        }
    }
}

public class BaseEntity: CustomStringConvertible, CustomDebugStringConvertible
{
    public var ID:                  String!
    public var type:                EntityType!
    public var position:            CGPoint! // In world coordinates.
    public var hitPoints:           CGFloat!
    public var mass:                CGFloat!
    internal var itsPolygon:        Polygon!
    public var scale:               CGFloat!
    public var boundingRadius:      CGFloat!
    
    public var renderPolygon:       Polygon { return self.getRenderablePolygon() }
    
    public init(type: EntityType, position: CGPoint, hitPoints: CGFloat, mass: CGFloat, itsPoly: Polygon, scale: CGFloat)
    {
        self.ID = UUID().uuidString
        self.type = type
        self.position = position
        self.hitPoints = hitPoints
        self.mass = mass
        self.itsPolygon = itsPoly
        self.scale = scale
        self.boundingRadius = self.calcBoundingRadius()
    }
    
    func calcBoundingRadius() -> CGFloat
    {
        let polygon: Polygon = self.renderPolygon
        let bb = polygon.getBoundingBox()
        return (bb.height > bb.width) ? bb.height: bb.width
    }
    
    public func getRenderablePolygon() -> Polygon
    {
        let scaledVertices = self.itsPolygon.vertices.map({ (item: CGPoint) in return CGPoint(x: item.x * self.scale, y: item.y * self.scale) })
        return Polygon(vertices: scaledVertices, scale: 1)
    }
    
    // MARK: Conformance to CustomDebugStringConvertible.
    
    public var debugDescription: String
    {
        return "Entity ID:\(self.ID) Type: \(self.type))"
    }
    
    // MARK: Conformance to CustomStringConvertible.
    
    public var description: String
    {
        return "Entity ID:\(self.ID) Type: \(self.type))"
    }
    
    public func update() -> Void
    {
        // currentGoal.process()
        print("Method update must be overridden!")
    }
    
    public func handle(message: Telegram) -> HandleState
    {
        print("Method handle:message: must be overridden!")
        return .notHandled
    }
    
    public func render(onto image: UIImage) -> UIImage?
    {
        let scaledPolygon: Polygon = self.renderPolygon
        return scaledPolygon.render(onTo: image)
    }
}
