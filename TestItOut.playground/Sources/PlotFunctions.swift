import Foundation
import UIKit
import QuartzCore

public class PlotFunctions
{
    public static func getRandomColor(notThis: UIColor) -> UIColor
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
    
    public static func plotVectors(size: CGSize, vects: [Vector2D]) -> UIImage?
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
                context.move(to: CGPoint(x: 0, y: size.height))
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

    public static func plotUniqueLines(size: CGSize, lines: [Line]) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            var lastColor: UIColor = UIColor.brown
            for line in lines
            {
                let strokeColor: UIColor = PlotFunctions.getRandomColor(notThis: lastColor)
                context.setStrokeColor(strokeColor.cgColor)
                context.move(to: CGPoint(x: line.startPoint.x, y: size.height - line.startPoint.y))
                context.addLine(to: CGPoint(x: line.endPoint.x, y: size.height - line.endPoint.y))
                context.strokePath()
                lastColor = strokeColor
            }
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
    
    public static func plotLines(size: CGSize, lines: [Line], inColor color: UIColor) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(color.cgColor)
            for line in lines
            {
                context.move(to: CGPoint(x: line.startPoint.x, y: line.startPoint.y))
                context.addLine(to: CGPoint(x: line.endPoint.x, y: line.endPoint.y))
                context.strokePath()
            }
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
    
    public static func addPlot(toImage: UIImage, point: CGPoint, withColor color: UIColor) -> UIImage?
    {
        let size = toImage.size
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext()
        {
            let originalArea: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            context.draw(toImage.cgImage!, in: originalArea)
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(color.cgColor)
            let plotLocation: CGPoint = CGPoint(x: point.x, y: size.height - point.y)
            let spotSize: CGSize = CGSize(width: 3, height: 3)
            let plotPoint: CGRect = CGRect(origin: plotLocation, size: spotSize)
            let plotPath: CGPath = UIBezierPath(roundedRect: plotPoint, cornerRadius: 3).cgPath
            context.addPath(plotPath)
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
