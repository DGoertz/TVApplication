import Foundation

enum IOErrors: Error
{
    case BadParameter(message: String)
    case NothingFound
}

public class BinaryStdIn
{
    var file:        URL
    var fh:          FileHandle
    var readAhead:   Int
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
            abort()
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
        let currentByte = (self.dataBuffer?[self.bufferIndex!])! as UInt8
        let bit = UInt8(self.bitIndex!) & currentByte
        self.bitIndex! = self.bitIndex! + 1
        if self.bitIndex! > 7
        {
            self.bufferIndex! = self.bufferIndex! + 1
            self.bitIndex! = 0
            if self.bufferIndex! >= (self.dataBuffer?.count)!
            {
                let _ = self.readNextBuffer()
            }
        }
        return bit > 0 ? true : false
    }
    
    public func readChar() -> UInt8
    {
        let currentByte = (self.dataBuffer?[self.bufferIndex!])! as UInt8
        self.bufferIndex! = self.bufferIndex! + 1
        self.bitIndex! = 0
        if self.bufferIndex! >= (self.dataBuffer?.count)!
        {
            let _ = self.readNextBuffer()
        }
        return currentByte
    }
    
    public func close() -> Void
    {
        self.fh.synchronizeFile()
        self.fh.closeFile()
        self.bufferIndex = nil
        self.bitIndex = nil
        self.endOfFile = true
    }
    
    // bitColumn starts at 0.
    static func calcBytesNeeded(forBitColumn bitColumn: Int) -> Int
    {
        let valueNeeded = pow(2,bitColumn)
        let numBytesNeeded: Int = (bitColumn / 8) + 1
        let maxValue = pow(2,(numBytesNeeded * 8)) - 1
        return (maxValue < valueNeeded) ? numBytesNeeded + 1 : numBytesNeeded
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
