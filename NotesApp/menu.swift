import Foundation
class Menu {
    private let console: ConsoleUI
    private let notebook: Notebook
    
    private enum State {
        case home
        case textNote(TextNote)
        case reminderNote(ReminderNote)
        case textNewNote
        case reminderNewNote
    }
    
    private var currentState: State = .home
    
    init(console: ConsoleUI, notebook: Notebook) {
        self.console = console
        self.notebook = notebook
    }
    
    func run() {
        var shouldExit = false
        
        while !shouldExit {
            switch currentState {
            case .home:
                shouldExit = showHomeMenu()
            case .textNote(let note):
                showNoteMenu(note: note)
            case .reminderNote(let note):
                showNoteMenu(note: note)
            case .textNewNote:
                createNewTextNote()
            case .reminderNewNote:
                createNewReminderNote()
            }
        }
        print("До свидания!")
    }
    
    private func showHomeMenu() -> Bool {
        console.showCanvas(notebook)
        
        let menuOptions = [
            "Редактировать заметку",
            "Добавить новую заметку",
            "Удалить заметку",
            "Выйти из приложения"
        ]
        
        guard let choice = console.showMenuList(menuOptions) else {
            print(" Неверный ввод")
            return false
        }
        
        switch choice {
        case 1:
            if let index = selectNoteIndex() {
                editNote(at: index)
            }
            return false
            
        case 2:
            showAddNoteMenu()
            return false
            
        case 3:
            if let index = selectNoteIndex() {
                removeNote(at: index)
            }
            return false
            
        case 4:
            return true
            
        default:
            print(" Неверный выбор")
            return false
        }
    }
    
    private func selectNoteIndex() -> Int? {
        let notes = notebook.getAllNotes()
        if notes.isEmpty {
            print("📭 Заметок нет")
            return nil
        }
        
        guard let index = console.readInt("Выберите номер заметки (1-\(notes.count)): ") else {
            print("Неверный ввод")
            return nil
        }
        
        let adjustedIndex = index - 1
        guard adjustedIndex >= 0 && adjustedIndex < notes.count else {
            print("Неверный номер заметки")
            return nil
        }
        
        return adjustedIndex
    }
    
    private func showAddNoteMenu() {
        let addOptions = [
            "Текстовая заметка",
            "Заметка-напоминание"
        ]
        
        guard let choice = console.showMenuList(addOptions) else {
            print(" Неверный ввод")
            return
        }
        
        switch choice {
        case 1:
            currentState = .textNewNote
        case 2:
            currentState = .reminderNewNote
        default:
            print(" Неверный выбор")
        }
    }
    
    private func createNewTextNote() {
        print("\n Создание текстовой заметки")
        
        guard let name = console.readString("Введите название: "),
              let text = console.readString("Введите текст: ") else {
            print(" Отмена создания заметки")
            currentState = .home
            return
        }
        
        let id = UUID().uuidString
        let model = TextNoteModel(id: id, name: name, text: text)
        
        let textNote = TextNote(data: model, storage: notebook.textStorage)
        notebook.add(textNote)
        
        print(" Текстовая заметка создана!")
        currentState = .home
    }
    
    private func createNewReminderNote() {
        print("\n Создание заметки-напоминания")
        
        guard let text = console.readString("Введите текст напоминания: ") else {
            print(" Отмена создания заметки")
            currentState = .home
            return
        }
        
        let id = UUID().uuidString
        let model = ReminderNoteModel(id: id, text: text, isDone: false)
        
        let reminderNote = ReminderNote(data: model, storage: Storage<ReminderNoteModel>())
        notebook.add(reminderNote)
        
        print(" Заметка-напоминание создана!")
        currentState = .home
    }
    
    private func editNote(at index: Int) {
        let notes = notebook.getAllNotes()
        let note = notes[index]
        
        if let textNote = note as? TextNote {
            currentState = .textNote(textNote)
        } else if let reminderNote = note as? ReminderNote {
            currentState = .reminderNote(reminderNote)
        }
    }
    
    private func showNoteMenu(note: NoteProtocol) {
        console.showCanvas(note)
        
        var options: [String]
        var isReminder = false
        
        if note is TextNote {
            options = ["Изменить название", "Изменить текст", "Назад"]
        } else if let reminderNote = note as? ReminderNote {
            options = ["Изменить текст", "Переключить статус", "Назад"]
            isReminder = true
        } else {
            options = ["Назад"]
        }
        
        guard let choice = console.showMenuList(options) else {
            currentState = .home
            return
        }
        
        switch (isReminder, choice) {
        case (false, 1):
            if let textNote = note as? TextNote,
               let newName = console.readString("Новое название: ") {
                var model = textNote.data
                model.name = newName
                textNote.update(model)
            }
            
        case (false, 2):
            if let textNote = note as? TextNote,
               let newText = console.readString("Новый текст: ") {
                var model = textNote.data
                model.text = newText
                textNote.update(model)
            }
            
        case (true, 1):
            if let reminderNote = note as? ReminderNote,
               let newText = console.readString("Новычй текст: ") {
                var model = reminderNote.data
                model.text = newText
                reminderNote.update(model)
            }
            
        case (true, 2):
            if let reminderNote = note as? ReminderNote {
                var model = reminderNote.data
                model.isDone.toggle()
                reminderNote.update(model)
                print(" Статус обновлен: \(model.isDone ? " Выполнено" : " Не выполнено")")
            }
            
        default:
            currentState = .home
        }
    }
    
    private func removeNote(at index: Int) {
        let notes = notebook.getAllNotes()
        let note = notes[index]
        
        note.willRemove()
        notebook.remove(at: index)
        
        print(" Заметка удалена!")
    }
}
