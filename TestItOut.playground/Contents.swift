import UIKit
import Foundation
import PlaygroundSupport

import Foundation

struct Point : CustomStringConvertible
{
    var x: Int
    var y: Int
    
    var description: String
    {
        return "Pt:(x:\(self.x), y:\(self.y))"
    }
}

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

class SearchNode : Node
{
    var parent: SearchNode?
    var G:      Float
    var H:      Float
    
    var F: Float
    {
        return G + H
    }
    
    override var description: String
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

class Map: CustomStringConvertible
{
    let rows:       Int
    let columns:    Int
    var nodeMatrix: [ Node ]
    
    var description: String
    {
        return "Rows: \(rows) - Cols: \(columns) - \(nodeMatrix)"
    }
    
    func getStartNode() -> Node?
    {
        if let foundIndex = nodeMatrix.index(where: { $0.nodeContent == .Start })
        {
            return nodeMatrix[foundIndex]
        }
        return nil
    }
    
    func getEndNode() -> Node?
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

class Stack<T>
{
    var stack: [T]
    
    init()
    {
        self.stack = [T]()
    }
    
    func push(newItem: T) -> Void
    {
        stack.append(newItem)
    }
    
    func pop() -> T?
    {
        if stack.count > 0
        {
            return stack.removeLast()
        }
        else
        {
            return nil
        }
    }
}

class AStar
{
    var openList:   [ SearchNode ]
    var closedList: [ SearchNode ]
    var internalMap: Map
    
    init(numberOfRows: Int, numberOfColumns: Int, mapStencil: [String])
    {
        internalMap = Map(nRows: numberOfRows, nCols: numberOfColumns, mapStencil: mapStencil)
        self.openList = [ SearchNode ]()
        self.closedList = [ SearchNode ]()
    }
    
    func plot(nodes: [ SearchNode ]) -> [ String ]
    {
        let sortedNodes: [ SearchNode ] = nodes.sorted(by: { ($0.location.x < $1.location.x) && ($0.location.y < $1.location.y)})

        var nodeIndexes: [ Int ] = [ Int]()
        for currentNode in sortedNodes
        {
            if let indexInMap = self.internalMap.nodeMatrix.index(where: { (item) in return (item.location.x == currentNode.location.x && item.location.y == currentNode.location.y) })
            {
                nodeIndexes.append(indexInMap)
            }
            
        }
        var retMap: [ String ] = [ String ]()

        for (index,node) in self.internalMap.nodeMatrix.enumerated()
        {
            if index > 0 && index % self.internalMap.columns == 0
            {
                retMap.append("\n")
            }
            if nodeIndexes.contains(index)
            {
                if node.nodeContent == .Start
                {
                    retMap.append("S")
                }
                else if node.nodeContent == .End
                {
                    retMap.append("E")
                }
                else
                {
                    retMap.append("*")
                }
            }
            else
            {
                switch node.nodeContent {
                case .Clear:
                    retMap.append("=")
                case .Start:
                    retMap.append("S")
                case .End:
                    retMap.append("E")
                case .Wall:
                    retMap.append("W")
                case .Illegal:
                    retMap.append("!")
                }
            }
        }
        return retMap
    }
    
    func find(node: SearchNode, onList list: [ SearchNode ]) -> (SearchNode, Int)?
    {
        guard let foundIndex = list.index(where: { $0.location.x == node.location.x && $0.location.y == node.location.y })
            else
        {
            return nil
        }
        return (node, foundIndex)
    }
    
    class func findSmallestSearchNode(listOfNodes: [SearchNode]) -> (SearchNode?, Int?)
    {
        guard listOfNodes.count > 0
            else
        {
            return (nil, nil)
        }
        if listOfNodes.count == 1
        {
            return (listOfNodes[0], 0)
        }
        let smallestTileValue = listOfNodes.reduce(Float.greatestFiniteMagnitude, { min($0,$1.F) })
        guard let smallestIndex = listOfNodes.index(where: { $0.F == smallestTileValue })
            else
        {
            return (nil, nil)
        }
        return (listOfNodes[smallestIndex], smallestIndex)
    }
    
    class func buildPathFromEndingNode(lastNodeInPath: SearchNode) -> [SearchNode]
    {
        // Need to create stack and unwind it for results.
        var retVal: [SearchNode] = [SearchNode]()
        let workerStack: Stack = Stack<SearchNode>()
        workerStack.push(newItem: lastNodeInPath)
        var nextParent: SearchNode? = lastNodeInPath.parent
        var continueBigLoop: Bool = true
        repeat
        {
            if let nonNilParent = nextParent
            {
                workerStack.push(newItem: nonNilParent)
                nextParent = nonNilParent.parent
            }
            else
            {
                // Unwind an Array of Points and return.
                var poppingStack: Bool = true
                repeat
                {
                    let poppedValue = workerStack.pop()
                    if let realPoppedValue = poppedValue
                    {
                        retVal.append(realPoppedValue)
                    }
                    else
                    {
                        poppingStack = false
                    }
                }
                    while poppingStack == true
                continueBigLoop = false
            }
        }
            while (continueBigLoop)
        return retVal
    }
    
