class Notebook:CanvasUnit {
    var id: String = "notebook_main"
    
     var textStorage : Storage<TextNoteModel>
     var reminderStorage : Storage <ReminderNoteModel>
    
     var notes : [NoteProtocol] = []
    
    
    

    
    init(textNoteStorage : Storage<TextNoteModel> , reminderNoteStorage : Storage<ReminderNoteModel> ){
        self.textStorage = textNoteStorage
        self.reminderStorage = reminderNoteStorage
        
        
    }
    
     func loadNotes(){
        notes.removeAll()
        
        let textModels = textStorage.getAll()
        let reminderModels = reminderStorage.getAll()
        
        for tm in textModels{
            let note = TextNote(data:tm, storage: textStorage)
            notes.append(note)
        }
        
        for rm in reminderModels {
            let note = ReminderNote(data:rm, storage:reminderStorage)
            notes.append(note)
        }
    }
    
    func add(_ note:NoteProtocol){
        notes.append(note)
    }
    
    func remove(at index:Int) {
        guard index >= 0 && index < notes.count else {return}
        let note = notes[index]
        note.willRemove();
        notes.remove(at: index)
    }
    
    func getAllNotes() -> [NoteProtocol] {
        return notes
    }
    
    func drawCanvas() -> String{
        if notes.isEmpty{

            return "Заметок нет"
        }

            var result = "Текущие заметки:"
            for (index,note) in notes.enumerated(){
                result += "\n\(index + 1). \(note.drawCanvas())\n"
                
        }
        return result
    }
    
}
