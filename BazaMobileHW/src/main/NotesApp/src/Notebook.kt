import java.util.UUID

class Notebook : CanvasUnit {
    override val id: String = "notebook_main"

    private val textStorage = Storage<TextNoteModel>()
    private val reminderStorage = Storage<ReminderNoteModel>()
    private val notes = mutableListOf<NoteProtocol>()

    fun createTextNote(name: String, text: String): TextNote {
        val model = TextNoteModel(
            id = UUID.randomUUID().toString(),
            name = name,
            text = text
        )
        return TextNote(model, textStorage)
    }

    fun createReminderNote(text: String): ReminderNote {
        val model = ReminderNoteModel(
            id = UUID.randomUUID().toString(),
            text = text,
            isDone = false
        )
        return ReminderNote(model, reminderStorage)
    }

    fun add(note: NoteProtocol) {
        notes.add(note)
    }

    fun removeAt(index: Int) {
        if (index in notes.indices) {
            val note = notes[index]
            note.willRemove()
            notes.removeAt(index)
        }
    }

    fun getAllNotes(): List<NoteProtocol> {
        return notes.toList()
    }

    override fun drawCanvas(): String {
        if (notes.isEmpty()) {
            return "Заметок нет"
        }

        val result = StringBuilder("Текущие заметки:")
        notes.forEachIndexed { index, note ->
            result.append("\n${index + 1}. ${note.drawCanvas()}\n")
        }
        return result.toString()
    }
}