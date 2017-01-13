import Foundation

public class Map: CustomStringConvertible
{
    let rows:       Int
    let columns:    Int
    var nodeMatrix: [ Node ]
    
    public var description: String
    {
        return "Rows: \(rows) - Cols: \(columns) - \(nodeMatrix)"
    }
    
    public func getStartNode() -> Node?
    {
        if let foundIndex = nodeMatrix.index(where: { $0.nodeContent == .Start })
        {
            return nodeMatrix[foundIndex]
        }
        return nil
    }
    
    public func getEndNode() -> Node?
    {
        if let foundIndex = nodeMatrix.index(where: { $0.nodeContent == .End })
        {
            return nodeMatrix[foundIndex]
        }
        return nil
    }
    
    init(nRows: Int, nCols: Int, mapStencil: [String])
    {
        self.rows = nRows
        self.columns = nCols
        self.nodeMatrix = [Node]()
        var col: Int = 0
        for r in 0..<self.rows
        {
            let currentRowString: String = mapStencil[r]
            col = 0
            for c in currentRowString.characters
            {
                let currentLocation: Point = Point(x: col, y: r)
                switch c
                {
                case "S":
                    nodeMatrix.append(Node(itsLocation: currentLocation, itsContent: NodeContent.Start))
                case "E":
                    nodeMatrix.append(Node(itsLocation: currentLocation, itsContent: NodeContent.End))
                case "X":
                    nodeMatrix.append(Node(itsLocation: currentLocation, itsContent: NodeContent.Wall))
                case " ":
                    nodeMatrix.append(Node(itsLocation: currentLocation,  itsContent: NodeContent.Clear))
                default:
                    nodeMatrix.append(Node(itsLocation: currentLocation, itsContent: NodeContent.Illegal))
                }
                col += 1
            }
        }
    }
    
    // This would be the Heuristic!
    class func distanceFrom(initialNode: Node, anotherNode: Node) -> Int
    {
        return abs(anotherNode.location.y - initialNode.location.y) +
            abs(anotherNode.location.x - initialNode.location.x)
    }
    
    func getWalkableTilesRelativeTo(thisNode: SearchNode, givenDestinationNode: Node) -> [SearchNode]?
    {
        var retVal: [ SearchNode ] = [ SearchNode ]()
        
        let isEastPossible: Bool = (thisNode.location.x + 1) < self.columns
        let isWestPossible: Bool = (thisNode.location.x - 1) > -1 && (thisNode.location.x - 1) < self.columns
        let isSouthPossible: Bool = (thisNode.location.y + 1) < self.rows
        let isNorthPossible: Bool = (thisNode.location.y - 1) > -1 && (thisNode.location.y - 1) < self.rows
        
        // Only movements along X & Y Axis are being considered.
        if isEastPossible == true
        {
            let moveEastIndex: Int = (thisNode.location.y * self.columns) + (thisNode.location.x + 1)
            let eastTile: Node = self.nodeMatrix[moveEastIndex]
            if eastTile.nodeContent.isWalkable()
            {
                let hFromHere: Int = Map.distanceFrom(initialNode: eastTile, anotherNode: givenDestinationNode)
                retVal.append(SearchNode(itsLocation: eastTile.location, itsContent: eastTile.nodeContent, itsG: thisNode.G + 1, itsH: Float(hFromHere), itsParent: thisNode))
            }
        }
        
        if isWestPossible == true
        {
            let moveWestIndex: Int = (thisNode.location.y * self.columns) + (thisNode.location.x - 1)
            let westTile: Node = self.nodeMatrix[moveWestIndex]
            if westTile.nodeContent.isWalkable()
            {
                let hFromHere: Int = Map.distanceFrom(initialNode: westTile, anotherNode: givenDestinationNode)
                retVal.append(SearchNode(itsLocation: westTile.location, itsContent: westTile.nodeContent, itsG: thisNode.G + 1, itsH: Float(hFromHere), itsParent: thisNode))
            }
        }
        
        if isNorthPossible == true
        {
            let moveNorthIndex: Int = ((thisNode.location.y - 1) * self.columns) + thisNode.location.x
            let northTile: Node = self.nodeMatrix[moveNorthIndex]
            if northTile.nodeContent.isWalkable()
            {
                let hFromHere: Int = Map.distanceFrom(initialNode: northTile, anotherNode: givenDestinationNode)
                retVal.append(SearchNode(itsLocation: northTile.location, itsContent: northTile.nodeContent, itsG: thisNode.G + 1, itsH: Float(hFromHere), itsParent: thisNode))
            }
        }
        
        if isSouthPossible == true
        {
            let moveSouthIndex: Int = ((thisNode.location.y + 1) * self.columns) + thisNode.location.x
            let southTile: Node = self.nodeMatrix[moveSouthIndex]
            if southTile.nodeContent.isWalkable()
            {
                let hFromHere: Int = Map.distanceFrom(initialNode: southTile, anotherNode: givenDestinationNode)
                retVal.append(SearchNode(itsLocation: southTile.location, itsContent: southTile.nodeContent, itsG: thisNode.G + 1, itsH: Float(hFromHere), itsParent: thisNode))
            }
        }
        return retVal
    }
}
