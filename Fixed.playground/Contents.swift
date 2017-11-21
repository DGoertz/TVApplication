var a = BinaryStdIn(fileName: "SearchTips", ext: "txt", readAhead: 100)
if a != nil
{
    let b = a!.readBoolean()
    let one = a!.readChar()
    let two = a!.readChar()
    print(b)
    print(one)
    print(two)
    //let b = a!.readBoolean()
    
    //let c = a!.readChar(numBits: 12)
}
//print("\(b)")

//var a: BinaryStdOut = BinaryStdOut(fileName: "Mine", ext: "txt")
