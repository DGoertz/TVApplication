import UIKit
import Foundation
import PlaygroundSupport

import Foundation

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
let startPoint: Point = (finder.theMap.getStartNode()?.location)!
let endPoint: Point = (finder.theMap.getEndNode()?.location)!

let path: [SearchNode]? = finder.findPath(startPoint: startPoint, endPoint: endPoint)
if let foundPath = path
{
    print("Path has \(foundPath.count) nodes.")
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
