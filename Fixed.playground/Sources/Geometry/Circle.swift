import Foundation
import QuartzCore
import UIKit

public class Circle
{
    var center:      CGPoint
    var radius:      CGFloat
    var boundingBox: CGRect
    var color:       UIColor
    
    public init(center: CGPoint, radius: CGFloat, color: UIColor)
    {
        self.center = center
        self.radius = radius
        self.boundingBox = CGRect(origin: CGPoint(x: self.center.x - self.radius, y: self.center.y - self.radius), size: CGSize(width: self.radius, height: self.radius))
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
            let outline = CGPath(ellipseIn: self.boundingBox, transform: nil)
            context.addPath(outline)
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
