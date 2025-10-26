import Foundation

extension IdentifableModel {
    static func generateID() -> String {
        return UUID().uuidString
    }
}

protocol NoteProtocol : CanvasUnit{
    func willRemove()
    func update(_ data:IdentifableModel)
}

class Note<Data:IdentifableModel> : NoteProtocol {
    var id: String {return data.id}

    
    var data: Data{
        didSet{
            storage.update(data)
        }
    }
    private var storage : Storage<Data>
    
    init(data: Data, storage: Storage<Data>) {
        self.data = data
        self.storage = storage
        self.storage.add(data)
    }

    
    func update(_ newData:IdentifableModel) {
        if let typedData = newData as? Data {
            self.data = typedData
        }
    }
    
    func willRemove() {
        storage.remove(ById: data.id)
    }
    
    func drawCanvas() -> String {
        return "Базовая заметка \(data.id)"
    }
    func getAll() -> [any IdentifableModel] {
        return [data]
    }
}

struct TextNoteModel : IdentifableModel {
    var id: String
    var name:String
    var text: String
}

struct ReminderNoteModel : IdentifableModel {
    var id:String
    var text:String
    var isDone : Bool
    
}

class TextNote: Note<TextNoteModel> {
    override func drawCanvas() -> String {
        return "Текстовая заметка с именем \(data.name) содержит : \(data.text)"
    }
    
    
}

class ReminderNote: Note<ReminderNoteModel> {
    override func drawCanvas() -> String {
        return "Задача \(data.text)  \(data.isDone ? "выполнена" : "не выполнена")"
    }

}

