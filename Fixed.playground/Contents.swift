import UIKit
import Foundation
import PlaygroundSupport

var br: BitRegister = BitRegister(size: 32)
br.setBit(bitColumn: 16)
br.setBit(bitColumn: 5)
print("\(br)")
print("\(br.isSet(bitColumn: 15))")


