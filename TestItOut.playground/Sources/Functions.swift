import Foundation
import UIKit
import QuartzCore

// MARK: Graphic debug functions.

public func getView(size: CGSize, andColor: UIColor) -> UIView
{
    let windowFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let view = UIView(frame: windowFrame)
    view.backgroundColor = andColor
    return view
}

public func dot(at: CGPoint, withColor: UIColor, inHeight: CGFloat) -> CALayer
{
    let returnDot = CALayer()
    let plotDot: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 3, height: 3))
    returnDot.bounds = plotDot
    returnDot.cornerRadius = 2
    returnDot.backgroundColor = withColor.cgColor
    returnDot.position = CGPoint(x: at.x, y: inHeight - at.y)
    return returnDot
}

func getRandomColor(notThis: UIColor) -> UIColor
{
    let colorDomain: [ UIColor ] = [
        UIColor.brown, UIColor.black, UIColor.blue, UIColor.cyan, UIColor.darkGray, UIColor.gray, UIColor.green, UIColor.lightGray, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.red, UIColor.white, UIColor.yellow
    ]
    var dice: Int = 0
    repeat
    {
        dice = Int(arc4random_uniform(UInt32(colorDomain.count)))
    }
    while colorDomain[dice] == notThis
    return colorDomain[dice]
}

public func plotVectors(size: CGSize, vects: [Vector2D]) -> UIImage?
{
    UIGraphicsBeginImageContext(size)
    if let context = UIGraphicsGetCurrentContext()
    {
        context.setBlendMode(.normal)
        context.setLineWidth(1)
        var lastColor: UIColor = UIColor.brown
        for vect in vects
        {
            let strokeColor: UIColor = getRandomColor(notThis: lastColor)
            context.setStrokeColor(strokeColor.cgColor)
            context.move(to: CGPoint(x: 0, y: (size.height)))
            let correctedYCalc = size.height - vect.y
            context.addLine(to: CGPoint(x: vect.x, y: correctedYCalc))
            context.strokePath()
            lastColor = strokeColor
        }
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    return nil
}

