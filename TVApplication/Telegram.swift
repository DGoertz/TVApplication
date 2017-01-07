import Foundation

enum MessageLibrary : Int64 , CustomStringConvertible
{
    // Dog Messages:
    case HerdingYou
    case GoingToFetch
    case BroughtBack
    case DefendingAgainstCoyote
    case AttackingCoyote
    
    // Sheep Messages:
    case ArrivedInPen
    case BeingAttacked
    case Dead
    
    // Man Messages:
    case ThrowingFrizbee
    case WhistlingToMe
    case WhistlingToLeft
    case WhistlingToRight
    
    // Coyote Messages:
    case HuntingSheep
    case AttackingSheep
    
    //Generic Messages:
    case EnteringMap
    
    // MARK: CustomStringConvertible conformance.
    var description: String {
        switch self {
        case .HerdingYou:
            return "Message is: Herding You"
        case .GoingToFetch:
            return "Message is: Going To Fetch"
        case .DefendingAgainstCoyote:
            return "Message is: Defending Against Coyote"
        case .ArrivedInPen:
            return "Message is: Arrived In Pen"
        case .BeingAttacked:
            return "Message is: Being Attacked"
        case .Dead:
            return "Message is: Dead"
        case .ThrowingFrizbee:
            return "Message is: Throwing Frizbee"
        case .WhistlingToMe:
            return "Message is: Whistling To Me"
        case .WhistlingToLeft:
            return "Message is: Whistling To Left"
        case .WhistlingToRight:
            return "Message is: Whistling To Right"
        case .HuntingSheep:
            return "Message is: Hunting Sheep"
        case .AttackingSheep:
            return "Message is: Attacking Sheep"
        case .EnteringMap:
            return "Message is: Entering Map"
        default:
            return "Message: Unknown message type!"
        }
    }
}

struct Telegram : Hashable
{
    // MARK: Properties.
    
    var sender: String
    var receiver: String
    var message: MessageLibrary
    var dispatchTime: TimeInterval
    
    init(sender: String, receiver: String, message: MessageLibrary, dispatchTime: TimeInterval)
    {
        self.sender = sender
        self.receiver = receiver
        self.message = message
        self.dispatchTime = dispatchTime
    }
    
    // MARK: Copy constructor.
    
    init(another: Telegram)
    {
        sender = another.sender
        receiver = another.receiver
        message = another.message
        dispatchTime = another.dispatchTime
    }
    
    // MARK: Hashable conformance.
    public var hashValue: Int { return (sender.hash & 0xFFFFFFFF << 32) & (receiver.hash & 0xFFFFFFFF) }
    
    // MARK: Equitable conformance.
    public static func ==(lhs: Telegram, rhs: Telegram) -> Bool
    {
        return (
            lhs.sender == rhs.sender &&
                lhs.receiver == rhs.receiver &&
                lhs.message == rhs.message &&
                lhs.dispatchTime == rhs.dispatchTime
        )
    }
}

