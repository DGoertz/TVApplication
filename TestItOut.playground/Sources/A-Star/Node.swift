import Foundation

public enum NodeContent: CustomStringConvertible
{
    case Wall, Clear, Illegal, Start, End
    
    func isWalkable() -> Bool
    {
        return self == NodeContent.Clear || self == NodeContent.Start || self == NodeContent.End
    }
    
    public var description: String
    {
        switch self {
        case .Wall:
            return "Wall"
        case .Clear:
            return "Clear"
        case .Illegal:
            return "Illegal"
        case .Start:
            return "Start"
        case .End:
            return "End"
        }
    }
}

public class Node: Equatable, CustomStringConvertible
{
    public var location:    Point
    public var nodeContent: NodeContent
    
    init(itsLocation: Point, itsContent: NodeContent)
    {
        self.location = itsLocation
        self.nodeContent = itsContent
    }
    
    public static func == (lhs: Node, rhs: Node) -> Bool
    {
        return lhs.location.x == rhs.location.x &&
            lhs.location.y == rhs.location.y &&
            lhs.nodeContent == rhs.nodeContent
    }
    
    public var description: String
    {
        return "Location: (x:\(self.location.x), y:\(self.location.y) - \(nodeContent)"
    }
}
