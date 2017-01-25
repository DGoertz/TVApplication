import Foundation
import QuartzCore
import UIKit

public class Square
{
    var bottomLeft: CGPoint
    var height:     CGFloat
    var width:      CGFloat
    var color:      UIColor
    
    public init(bottomLeft: CGPoint, height: CGFloat, width: CGFloat, color: UIColor)
    {
        self.bottomLeft = bottomLeft
        self.height = height
        self.width = width
        self.color = color
    }
    
    public func render(onTo image: UIImage) -> UIImage?
    {
        UIGraphicsBeginImageContext(image.size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(self.color.cgColor)
            context.move(to: self.bottomLeft)
            let br: CGPoint = CGPoint(x: self.bottomLeft.x + self.width, y: self.bottomLeft.y)
            context.addLine(to: br)
            let tr: CGPoint = CGPoint(x: self.bottomLeft.x + self.width, y: self.bottomLeft.y + self.height)
            context.addLine(to: tr)
            let tl: CGPoint = CGPoint(x: self.bottomLeft.x, y: self.bottomLeft.y + self.height)
            context.addLine(to: tl)
            context.addLine(to: bottomLeft)
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
