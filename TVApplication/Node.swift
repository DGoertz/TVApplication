import Foundation

enum NodeContent: CustomStringConvertible
{
    case Wall, Clear, Illegal, Start, End
    
    func isWalkable() -> Bool
    {
        return self == NodeContent.Clear || self == NodeContent.Start || self == NodeContent.End
    }
    
    var description: String
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

class Node: Equatable, CustomStringConvertible
{
    var location:    Point
    var nodeContent: NodeContent
    
    init(itsLocation: Point, itsContent: NodeContent)
    {
        self.location = itsLocation
        self.nodeContent = itsContent
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool
    {
        return lhs.location.x == rhs.location.x &&
            lhs.location.y == rhs.location.y &&
            lhs.nodeContent == rhs.nodeContent
    }
    
    var description: String
    {
        return "Location: (x:\(self.location.x), y:\(self.location.y) - \(nodeContent)"
    }
}
