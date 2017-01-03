import Foundation

enum GoalState
{
    case inactive
    case active
    case completed
    case failed
}

enum GoalType
{
    case Atomic
    case Composite
}

class Goal
{
    // MARK: Variables.
    
    var owner: BaseEntity
    var state: GoalState
    var type: GoalType
    var subGoals: [ Goal ]?
    
    // MARK: Initialization.
    init(owner: BaseEntity, type: GoalType, subGoals: [ Goal ]?)
    {
        self.owner = owner
        self.state = .inactive
        self.type = type
        switch type {
        case .Atomic:
            self.subGoals = nil
        case .Composite:
            self.subGoals = subGoals
        }
    }
    
    // MARK: Methods.
    
    func activate() -> Void
    {
        print("The active method should be overridden in subclasses!")
    }
    
    func process() -> GoalState
    {
        print("The process method should be overridden in subclasses!")
        return .failed
    }
    
    func processSubGoals() -> GoalState
    {
        guard self.type == .Composite, let subGoals = self.subGoals
            else
        {
            print("Cannot process sub goals to an Atomic Goal!")
            return .failed
        }
        for eachGoal in subGoals
        {
            if eachGoal.state == .completed || eachGoal.state == .failed
            {
                
            }
        }
        var retState: GoalState = .inactive
        for eachGoal in subGoals
        {
            retState = eachGoal.process()
            if retState != .completed
            {
                break
            }
        }
        return retState
    }
    
    func terminate() -> Void
    {
        print("The terminate method should be overridden in subclasses!")
    }
    
    func addSubGoal(subGoal: Goal) -> Void
    {
        guard self.type == .Composite, var subGoals = self.subGoals
            else
        {
            print("Illegal to add a sub goal to an Atomic Goal!")
            return
        }
        subGoals.insert(subGoal, at: 0)
    }
    
    func handle(message: Telegram) -> HandleState
    {
        print("The handle:message: method should be overridden in subclasses!")
        return HandleState.notHandled
    }
}
