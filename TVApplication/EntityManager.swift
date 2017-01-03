import Foundation

class EntityManager
{
    static let sharedInstance: EntityManager = EntityManager()

    var entites: [ Int64 : BaseEntity ]!
    
    private init()
    {
        self.entites = [ Int64 : BaseEntity ]()
    }
    
    func register(entity: BaseEntity) -> Void
    {
        guard entites[entity.ID] == nil
        else
        {
            print("ERROR: Cannot register Entity \(entity.ID) since it is already there!")
            return
        }
        entites[entity.ID] = entity
    }
    
    func getEntity(fromID: Int64) -> BaseEntity?
    {
        return entites[fromID]
    }
    
    func remove(entity: BaseEntity) -> Void
    {
        entites.removeValue(forKey: entity.ID)
    }
}
