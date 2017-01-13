import Foundation

public struct Point : CustomStringConvertible
{
    var x: Int
    var y: Int
    
    public var description: String
    {
        return "Pt:(x:\(self.x), y:\(self.y))"
    }
}
