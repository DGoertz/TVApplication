import Foundation

public class SearchNode : Node
{
    var parent: SearchNode?
    var G:      Float
    var H:      Float
    
    var F: Float
    {
        return G + H
    }
    
    override public var description: String
    {
        return "G = \(G) H = \(H) - (x:\(location.x), y:\(location.y)) - Node Content: \(nodeContent)"
    }
    
    init(itsLocation: Point, itsContent: NodeContent, itsG: Float, itsH: Float, itsParent: SearchNode?)
    {
        self.G = itsG
        self.H = itsH
        self.parent = itsParent
        super.init(itsLocation: itsLocation, itsContent: itsContent)
    }
    
    static func ==(lhs: SearchNode, rhs: SearchNode) -> Bool
    {
        if lhs.parent == rhs.parent &&
            lhs.G == rhs.G &&
            lhs.H == rhs.H
        {
            return true
        }
        return false
    }
}
