import Foundation

enum EntityType
{
    case Man
    case Dog
    case Sheep
    case Coyote
}

class BaseEntity
{
    var ID:        String
    var type:      EntityType
    var hitPoints: Int
    
    init(id: EntityType)
    {
        self.ID = UUID().uuidString
        switch id
        {
        case .Man:
            type = .Man
            hitPoints = 100
        case .Dog:
            type = .Dog
            hitPoints = 150
        case .Sheep:
            type = .Sheep
            hitPoints = 50
        case .Coyote:
            type = .Coyote
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
        print("Method handle:message: must be overridden!")
        return .notHandled
    }
    
    func render() -> Void
    {
        print("Method render message must be overridden!")
    }
}
