import java.util.UUID

class Menu(
    private val console: ConsoleUI,
    private val notebook: Notebook
) {
    private enum class State {
        HOME,
        TEXT_NOTE,
        REMINDER_NOTE,
        TEXT_NEW_NOTE,
        REMINDER_NEW_NOTE
    }

    private var currentState: State = State.HOME
    private var currentNote: NoteProtocol? = null

    fun run() {
        var shouldExit = false

        while (!shouldExit) {
            when (currentState) {
                State.HOME -> shouldExit = showHomeMenu()
                State.TEXT_NOTE -> showNoteMenu()
                State.REMINDER_NOTE -> showNoteMenu()
                State.TEXT_NEW_NOTE -> createNewTextNote()
                State.REMINDER_NEW_NOTE -> createNewReminderNote()
            }
        }
        println("До свидания!")
    }

    private fun showHomeMenu(): Boolean {
        console.showCanvas(notebook)

        val menuOptions = listOf(
            "Редактировать заметку",
            "Добавить новую заметку",
            "Удалить заметку",
            "Выйти из приложения"
        )

        return when (console.showMenuList(menuOptions)) {
            1 -> {
                selectNoteIndex()?.let { editNoteAt(it) }
                false
            }
            2 -> {
                showAddNoteMenu()
                false
            }
            3 -> {
                selectNoteIndex()?.let { removeNoteAt(it) }
                false
            }
            4 -> true
            else -> {
                println("Неверный ввод")
                false
            }
        }
    }

    private fun selectNoteIndex(): Int? {
        val notes = notebook.getAllNotes()
        if (notes.isEmpty()) {
            println("Заметок нет")
            return null
        }

        val index = console.readInt("Выберите номер заметки (1-${notes.size})") ?: return null
        val adjustedIndex = index - 1

        return if (adjustedIndex in notes.indices) adjustedIndex else {
            println("Неверный номер заметки")
            null
        }
    }

    private fun showAddNoteMenu() {
        val addOptions = listOf(
            "Текстовая заметка",
            "Заметка-напоминание"
        )

        when (console.showMenuList(addOptions)) {
            1 -> currentState = State.TEXT_NEW_NOTE
            2 -> currentState = State.REMINDER_NEW_NOTE
            else -> println("Неверный ввод")
        }
    }

    private fun createNewTextNote() {
        println("\nСоздание текстовой заметки")

        val name = console.readString("Введите название:") ?: run {
            println("Отмена создания заметки")
            currentState = State.HOME
            return
        }

        val text = console.readString("Введите текст:") ?: run {
            println("Отмена создания заметки")
            currentState = State.HOME
            return
        }

        val textNote = notebook.createTextNote(name, text)
        notebook.add(textNote)
        println("Текстовая заметка создана!")
        currentState = State.HOME
    }

    private fun createNewReminderNote() {
        println("\nСоздание заметки-напоминания")

        val text = console.readString("Введите текст напоминания:") ?: run {
            println("Отмена создания заметки")
            currentState = State.HOME
            return
        }

        val reminderNote = notebook.createReminderNote(text)
        notebook.add(reminderNote)
        println("Заметка-напоминание создана!")
        currentState = State.HOME
    }

    private fun editNoteAt(index: Int) {
        val note = notebook.getAllNotes()[index]
        currentNote = note
        currentState = when (note) {
            is TextNote -> State.TEXT_NOTE
            is ReminderNote -> State.REMINDER_NOTE
            else -> State.HOME
        }
    }

    private fun showNoteMenu() {
        currentNote?.let { console.showCanvas(it) }

        val options = when (currentNote) {
            is TextNote -> listOf("Изменить название", "Изменить текст", "Назад")
            is ReminderNote -> listOf("Изменить текст", "Переключить статус", "Назад")
            else -> listOf("Назад")
        }

        when (console.showMenuList(options)) {
            1 -> when (currentNote) {
                is TextNote -> updateTextNoteName()
                is ReminderNote -> updateReminderText()
                else -> Unit
            }
            2 -> when (currentNote) {
                is TextNote -> updateTextNoteText()
                is ReminderNote -> toggleReminderStatus()
                else -> Unit
            }
            else -> {
                currentState = State.HOME
                currentNote = null
            }
        }
    }

    private fun updateTextNoteName() {
        (currentNote as? TextNote)?.let { note ->
            console.readString("Новое название:")?.let { newName ->
                val newData = note.data.copy(name = newName)
                note.update(newData)
                println("Название обновлено")
            }
        }
    }

    private fun updateTextNoteText() {
        (currentNote as? TextNote)?.let { note ->
            console.readString("Новый текст:")?.let { newText ->
                val newData = note.data.copy(text = newText)
                note.update(newData)
                println("Текст обновлен")
            }
        }
    }

    private fun updateReminderText() {
        (currentNote as? ReminderNote)?.let { note ->
            console.readString("Новый текст:")?.let { newText ->
                val newData = note.data.copy(text = newText)
                note.update(newData)
                println("Текст обновлен")
            }
        }
    }

    private fun toggleReminderStatus() {
        (currentNote as? ReminderNote)?.let { note ->
            val newData = note.data.copy(isDone = !note.data.isDone)
            note.update(newData)
            println("Статус обновлен: ${if (newData.isDone) "Выполнено" else "Не выполнено"}")
        }
    }

    private fun removeNoteAt(index: Int) {
        notebook.removeAt(index)
        println("Заметка удалена!")
    }
}