import Foundation

public struct Array2D<T>
{
    var rows:   Int
    var cols:   Int
    var values: [T]
    
    public init(rows: Int, cols: Int, initValue: T)
    {
        self.rows = rows
        self.cols = cols
        values = Array(repeating: initValue, count: self.rows * self.cols)
    }
    
    public subscript(row: Int, col: Int) -> T?
    {
        get
            {
                guard row <= self.rows, col <= self.cols
                else
                {
                    print("Illegal index!")
                    return nil
                }
                return self.values[ (row * col) + col ]
        }
        
        set(newValue)
            {
                guard row <= self.rows, col <= self.cols
                    else
                {
                    print("Illegal index!")
                    return
                }
                self.values[ (row * col) + col ] = newValue!
        }
    }
}
