//
//  OrderedTelegram.swift
//  TVApplication
//
//  Created by David Goertz on 2016-12-28.
//  Copyright © 2016 David Goertz. All rights reserved.
//

import Foundation

public class OrderedTelegram
{
    static let MIN_TIMING_INSTANCE: TimeInterval = Double.leastNormalMagnitude
    
    var backingItems: [ TimeInterval : Telegram ]
    
    init()
    {
        backingItems = [ TimeInterval : Telegram ]()
    }
    
    func add(telegram: Telegram)
    {
        var newUniqueTime: TimeInterval = telegram.dispatchTime
        while backingItems[newUniqueTime] != nil
        {
            newUniqueTime = newUniqueTime + OrderedTelegram.MIN_TIMING_INSTANCE
        }
        let fixedTelegram: Telegram = Telegram(sender: telegram.sender, receiver: telegram.receiver, message: telegram.message, dispatchTime: newUniqueTime)
        backingItems[newUniqueTime] = fixedTelegram
    }
    
    func getTelegramsInTimeOrder() -> [ Telegram ]
    {
        let sortedKeys = backingItems.keys.sorted()
        var retVal: [ Telegram ] = [ Telegram ]()
        for item in sortedKeys
        {
            retVal.append(backingItems[item]!)
        }
        return retVal
    }
    
    func remove(telegram: Telegram) -> Void
    {
        backingItems.removeValue(forKey: telegram.dispatchTime)
    }
}
