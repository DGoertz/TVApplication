import Foundation

public class Stack<T>
{
    var stack: [T]
    
    init()
    {
        self.stack = [T]()
    }
    
    func push(newItem: T) -> Void
    {
        stack.append(newItem)
    }
    
    func pop() -> T?
    {
        if stack.count > 0
        {
            return stack.removeLast()
        }
        else
        {
            return nil
        }
    }
}
