import Foundation

public class BinaryStdOut
{
    var file:       URL!
    var fh:         FileHandle!
    var dataBuffer: Data?
    var byteIndex:  Int?
    var bitIndex:   Int?
    
    public init(fileName: String, ext: String)
    {
        let docDir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let baseFileName: URL = URL(fileURLWithPath: fileName).appendingPathExtension(ext)
        let fileURL: URL = docDir.appendingPathComponent(baseFileName.relativePath)
        print("\(fileURL)")
        var fh: FileHandle? = nil
        do
        {
            try fh = FileHandle.init(forWritingTo: fileURL)
            fh?.write("Crap!".data(using: .utf8)!)
            fh?.closeFile()
        }
        catch let Error
        {
            print("\(Error.localizedDescription)")
        }
    }
}
