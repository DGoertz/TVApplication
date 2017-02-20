
import UIKit
import Foundation
import PlaygroundSupport

import Foundation

public class BinaryStdIn
{
    var file:        URL!
    var fh:          FileHandle!
    var readAhead:   Int!
    var dataBuffer:  Data?
    var bufferIndex: Int?
    var bitIndex:    Int?
    var endOfFile:   Bool = false
    
    public init(fileName: String, ext: String, readAhead: Int)
    {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: ext)
            else
        {
            print("Failed to locate the file \(fileName).\(ext) in the resources of this plsyground!")
            return
        }
        var fh: FileHandle?
        do
        {
            fh = try FileHandle(forReadingFrom: path)
        }
        catch let error
        {
            print("Error opening file: \(path) - OS Error is: \(error.localizedDescription)")
        }
        self.file = path
        self.fh = fh!
        self.readAhead = readAhead
        self.readNextBuffer()
    }
    
    public func incrementByteIndex() -> Void
    {
        self.bufferIndex! = self.bufferIndex! + 1
        self.bitIndex! = 0
    }
    
    public func incrementBitIndex() -> Void
    {
        self.bitIndex! = self.bitIndex! + 1
    }
    
    public func getNextByte() -> UInt8
    {
        return (self.dataBuffer?[self.bufferIndex!])! as UInt8
    }
    
    public func createBitMask() -> UInt8
    {
        return (0x01 << UInt8(self.bitIndex!))
    }
    
    public func outOfData() -> Bool
    {
        return (self.bufferIndex! >= (self.dataBuffer?.count)!)
    }
    
    public func readNextBuffer() -> Int
    {
        var dataBuffer = self.fh.readData(ofLength: self.readAhead)
        if dataBuffer.count == 0
        {
            self.endOfFile = true
            return 0
        }
        self.dataBuffer = dataBuffer
        self.bufferIndex = 0
        self.bitIndex = 0
        self.endOfFile = false
        return dataBuffer.count
    }
    
    public func readBoolean() -> Bool
    {
        let currentByte = self.getNextByte()
        let mask = self.createBitMask()
        let bit = mask & currentByte
        self.incrementBitIndex()
        if self.bitIndex! > 7
        {
            self.incrementByteIndex()
            if self.outOfData()
            {
                let _ = self.readNextBuffer()
            }
        }
        return bit > 0 ? true : false
    }
    
    public func readChar() -> CChar
    {
        return CChar(readByte())
    }
    
    public func readByte() -> UInt8
    {
        let currentByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        return UInt8(currentByte)
    }
    
    public func readShort() -> UInt16
    {
        let highByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let lowByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        return UInt16(highByte << 8) | UInt16(lowByte)
    }
    
    public func readInt() -> UInt32
    {
        let firstByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let secondByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let thirdByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let fourthByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let mask1: UInt32 = UInt32(firstByte)
        let mask2: UInt32 = UInt32(secondByte)
        let mask3: UInt32 = UInt32(thirdByte)
        let mask4: UInt32 = UInt32(fourthByte)
        return UInt32(mask1 << 24) | UInt32(mask2 << 16) | UInt32(mask3 << 8) | UInt32(mask4)
    }
    
    public func readLong() -> UInt64
    {
        let firstByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let secondByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let thirdByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let fourthByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let fifthByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let sixthByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let seventhByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let eighthByte = self.getNextByte()
        self.incrementByteIndex()
        if self.outOfData()
        {
            let _ = self.readNextBuffer()
        }
        let mask1: UInt64 = UInt64(firstByte)
        let mask2: UInt64 = UInt64(secondByte)
        let mask3: UInt64 = UInt64(thirdByte)
        let mask4: UInt64 = UInt64(fourthByte)
        let mask5: UInt64 = UInt64(fifthByte)
        let mask6: UInt64 = UInt64(sixthByte)
        let mask7: UInt64 = UInt64(seventhByte)
        let mask8: UInt64 = UInt64(eighthByte)
        return UInt64(mask1 << 56) | UInt64(mask2 << 48) | UInt64(mask3 << 40) | UInt64(mask4  << 32) | UInt64(mask5 << 24) | UInt64(mask6 << 16) | UInt64(mask7 << 8) | UInt64(mask8)
    }
    
    public func close() -> Void
    {
        self.fh.synchronizeFile()
        self.fh.closeFile()
        self.bufferIndex = nil
        self.bitIndex = nil
        self.endOfFile = true
    }
    
    func readChar(numBits: Int) throws -> UInt16
    {
        return 0
    }
    
    func isEmpty() -> Bool
    {
        return false
    }
}
var a: BinaryStdIn = BinaryStdIn(fileName: "SearchTips", ext: "txt", readAhead: 100)
let c = a.readLong()
print("\(c)")
//var asCChar: [CChar] = [CChar]()
//var stringVersion: String
//while a.endOfFile == false
//{
//    asCChar.append(a.readChar())
//}
//let str: String = String(cString: &asCChar)
//print("\(str)")

