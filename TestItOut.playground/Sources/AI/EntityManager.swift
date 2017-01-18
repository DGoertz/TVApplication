import Foundation

public class EntityManager
{
    public static let sharedInstance: EntityManager = EntityManager()
    
    var entites: [ String : BaseEntity ]!
    
    private init()
    {
        self.entites = [ String : BaseEntity ]()
    }
    
    public func register(entity: BaseEntity) -> Void
    {
        guard entites[entity.ID] == nil
            else
        {
            print("ERROR: Cannot register Entity \(entity.ID) since it is already there!")
            return
        }
        entites[entity.ID] = entity
    }
    
    public func getKeys() -> [ String ]
    {
        var retKeys: [ String ] = [ String ]()
        let ks = entites.keys
        for k in ks
        {
            retKeys.append(k)
        }
        return retKeys
    }
    
    public func getEntity(fromID: String) -> BaseEntity?
    {
        return entites[fromID]
    }
    
    public func remove(entity: BaseEntity) -> Void
    {
        entites.removeValue(forKey: entity.ID)
    }
}
