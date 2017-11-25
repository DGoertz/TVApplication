import UIKit

public class BinaryStdIn
{
    static let MaxBitIndex: UInt8 = 8
    static let MinBitIndex: UInt8 = 1
    
    var file:             URL!
    var fh:               FileHandle!
    var readAhead:        Int!
    var dataBuffer:       Data?
    var byteIndex:        Int?
    // This will be the actual bit number, 1-8.
    var bitIndex:         UInt8?
    var endOfFile:        Bool = false
    var isEmpty:          Bool
    {
        return self.endOfFile
    }
    var outOfData:        Bool
    {
        return (self.byteIndex! >= (self.dataBuffer?.count)!)
    }
    var bitMaskFromIndex: UInt8
    {
        return UInt8(0x01 << UInt8(self.bitIndex! - 1))
    }
    var currentByte:      UInt8
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
        self.bitIndex = BinaryStdIn.MaxBitIndex
        self.endOfFile = false
        return dataBuffer.count
    }
    
    public func indexNextByteInBuffer() -> Void
    {
        self.byteIndex! += 1
        self.bitIndex! = BinaryStdIn.MaxBitIndex
        if self.outOfData
        {
            // May have to detect when this reads bytes < 1
            let _ = self.readNextDataBuffer()
        }
    }
    
    public func decrementBitIndex() -> Void
    {
        self.bitIndex! -= 1
        if self.bitIndex! < BinaryStdIn.MinBitIndex
        {
            self.indexNextByteInBuffer()
        }
    }
    
    public func readBoolean() -> Bool
    {
        let desiredBit: UInt8 = self.bitMaskFromIndex & self.currentByte
        self.decrementBitIndex()
        return (desiredBit > 0) ? true : false
    }
    
    public func readByteAcrossByteBoundary() -> UInt8
    {
        let bitsToChopOffTop = (BinaryStdIn.MaxBitIndex - self.bitIndex!)
        let topPart: UInt8 = UInt8(self.currentByte << bitsToChopOffTop)
        let tempBitIndex = self.bitIndex!
        self.indexNextByteInBuffer()
        self.bitIndex = tempBitIndex
        let bottomPart: UInt8 = UInt8(self.currentByte >> tempBitIndex)
        return UInt8(topPart + bottomPart)
    }
    
    public func readChar() -> UInt16
    {
        // We need to get 8 bits, some from the next byte.
        if self.bitIndex != BinaryStdIn.MaxBitIndex
        {
            return UInt16(self.readByteAcrossByteBoundary())
        }
        let retVal: UInt16 = UInt16(self.currentByte)
        self.indexNextByteInBuffer()
        return retVal
    }
    
    // Need to fix this to go across boundary.
    public func readChar(numBits: UInt8) -> UInt16
    {
        guard numBits > 0 && numBits < 17 else {
            return 0xFFFF
        }
        var accum: UInt16 = 0
        for _ in 0..<numBits
        {
            accum = accum << 1
            if self.readBoolean() == true
            {
                accum += 1
            }
        }
        return accum
    }
    
    public func readShort() -> UInt16
    {
        let highByte: UInt16 = self.readChar()
        let lowByte: UInt16 = self.readChar()
        return (highByte << 8) | lowByte
    }
    
    public func readInt() -> UInt32
    {
        let firstByte: UInt16 = self.readChar()
        let secondByte: UInt16 = self.readChar()
        let thirdByte: UInt16 = self.readChar()
        let fourthByte: UInt16 = self.readChar()
        let p1: UInt16 = UInt16(firstByte << 8) + UInt16(secondByte)
        let p2: UInt16 = UInt16(thirdByte << 8) + UInt16(fourthByte)
        let retVal: UInt32 = UInt32(UInt32(p1) << 16) + UInt32(p2)
        return retVal
    }
    
    public func readLong() -> UInt64
    {
        let firstByte: UInt16 = self.readChar()
        let secondByte: UInt16 = self.readChar()
        let thirdByte: UInt16 = self.readChar()
        let fourthByte: UInt16 = self.readChar()
        let fifthByte: UInt16 = self.readChar()
        let sixthByte: UInt16 = self.readChar()
        let seventhByte: UInt16 = self.readChar()
        let eighthByte: UInt16 = self.readChar()
        let p1: UInt16 = UInt16(firstByte << 8) + UInt16(secondByte)
        let p2: UInt16 = UInt16(thirdByte << 8) + UInt16(fourthByte)
        let p3: UInt16 = UInt16(fifthByte << 8) + UInt16(sixthByte)
        let p4: UInt16 = UInt16(seventhByte << 8) + UInt16(eighthByte)
        let b1: UInt32 = UInt32(UInt32(p1) << 16) + UInt32(p2)
        let b2: UInt32 = UInt32(UInt32(p3) << 16) + UInt32(p4)
        let retVal: UInt64 = UInt64(UInt64(b1) << 32) + UInt64(b2)
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
