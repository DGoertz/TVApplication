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
    public var ID:                  String
    public var type:                EntityType
    public var position:            CGPoint
    public var hitPoints:           CGFloat
    public var mass:                CGFloat
    public var renderPolygon:       [ CGPoint ]
    public var scale:               CGFloat
    public var boundingRadius:      CGFloat
    
    public init(type: EntityType, position: CGPoint, hitPoints: CGFloat, mass: CGFloat, renderPoly: [ CGPoint ], scale: CGFloat)
    {
        self.ID = UUID().uuidString
        self.type = type
        self.position = position
        self.hitPoints = hitPoints
        self.mass = mass
        self.renderPolygon = renderPoly
        self.scale = scale
        self.boundingRadius = BaseEntity.calcBoundingRadius(ofPolygon: BaseEntity.applyScale(toPolygon: self.renderPolygon, withScale: self.scale))
    }
    
    static func applyScale(toPolygon polygon: [ CGPoint ], withScale scale: CGFloat) -> [ CGPoint ]
    {
        return polygon.map({ (item: CGPoint) in return CGPoint(x: item.x * scale, y: item.y * scale) })
    }
    
    static func calcBoundingRadius(ofPolygon polygon: [ CGPoint ]) -> CGFloat
    {
        let (minX, maxX, minY, maxY) = CGPoint.getBoundingBox(forPolygon: polygon)
        let width = maxX - minX
        let height = maxY - minY
        return (height > width) ? height: width
    }
    
    public func getRenderablePolygon() -> [ CGPoint ]
    {
        return BaseEntity.applyScale(toPolygon: self.renderPolygon, withScale: self.scale)
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
        print("Method render message must be overridden!")
        return nil
    }
}
