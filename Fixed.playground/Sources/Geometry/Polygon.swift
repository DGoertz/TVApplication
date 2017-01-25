import Foundation
import QuartzCore
import UIKit

public class Polygon
{
    var vertices: [ CGPoint ]
    var scale:    CGFloat
    var color:    UIColor
    
    public init(vertices: [ CGPoint ], scale: CGFloat, color: UIColor)
    {
        self.vertices = vertices
        self.scale = scale
        self.color = color
    }
    
    public func getBoundingBox() -> (CGFloat, CGFloat, CGFloat, CGFloat)
    {
        let minX = self.vertices.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let minY = self.vertices.reduce(CGFloat.greatestFiniteMagnitude, { min($0,$1.x) })
        let maxX = self.vertices.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        let maxY = self.vertices.reduce(CGFloat.leastNormalMagnitude, { max($0,$1.x) })
        return (minX, maxX, minY, maxY)
    }
    
    public func render(onTo image: UIImage) -> UIImage?
    {
        UIGraphicsBeginImageContext(image.size)
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setBlendMode(.normal)
            context.setLineWidth(1)
            context.setStrokeColor(self.color.cgColor)
            for (i,v) in vertices.enumerated()
            {
                if i == 0
                {
                    context.move(to: v)
                    continue
                }
                context.addLine(to: v)
            }
            context.addLine(to: vertices[0])
            context.strokePath()
            let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        return nil
    }
}
