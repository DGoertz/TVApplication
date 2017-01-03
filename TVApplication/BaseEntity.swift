import Foundation

enum EntitieTypes : Int64
{
    case Man    = 0x0000000000000001
    case Dog    = 0x0000000000000002
    case Sheep  = 0x0000000000000003
    case Coyote = 0x0000000000000004
}

class BaseEntity
{
    var ID: Int64
    var hitPoints: Int
    
    init(id: EntitieTypes)
    {
        self.ID = id.rawValue
        switch id
        {
        case .Man:
            hitPoints = 100
        case .Dog:
            hitPoints = 150
        case .Sheep:
            hitPoints = 50
        case .Coyote:
            hitPoints = 200
        }
    }
    
    func update() -> Void
    {
        // currentGoal.process()
        print("Method update must be overridden!")
    }
    
    func handle(message: Telegram) -> HandleState
    {
        print("Mthod handle:message: must be overridden!")
        return .notHandled
    }
    
    func render() -> Void
    {
        print("Method render message must be overridden!")
    }
}
