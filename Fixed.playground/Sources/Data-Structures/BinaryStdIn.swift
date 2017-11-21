import UIKit

public class BinaryStdIn
{
    var file:       URL!
    var fh:         FileHandle!
    var readAhead:  Int!
    var dataBuffer: Data?
    var byteIndex:  Int?
    var bitIndex:   Int?
    var endOfFile:  Bool = false
    var isEmpty:    Bool
    {
        return self.endOfFile
    }
    var outOfData:  Bool
    {
        return (self.byteIndex! >= (self.dataBuffer?.count)!)
    }
    var bitMaskFromIndex: UInt8
    {
        return (0x01 << UInt8(self.bitIndex!))
    }
    var currentByte: UInt8
    {
        return (self.dataBuffer?[self.byteIndex!])! as UInt8
    }
    
    public init?(fileName: String, ext: String, readAhead: Int)
    {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: ext)
            else
        {
            print("Failed to locate the file \(fileName).\(ext) in the resources of this plsyground!")
            return nil
        }
        var fh: FileHandle?
        do
        {
            fh = try FileHandle(forReadingFrom: path)
        }
        catch let error
        {
            print("Error opening file: \(path) - OS Error is: \(error.localizedDescription)")
            return nil
        }
        self.file = path
        self.fh = fh!
        self.readAhead = readAhead
        guard self.readNextDataBuffer() > 0 else {
            self.endOfFile = true
            abort()
        }
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
        if self.outOfData
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
    
    public func readBoolean() -> Bool
    {
        let currentByte = self.currentByte
        let desiredBit = self.bitMaskFromIndex & currentByte
        self.incrementBitIndex()
        return desiredBit > 0 ? true : false
    }
    
    public func readToByteBoundary() -> CChar
    {
        let leftToGo: Int = 8 - self.bitIndex!
        guard leftToGo != 8 else { return CChar(0) }
        print(leftToGo)
        var partialRetVal: UInt8 = 0
        for x in 0..<leftToGo
        {
            let nextBit: UInt8 = (self.bitMaskFromIndex & self.currentByte) > 0 ? 1 : 0
            print(" \(nextBit) ")
            self.incrementBitIndex()
            if x == 0
            {
                partialRetVal = nextBit
                continue
            }
            partialRetVal = (partialRetVal << 0x01) | nextBit
        }
        print("Returning: \(partialRetVal)")
        return CChar(partialRetVal)
    }
    
    public func readChar() -> CChar
    {
        // Do we need to be on a byte boundary?
        if self.bitIndex != 0
        {
            return self.readToByteBoundary()
        }
        let c: CChar = CChar(self.currentByte)
        self.incrementByteIndex()
        return c
    }
    
    public func readChar(numBits: Int) -> UInt16
    {
        guard numBits < 17 else {
            return 0xFFFF
        }
        if numBits < 8
        {
            return UInt16(self.readChar())
        }
        // Still have the problem where we want > 8 bits but the bitIndex is not on a Byte boundary!
        let endIndex = self.bitIndex! + numBits
        var mask: UInt16 = 0
        for i in self.bitIndex!..<endIndex
        {
            let n: UInt16 = (0x01 << UInt16(i))
            mask = mask | n
        }
        let firstByte: UInt16 = UInt16(self.currentByte)
        self.incrementByteIndex()
        let secondByte: UInt16 = UInt16(self.currentByte)
        self.incrementByteIndex()
        let value: UInt16 = UInt16(firstByte << 8) | UInt16(secondByte)
        return value & mask
    }
    
    public func readShort() -> UInt16
    {
        let highByte: UInt16 = UInt16(self.currentByte)
        self.incrementByteIndex()
        let lowByte: UInt16 = UInt16(self.currentByte)
        self.incrementByteIndex()
        return (highByte << 8) | lowByte
    }
    
    public func readInt() -> UInt32
    {
        let firstByte: UInt32 = UInt32(self.currentByte)
        self.incrementByteIndex()
        let secondByte: UInt32 = UInt32(self.currentByte)
        self.incrementByteIndex()
        let thirdByte: UInt32 = UInt32(self.currentByte)
        self.incrementByteIndex()
        let fourthByte: UInt32 = UInt32(self.currentByte)
        self.incrementByteIndex()
        return UInt32(firstByte << 24) | UInt32(secondByte << 16) | UInt32(thirdByte << 8) | UInt32(fourthByte)
    }
    
    public func readLong() -> UInt64
    {
        let firstByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let secondByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let thirdByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let fourthByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let fifthByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let sixthByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let seventhByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        let eighthByte: UInt64 = UInt64(self.currentByte)
        self.incrementByteIndex()
        var retVal: UInt64 = UInt64(firstByte << 56) | UInt64(secondByte << 48)
        retVal = retVal | UInt64(thirdByte << 40) | UInt64(fourthByte  << 32)
        retVal = retVal | UInt64(fifthByte << 24) | UInt64(sixthByte << 16)
        retVal = retVal | UInt64(seventhByte << 8) | UInt64(eighthByte)
        return retVal
    }
    
    public func close() -> Void
    {
        self.fh.synchronizeFile()
        self.fh.closeFile()
        self.byteIndex = nil
        self.bitIndex = nil
        self.endOfFile = true
    }
}
