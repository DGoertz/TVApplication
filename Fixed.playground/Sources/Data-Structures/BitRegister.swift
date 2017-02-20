import Foundation

public struct BitRegister: CustomStringConvertible
{
    // This register is oriented as you would expect 0th bit is at the extreme right end.
    var maxBitColumn: Int
    var register: [UInt8]
    
    public var description: String
    {
        var retString: String = "|"
        for i in 0..<register.count
        {
            for col in 0..<8
            {
                let j = (8 - col) - 1
                let mask: UInt8 = 0x01 << UInt8(j)
                let currentValue: String = (register[i] & mask) != 0 ? "1" : "0"
                retString = retString + currentValue
            }
            retString = retString + "|"
        }
        return retString
    }
    
    // bitColumn starts at 0.
    public static func calcBytesNeeded(bitColumn: Int) -> Int
    {
        let valueNeeded = pow(2,bitColumn)
        let numBytesNeeded: Int = (bitColumn / 8) + 1
        let maxValue = pow(2,(numBytesNeeded * 8)) - 1
        return (maxValue < valueNeeded) ? numBytesNeeded + 1 : numBytesNeeded
    }
    
    public init(maxBitColumn: Int)
    {
        self.maxBitColumn = maxBitColumn
        register = Array(repeating: 0, count: BitRegister.calcBytesNeeded(bitColumn: maxBitColumn))
    }
    
    public mutating func setBit(bitColumn: Int) -> Void
    {
        guard bitColumn <= self.maxBitColumn
        else
        {
            print("Bit: \(bitColumn) cannot be set since it is larger than Size: \(self.maxBitColumn)")
            return
        }
        let byteIndex: Int = (self.register.count) - BitRegister.calcBytesNeeded(bitColumn: bitColumn)
        guard byteIndex >= 0
        else
        {
            print("Bit: \(bitColumn) is invalid for a BitRegister of size: \(maxBitColumn)")
            return
        }
        let mask: UInt8 = 0x01 << UInt8(bitColumn % 8)
        self.register[byteIndex] = self.register[byteIndex] | mask
    }
    
    public func isSet(bitColumn: Int) -> Bool
    {
        guard bitColumn <= self.maxBitColumn
            else
        {
            print("Bit: \(bitColumn) cannot be tested since it is larger than Size: \(self.maxBitColumn)")
            return false
        }
        let byteIndex: Int = (self.register.count) - BitRegister.calcBytesNeeded(bitColumn: bitColumn)
        guard byteIndex >= 0
        else
        {
            print("Bit: \(bitColumn) is invalid for a BitRegister of size: \(maxBitColumn)")
            return false
        }
        let mask: UInt8 = 0x01 << UInt8(bitColumn % 8)
        return (self.register[byteIndex] & mask) != 0
    }
}
