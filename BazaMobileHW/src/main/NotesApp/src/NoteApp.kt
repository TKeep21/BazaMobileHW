class NoteApp {
    private val notebook = Notebook()
    private val consoleUI = ConsoleUI()
    private val menu = Menu(consoleUI, notebook)

    fun run() {
        setupTestData()
        start()
    }

    private fun start() {
        println("Добро пожаловать в Заметки!")
        menu.run()
    }

    private fun setupTestData() {
        val textNote = notebook.createTextNote("Мои идеи", "Нужно реализовать крутое приложение")
        val reminderNote = notebook.createReminderNote("Сделать домашнее задание")

        notebook.add(textNote)
        notebook.add(reminderNote)
    }
}