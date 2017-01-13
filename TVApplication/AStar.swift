import Foundation

class AStar
{
    var openList:   [ SearchNode ]
    var closedList: [ SearchNode ]
    var internalMap: Map
    
    public var theMap: Map
    {
        return internalMap
    }
    
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
    
    public func find(node: SearchNode, onList list: [ SearchNode ]) -> (SearchNode, Int)?
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
    
    public func findPath(startPoint: Point, endPoint: Point) -> [SearchNode]?
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
                            
                            if let (_, _) = self.find(node: stillHasWalkableTiles[t], onList: self.closedList)
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
