class NoteApp {

    private let textStorage = Storage<TextNoteModel>()
    private let reminderStorage = Storage<ReminderNoteModel>()
    private var notebook: Notebook!
    private var consoleUI: ConsoleUI!
    private var menu: Menu!
    

    func run() {
        setupDependencies()
        start()
    }
    

    private func setupDependencies() {

        notebook = Notebook(
            textNoteStorage: textStorage,
            reminderNoteStorage: reminderStorage
        )
        

        consoleUI = ConsoleUI()
        

        menu = Menu(console: consoleUI, notebook: notebook)
        

        setupTestData()
    }
    

    private func start() {
        print("Добро пожаловать в  Заметки!")
        menu.run()
    }
    

    private func setupTestData() {

        let textModel = TextNoteModel(
            id: "1",
            name: "Мои идеи",
            text: "Нужно реализовать крутое приложение"
        )
        
        let reminderModel = ReminderNoteModel(
            id: "2",
            text: "Сделать домашнее задание",
            isDone: false
        )
        

        let textNote = TextNote(data: textModel, storage: textStorage)
        let reminderNote = ReminderNote(data: reminderModel, storage: reminderStorage)
        
        notebook.add( textNote)
        notebook.add( reminderNote)
    }
}
