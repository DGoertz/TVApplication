import Foundation

extension Double
{
    public func toDegrees() -> Double
    {
        return self * (180 / Double.pi)
    }
    
    public func toRadians() -> Double
    {
        return self * (Double.pi / 180)
    }
}
