import Foundation
import UIKit

extension UIColor
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
}
