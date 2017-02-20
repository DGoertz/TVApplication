import UIKit
import Foundation
import PlaygroundSupport

import Foundation

var a: BinaryStdIn = BinaryStdIn(fileName: "SearchTips", ext: "txt", readAhead: 100)
//for i in 0..<8
//{
//    print("\(a.readBoolean())")
//}
//a.close()
var asCChar: [CChar] = [CChar]()
var stringVersion: String
while a.isEmpty() == false
{
    asCChar.append(a.readChar())
}
let str: String = String(cString: &asCChar)
print("\(str)")
a.close()
