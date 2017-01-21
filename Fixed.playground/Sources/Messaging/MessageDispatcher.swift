import Foundation

public enum HandleState
{
    case handled
    case notHandled
}

public class MessageDispatcher
{
    static let instance = MessageDispatcher()
    
    var delayedMessages: OrderedTelegram!
    
    private init()
    {
        delayedMessages = OrderedTelegram()
    }
    
    static func obtainReceiver(fromId: String) -> BaseEntity?
    {
        guard let receiverEntity = EntityManager.sharedInstance.getEntity(fromID: fromId)
            else
        {
            print("ERROR: Couldn't find the Receiver with ID \(fromId)")
            return nil
        }
        return receiverEntity
    }
    
    func DispatchMessage(delay: TimeInterval, sender: String, receiver: String, message: MessageLibrary, userInfo: [ String : AnyObject ]) -> Void
    {
        guard let recEntity = MessageDispatcher.obtainReceiver(fromId: receiver)
            else
        {
            print("ERROR: Failed to send message as the Receiver with ID \(receiver) was not found!")
            return
        }
        let currentTime = Date.timeIntervalSinceReferenceDate
        if delay <= 0
        {
            let packagedMessage = Telegram(sender: sender, receiver: receiver, message: message, dispatchTime: currentTime)
            self.Discharge(reciever: recEntity, message: packagedMessage)
        }
        else
        {
            let packagedMessage = Telegram(sender: sender, receiver: receiver, message: message, dispatchTime: currentTime + delay)
            delayedMessages.add(telegram: packagedMessage)
        }
    }
    
    func DispatchDelayedMessages() -> Void
    {
        let currentTime = Date.timeIntervalSinceReferenceDate
        for message in delayedMessages.getTelegramsInTimeOrder()
        {
            if message.dispatchTime < currentTime
            {
                self.Discharge(reciever: MessageDispatcher.obtainReceiver(fromId: message.receiver)!, message: message)
                delayedMessages.remove(telegram: message)
            }
        }
    }
    
    func Discharge(reciever: BaseEntity, message: Telegram)
    {
        let handledState = reciever.handle(message: message)
    }
}
