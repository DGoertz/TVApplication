import UIKit
import Foundation
import PlaygroundSupport

public class BinaryStdIn
{
    var file:        URL!
    var fh:          FileHandle!
    var readAhead:   Int!
    var dataBuffer:  Data?
    var byteIndex:   Int?
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
        guard self.readNextDataBuffer() > 0 else {
            self.endOfFile = true
            abort()
        }
    }
    
    public func isEmpty() -> Bool
    {
        return self.endOfFile
    }
    
    public func readNextDataBuffer() -> Int
    {
        var dataBuffer = self.fh.readData(ofLength: self.readAhead)
        if dataBuffer.count == 0
        {
            self.endOfFile = true
            return 0
        }
        self.dataBuffer = dataBuffer
        self.byteIndex = 0
        self.bitIndex = 0
        self.endOfFile = false
        return dataBuffer.count
    }
    
    public func incrementByteIndex() -> Void
    {
        self.byteIndex! = self.byteIndex! + 1
        self.bitIndex! = 0
        if self.outOfData()
        {
            let _ = self.readNextDataBuffer()
        }
    }
    
    public func incrementBitIndex() -> Void
    {
        self.bitIndex! = self.bitIndex! + 1
        if self.bitIndex! > 7
        {
            self.incrementByteIndex()
        }
    }
    
    public func getCurrentByte() -> UInt8
    {
        let retVal = (self.dataBuffer?[self.byteIndex!])! as UInt8
        return retVal
    }
    
    public func createBitMaskFromBitIndex() -> UInt8
    {
        return (0x01 << UInt8(self.bitIndex!))
    }
    
    public func outOfData() -> Bool
    {
        return (self.byteIndex! >= (self.dataBuffer?.count)!)
    }
    
    public func readBoolean() -> Bool
    {
        let currentByte = self.getCurrentByte()
        let mask = self.createBitMaskFromBitIndex()
        let desiredBit = mask & currentByte
        self.incrementBitIndex()
        return desiredBit > 0 ? true : false
    }
    
    public func readChar() -> CChar
    {
        let c: CChar = CChar(self.getCurrentByte())
        self.incrementByteIndex()
        return c
    }
    
    public func readShort() -> UInt16
    {
        let highByte: UInt16 = UInt16(self.getCurrentByte())
        self.incrementByteIndex()
        let lowByte: UInt16 = UInt16(self.getCurrentByte())
        self.incrementByteIndex()
        return (highByte << 8) | lowByte
    }
    
    public func readInt() -> UInt32
    {
        let firstByte: UInt32 = UInt32(self.getCurrentByte())
        self.incrementByteIndex()
        let secondByte: UInt32 = UInt32(self.getCurrentByte())
        self.incrementByteIndex()
        let thirdByte: UInt32 = UInt32(self.getCurrentByte())
        self.incrementByteIndex()
        let fourthByte: UInt32 = UInt32(self.getCurrentByte())
        self.incrementByteIndex()
        return UInt32(firstByte << 24) | UInt32(secondByte << 16) | UInt32(thirdByte << 8) | UInt32(fourthByte)
    }
    
    public func readLong() -> UInt64
    {
        let firstByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let secondByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let thirdByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let fourthByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let fifthByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let sixthByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let seventhByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        let eighthByte: UInt64 = UInt64(self.getCurrentByte())
        self.incrementByteIndex()
        return UInt64(firstByte << 56) | UInt64(secondByte << 48) | UInt64(thirdByte << 40) | UInt64(fourthByte  << 32) | UInt64(fifthByte << 24) | UInt64(sixthByte << 16) | UInt64(seventhByte << 8) | UInt64(eighthByte)
    }
    
    public func close() -> Void
    {
        self.fh.synchronizeFile()
        self.fh.closeFile()
        self.byteIndex = nil
        self.bitIndex = nil
        self.endOfFile = true
    }
    
    func readChar(numBits: Int) throws -> UInt16
    {
        return 0
    }
}

