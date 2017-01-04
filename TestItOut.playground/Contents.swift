import UIKit
import Foundation
import PlaygroundSupport

let p0: CGPoint = CGPoint(x: 20, y: 30)
let p1: CGPoint = CGPoint(x: 20, y: 70)
let p2: CGPoint = CGPoint(x: 50, y: 80)
let p3: CGPoint = CGPoint(x: 70, y: 50)
let p4: CGPoint = CGPoint(x: 50, y: 40)
let p5: CGPoint = CGPoint(x: 50, y: 10)
let poly: [ CGPoint ] = [ p0, p1, p2, p3, p4, p5 ]

let clickPoint1: CGPoint = CGPoint(x: 40, y: 40)
let clickPoint2: CGPoint = CGPoint(x: 60, y: 50)
let clickPoint3: CGPoint = CGPoint(x: 50, y: 70)
let clickPoint4: CGPoint = CGPoint(x: 60, y: 43)

let testClick: CGPoint = clickPoint4

Line.isPointInside(point: testClick, poly: poly)
let size: CGSize = CGSize(width: 100, height: 100)
PlaygroundPage.current.needsIndefiniteExecution = true
let sides: [ Line ] = Line.getSides(ofPolygon: poly)
var image: UIImage? = PlotFunctions.plotLines(size: size,lines: sides, inColor: UIColor.red)
if let image = image
{
    let newImage: UIImage?  = PlotFunctions.addPlot(toImage: image, point: testClick, withColor: UIColor.yellow)
    let iView: UIImageView = UIImageView(image: newImage)
    iView.backgroundColor = UIColor.clear
    PlaygroundPage.current.liveView = iView
}

