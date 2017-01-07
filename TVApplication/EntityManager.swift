import Foundation

class EntityManager
{
    static let sharedInstance: EntityManager = EntityManager()

    var entites: [ String : BaseEntity ]!
    
    private init()
    {
        self.entites = [ String : BaseEntity ]()
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
    
    func getEntity(fromID: String) -> BaseEntity?
    {
        return entites[fromID]
    }
    
    func remove(entity: BaseEntity) -> Void
    {
        entites.removeValue(forKey: entity.ID)
    }
}
