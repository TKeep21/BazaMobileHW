import Foundation
protocol IdentifableModel {
    var id : String { get}
}

class Storage<T:IdentifableModel>{
     var Items: [T] = []

    
    func add(_ item : T){
        Items.append(item)
    }
    
    func remove(ById id : String){
        Items.removeAll{$0.id == id}
    }
    
    func value (by id:String) -> T? {
        return Items.first(where: {$0.id == id})
    }
    
    func update (_ item: T){
        for i in Items.indices {
            if Items[i].id == item.id{
                Items[i] = item
            }
        }
    }
    
    func getAll() -> [T] {
            return Items
        }
    
    
    
}