    func findPath(startPoint: Point, endPoint: Point) -> [SearchNode]?
    {
        let startNode: Node = Node(itsLocation: startPoint, itsContent: NodeContent.Start)
        let endNode: Node = Node(itsLocation: endPoint, itsContent: NodeContent.End)
        let initalDistance: Int = Map.distanceFrom(initialNode: startNode, anotherNode: endNode)
        let zero: Float = 0
        let initalPosition: SearchNode = SearchNode(itsLocation: startPoint, itsContent: NodeContent.Start, itsG: zero, itsH: Float(initalDistance), itsParent: nil)
        closedList.append(initalPosition)
        guard let hasInitialWalkableNodes = internalMap.getWalkableTilesRelativeTo(thisNode: initalPosition, givenDestinationNode: endNode)
        else
        {
            print("ERROR: No walkable nodes can be found from the Start Node!")
            return nil
        }
        for tile in hasInitialWalkableNodes
        {
            openList.append(tile)
        }
        // Main A-Star algorithm Loop.
        var done: Bool = false
        while done == false
        {
            let (smallestTileOnOpenList, smallestIndex) = AStar.findSmallestSearchNode(listOfNodes: openList)
            if let foundSmallestTileOnOpenList = smallestTileOnOpenList, let smallestIndex = smallestIndex
            {
                openList.remove(at: smallestIndex)
                closedList.append(foundSmallestTileOnOpenList)
                let walkableTiles: [SearchNode]? = internalMap.getWalkableTilesRelativeTo(thisNode: foundSmallestTileOnOpenList, givenDestinationNode: endNode)
                if let stillHasWalkableTiles = walkableTiles
                {
                    for t in 0..<stillHasWalkableTiles.count
                    {
                        if stillHasWalkableTiles[t].location.x == endPoint.x && stillHasWalkableTiles[t].location.y == endPoint.y
                        {
                            return AStar.buildPathFromEndingNode(lastNodeInPath: stillHasWalkableTiles[t])
                        }
                        else
                        {
                            
                            if let (foundOnClosedList, closedListIndex) = self.find(node: stillHasWalkableTiles[t], onList: self.closedList)
                            {
                                continue
                            }
                            else
                            {
                                
                                if let (alreadyOnOpenList, openListIndex) = self.find(node: stillHasWalkableTiles[t], onList: self.openList)
                                {
                                    if stillHasWalkableTiles[t].F < alreadyOnOpenList.F
                                    {
                                        openList.remove(at: openListIndex)
                                        openList.append(stillHasWalkableTiles[t])
                                    }
                                }
                                else
                                {
                                    openList.append(stillHasWalkableTiles[t])
                                }
                            }
                        }
                    }
                }
                else
                {
                    print("Ran out of Tiles and have not found the destination yet!")
                }
                
            }
            else
            {
                print("No smallest node. Out of nodes???????")
                done = true
            }
        }
        
        // Algorithm:
        // 1. Add "Start Postion" to the Closed List.
        // 2. Add all walkable Tiles relative to the "Start Postion" to the Open List.
        // 3. Get the lowest scored Tile from the Open List; call it "S".
        // 4. Remove "S" from the Open List and add it to the Closed List.
        // 5. Generate all walkable Tiles adjacent to "S" and iterate them:
        //    a. If the current Tile is the destination you are done but need to
        //       produce the path. Proceed to Produce Path.
        //    b. If the current Tile; call it "T" is on the Closed List ignore it.
        //    c. If "T" is NOT on the Open List then compute its score and add it.
        //    d. If "T" is already on the Open List then compute a new F using the G from
        //       the current path and compare it to the old F, if lower then update the G
        //       as well as the Parent since this will be a new path option.
        // 7. Loop to 3.
        
        // Produce Path:
        // 1. Create a Stack.
        // 2. Push the current Tile onto the Stack.
        // 3. Move to the Parent of the current Tile.
        // 4. If the parent is null then Pop through the stack adding the entries to a Node Array.
        // 5. If the parent is not null then Loop to 2.
        return nil
    }
    
}

let map: [String] = [
    "   SXE ",
    "    X  ",
    " XXX X ",
    "  X X  ",
    "       "]
let start: TimeInterval = NSDate.timeIntervalSinceReferenceDate
let rows: Int = map.count
let columns: Int = map[0].characters.count
let finder: AStar = AStar(numberOfRows: rows, numberOfColumns: columns, mapStencil: map)
let startPoint: Point = (finder.internalMap.getStartNode()?.location)!
let endPoint: Point = (finder.internalMap.getEndNode()?.location)!

let path: [SearchNode]? = finder.findPath(startPoint: startPoint, endPoint: endPoint)
if let foundPath = path
{
    print("Path has \(foundPath.count) nodes.")
    print("Path to follow is:")
    for i in 0..<foundPath.count
    {
        print("\(foundPath[i].location.x), \(foundPath[i].location.y)")
    }
    let displayMap: [ String ] = finder.plot(nodes: foundPath)
    print("\(displayMap)")
}
else
{
    print("No Path Found!")
}
let end: TimeInterval = NSDate.timeIntervalSinceReferenceDate

let diff = end - start
let seconds = (diff * 1000).truncatingRemainder(dividingBy: 1000)
print("Difference: \(diff) sec.")
// 0 "0123X  "
// 1 "0123X  "
// 2 "012X   "
// 3 "0123456"

//let pup: Dog = Dog()
//let manager: EntityManager = EntityManager.sharedInstance
//manager.register(entity: pup)
//
//let size: CGSize = CGSize(width: 100, height: 100)
//PlaygroundPage.current.needsIndefiniteExecution = true
//if let backingImage: UIImage = PlotFunctions.createBlankImage(ofSize: size)
//{
//    for nextID in manager.entites.keys
//    {
//        if let nextEntity = manager.entites[nextID]
//        {
//            var image: UIImage? = nextEntity.render(onto: backingImage)
//            let iView: UIImageView = UIImageView(image: image)
//            iView.backgroundColor = UIColor.blue
//            PlaygroundPage.current.liveView = iView
//        }
//    }
//}
//
