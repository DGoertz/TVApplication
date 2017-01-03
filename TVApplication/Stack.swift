//
//  Stack.swift
//  TVApplication
//
//  Created by David Goertz on 2016-12-29.
//  Copyright © 2016 David Goertz. All rights reserved.
//

import Foundation

class Stack<T>
{
    var backingData: [ T ]
    
    init()
    {
        backingData = [ T ]()
    }
    
    func push(item: T)
    {
        backingData.append(item)
    }
    
    func pop() -> T?
    {
        if let retVal = backingData.last
        {
            backingData.removeLast()
            return retVal
        }
        return nil
    }
}
