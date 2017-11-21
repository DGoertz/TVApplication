//
//  ViewController.swift
//  TVApplication
//
//  Created by David Goertz on 2016-12-23.
//  Copyright © 2016 David Goertz. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.testAStar()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testAStar()
    {
        let map: [String] = [
            "   SXE ",
            "    X  ",
            " XXX X ",
            "  X X  ",
            "       "]
        let start: TimeInterval = NSDate.timeIntervalSinceReferenceDate
        let rows: Int = map.count
        let columns: Int = map[0].count
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
        print("Difference: \(seconds) sec.")
    }
}
